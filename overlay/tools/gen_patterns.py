"""Makes src/patterns.inc: the byte patterns the overlay finds the game's code with.

    python -I gen_patterns.py <witcher3.exe> <patterns.inc>

Run it on an exe whose addresses are known (they're below). Each target gets the shortest pattern that
matches exactly once. Branch targets and RIP-relative addresses are wildcards, as a patch moves those. Struct
offsets are left in: if one changes, the code means something else, and not matching is the right answer.
"""
import re
import sys

import pefile
from capstone import CS_ARCH_X86, CS_MODE_64, Cs
from capstone.x86 import X86_OP_IMM, X86_OP_MEM, X86_REG_RIP

# Known addresses, for build 0x6ADFBD7A
OWN_BYTES = {
    "GetRTTI": 0x031F8D0,
    "AddName": 0x26B7A90,
    "FindGlobalFunction": 0x26CB380,
    "CallDirect": 0x26FBD80,
    "CallGlobalExec": 0x270C1D0,
    "ScriptTick": 0x270CF60,
    "InputUpdate": 0x1E66B90,
}
CALL_GLOBAL_EXEC = 0x270C1D0
FREE = 0x0BCB6F0               # 24 copies of this exist, one per memory pool: only a real caller says which it is
FREE_CALLS = (0x270C2CD, 0x270C519, 0x270C58A, 0x270C5B2, 0x270C5C4)   # inside CallGlobalExec
READY_CHECK_SITE = 0x26DD002   # cmp byte ptr [reg + 0x174], 0: the flag that says scripts are ready

MAX_BYTES = 96
MARGIN = 8   # bytes past the point of being unique, so a chance match elsewhere later doesn't make it ambiguous

md = Cs(CS_ARCH_X86, CS_MODE_64)
md.detail = True


def masked(insn):
    """The instruction's bytes, with None where a patch would move something."""
    out = list(insn.bytes)
    for op in insn.operands:
        if op.type == X86_OP_MEM and op.value.mem.base == X86_REG_RIP and insn.disp_offset:
            for i in range(insn.disp_offset, insn.disp_offset + insn.disp_size):
                out[i] = None
    if insn.group(1) or insn.group(2) or insn.group(7):   # jump, call, relative branch
        if insn.imm_offset and any(op.type == X86_OP_IMM for op in insn.operands):
            for i in range(insn.imm_offset, insn.imm_offset + insn.imm_size):
                out[i] = None
    return out


def matches(code, pattern, limit=2):
    regex = re.compile(b"".join(b"." if b is None else re.escape(bytes([b])) for b in pattern), re.S)
    n = 0
    for _ in regex.finditer(code):
        n += 1
        if n >= limit:
            break
    return n


def grow(code, start, name):
    pattern = []
    unique_at = None
    for insn in md.disasm(code[start:start + 400], 0):
        pattern.extend(masked(insn))
        if unique_at is None and sum(b is not None for b in pattern) >= 8 and matches(code, pattern) == 1:
            unique_at = len(pattern)
        if unique_at is not None and len(pattern) >= unique_at + MARGIN:
            break
        if len(pattern) >= MAX_BYTES or insn.mnemonic in ("ret", "int3"):
            break
    if unique_at is None:
        raise SystemExit(f"{name}: no unique pattern from its own bytes")
    while pattern[-1] is None:
        pattern.pop()
    return pattern


def text(pattern):
    return " ".join("??" if b is None else f"{b:02X}" for b in pattern)


def main():
    pe = pefile.PE(sys.argv[1], fast_load=True)
    section = next(s for s in pe.sections if s.Name.rstrip(b"\0") == b".text")
    base = section.VirtualAddress
    code = section.get_data()

    lines = [f"// Made by tools/gen_patterns.py from build 0x{pe.FILE_HEADER.TimeDateStamp:08X}. Don't edit by hand."]
    def add(name, kind, pattern, at=0, end=0):
        lines.append(f'{{ "{name}", {kind}, "{pattern if isinstance(pattern, str) else text(pattern)}", {at}, {end} }},')
        print(f"{name:20} {kind:16} {len(pattern.split()) if isinstance(pattern, str) else len(pattern)} bytes")

    # Free, through a call to it in CallGlobalExec
    walk = list(md.disasm(code[CALL_GLOBAL_EXEC - base:CALL_GLOBAL_EXEC - base + 0x500], CALL_GLOBAL_EXEC))
    addresses = [i.address for i in walk]
    best = None
    for site in FREE_CALLS:
        index = addresses.index(site)
        assert walk[index].mnemonic == "call"
        assert site + 5 + int.from_bytes(walk[index].bytes[1:5], "little", signed=True) == FREE
        for lead in (3, 4, 5, 6):
            start = addresses[index - lead]
            try:
                pattern = grow(code, start - base, "Free")
            except SystemExit:
                continue
            at = site - start + 1
            if len(pattern) > at + 4 and (best is None or len(pattern) < len(best[0])):
                best = (pattern, at)
            break
    assert best, "Free: no call in CallGlobalExec gives a unique pattern"
    add("Free", "kCall", best[0], best[1], 0)

    tick = None
    for name, rva in OWN_BYTES.items():
        pattern = grow(code, rva - base, name)
        add(name, "kFunction", pattern)
        if name == "ScriptTick":
            tick = pattern

    # The tick loads the scripting object first thing: mov rdi, [rip + disp] at +26
    assert tick[26:29] == [0x48, 0x8B, 0x3D] and len(tick) >= 33
    add("ScriptingPtr", "kGlobal", tick, 29, 33)

    # A CName static is filled in by code holding the name's hash: mov edx, hash; lea rcx, [rip + disp]
    for name, value in (("NamePs4Pad", 0x67ADDC3F), ("NamePs5Pad", 0x2AFFDB4C), ("NameXPad", 0x7C1BD5F8)):
        h = value.to_bytes(4, "little")
        add(name, "kGlobal", [0xBA, *h, 0x48, 0x8D, 0x0D, None, None, None, None, 0xE8], 8, 12)

    # Struct offsets that aren't in the patterns above have to be seen in use, or the link stays off
    add("ScriptsReadyFlag", "kCheck", grow(code, READY_CHECK_SITE - base, "ScriptsReadyFlag"))
    add("InputLastDevice", "kInsideInputUpdate", [0x89, 0x8E, 0x9C, 0x04, 0x00, 0x00])

    # The name table's getter is one of many identical singletons, but nothing is looked up by a literal string more
    # often: call getter; lea rdx, [text]; mov rcx, rax; call. Only the type table's comes close, and that's known.
    add("GetNames", "kMostUsedLookup", "E8 ?? ?? ?? ?? 48 8D 15 ?? ?? ?? ?? 48 8B C8 E8 ?? ?? ?? ??", 1, 0)

    open(sys.argv[2], "w", encoding="utf-8", newline="\n").write("\n".join(lines) + "\n")


if __name__ == "__main__":
    main()
