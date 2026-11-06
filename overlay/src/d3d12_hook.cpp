// Watches the game create its swapchain, then hooks Present a few seconds later and draws ImGui
// onto the real back buffer. The wait matters: overlays such as Steam's hook Present around that
// time and take whatever is in the vtable for the real function. Hooked before them, they detour
// our hook and the two call each other until the stack runs out. Hooked after them, we wrap theirs.
#include <deque>
#include <utility>
#include <vector>
#include <map>
#include <windows.h>
#include <d3d12.h>
#include <dxgi1_6.h>
#include <imgui.h>
#include <imgui_impl_dx12.h>
#include <imgui_impl_win32.h>
#include <algorithm>
#include <atomic>
#include <cmath>
#include <cwchar>
#include <mutex>
#include "log.h"
#include "gameicons.h"
#include "modelview.h"
#include "overlay.h"
#include "settings.h"

void ReleaseRetired();

namespace
{
	using Present_t = HRESULT(STDMETHODCALLTYPE*)(IDXGISwapChain*, UINT, UINT);
	using Present1_t = HRESULT(STDMETHODCALLTYPE*)(IDXGISwapChain1*, UINT, UINT, const DXGI_PRESENT_PARAMETERS*);
	using CreateSwapChain_t = HRESULT(STDMETHODCALLTYPE*)(IDXGIFactory*, IUnknown*, DXGI_SWAP_CHAIN_DESC*, IDXGISwapChain**);
	using CreateSwapChainForHwnd_t = HRESULT(STDMETHODCALLTYPE*)(IDXGIFactory2*, IUnknown*, HWND, const DXGI_SWAP_CHAIN_DESC1*, const DXGI_SWAP_CHAIN_FULLSCREEN_DESC*, IDXGIOutput*, IDXGISwapChain1**);

	Present_t oPresent;
	Present1_t oPresent1;
	CreateSwapChain_t oCreateSwapChain;
	CreateSwapChainForHwnd_t oCreateForHwnd;

	using SetColorSpace1_t = HRESULT(STDMETHODCALLTYPE*)(IDXGISwapChain3*, DXGI_COLOR_SPACE_TYPE);
	SetColorSpace1_t oSetColorSpace1;

	constexpr UINT kMaxBuffers = 16;
	constexpr UINT kImGuiSrvs = 8;     // ImGui's own, for the fonts
	constexpr UINT kIconSrvs = 512;   // the popups' icons and every Gwent card
	constexpr UINT kUiSlot = kImGuiSrvs + kIconSrvs;   // then the window as drawn, and a copy of the game's frame, side by side
	constexpr UINT kSceneSlot = kUiSlot + 1;
	constexpr UINT kSrvCount = kSceneSlot + 1;
	constexpr UINT kUiRtv = kMaxBuffers;   // the RTV after the back buffers'

	// ImGui always draws in plain SDR onto a texture of ours, which is then laid over the game's frame in whatever
	// it presents: as it is for SDR, or turned into the HDR signal for scRGB and HDR10 (PQ).
	constexpr DXGI_FORMAT kUiFormat = DXGI_FORMAT_R8G8B8A8_UNORM;
	enum ColourMode { kSdr = 0, kScRgb = 1, kPq = 2 };
	const char* const kModeNames[3] = { "SDR", "HDR scRGB (16-bit)", "HDR10 PQ (10-bit)" };

	// Blending happens as an SDR screen would do it, in sRGB's curve, with the game's light measured against paper
	// white. Blending in the HDR signal itself would make Dim the Game far darker than it is in SDR.
	constexpr char kComposite[] = R"(
cbuffer C : register(b0) { uint mode; float paper; float2 unused; };
Texture2D<float4> ui : register(t0);
Texture2D<float4> scene : register(t1);
float4 VS(uint id : SV_VertexID) : SV_Position
{
	float2 uv = float2((id << 1) & 2, id & 2);
	return float4(uv * float2(2, -2) + float2(-1, 1), 0, 1);
}
float3 Decode(float3 c) { float3 a = abs(c); return sign(c) * (a <= 0.04045 ? a / 12.92 : pow((a + 0.055) / 1.055, 2.4)); }
float3 Encode(float3 l) { float3 a = abs(l); return sign(l) * (a <= 0.0031308 ? a * 12.92 : 1.055 * pow(a, 1 / 2.4) - 0.055); }
static const float m1 = 0.1593017578125, m2 = 78.84375, c1 = 0.8359375, c2 = 18.8515625, c3 = 18.6875;
float3 ToPq(float3 l) { float3 p = pow(saturate(l), m1); return pow((c1 + c2 * p) / (1 + c3 * p), m2); }
float3 FromPq(float3 n) { float3 p = pow(saturate(n), 1 / m2); return pow(max(p - c1, 0) / (c2 - c3 * p), 1 / m1); }
static const float3x3 To2020 = { 0.627404, 0.329283, 0.043313, 0.069097, 0.919540, 0.011362, 0.016391, 0.088013, 0.895595 };
static const float3x3 To709 = { 1.660491, -0.587641, -0.072850, -0.124550, 1.132900, -0.008349, -0.018151, -0.100579, 1.118730 };
float4 PS(float4 pos : SV_Position) : SV_Target
{
	int3 at = int3(pos.xy, 0);
	float4 u = ui.Load(at);   // premultiplied, as ImGui leaves it on a clear texture
	if (mode == 0)
		return u;   // blended by the pipeline, the same as drawing straight on
	float4 s = scene.Load(at);
	if (u.a <= 0)
		return s;   // just as the game left it
	// In Rec.709, as SDR blends: the game's colours past it go negative, which the curve carries through and back
	float3 sceneRel = mode == 2 ? mul(To709, FromPq(s.rgb)) * (10000 / paper) : s.rgb * (80 / paper);
	float3 straight = saturate(u.rgb / u.a);
	float3 l = Decode(straight * u.a + Encode(sceneRel) * (1 - u.a));
	return mode == 2 ? float4(ToPq(mul(To2020, l) * (paper / 10000)), s.a) : float4(l * (paper / 80), s.a);
}
)";

	struct Frame
	{
		ID3D12CommandAllocator* allocator = nullptr;
		UINT64 fenceValue = 0;
	};

	struct Renderer
	{
		bool ready = false;
		bool failed = false;
		IDXGISwapChain3* swapchain = nullptr;
		ID3D12Device* device = nullptr;
		ID3D12CommandQueue* queue = nullptr;
		ID3D12DescriptorHeap* rtvHeap = nullptr;
		ID3D12DescriptorHeap* srvHeap = nullptr;
		UINT rtvSize = 0, srvSize = 0, srvNext = 0;
		ID3D12GraphicsCommandList* list = nullptr;
		ID3D12Fence* fence = nullptr;
		HANDLE fenceEvent = nullptr;
		UINT64 fenceNext = 0;
		Frame frames[kMaxBuffers];
		UINT frameCount = 1;      // frames in flight: one slot per submission, in turn
		UINT64 submits = 0;       // frames we've sent, which is also how ImGui's own buffer ring moves
		DXGI_FORMAT format = DXGI_FORMAT_UNKNOWN;   // the back buffer's, as viewed
		int mode = -1;

		// What ImGui draws on, and the copy of the game's frame HDR blends with
		ID3D12Resource* uiTarget = nullptr, * scene = nullptr;
		UINT64 targetW = 0;
		UINT targetH = 0;
		DXGI_FORMAT sceneFormat = DXGI_FORMAT_UNKNOWN;
		ID3DBlob* compVs = nullptr, * compPs = nullptr;
		ID3D12RootSignature* compRoot = nullptr;
		ID3D12PipelineState* compBlend = nullptr, * compHdr = nullptr;   // SDR blends in the pipeline, HDR in the shader
		DXGI_FORMAT compFormat = DXGI_FORMAT_UNKNOWN;
	} r;

	std::atomic<int> g_colourSpace{ -1 };   // what the game last gave SetColorSpace1, -1 before it has

	// Waits for the card to pass value, in short steps that notice a removed device. False if it hasn't by maxMs,
	// or the device has gone: then nothing it may still be using must be reset or freed.
	bool WaitForFence(UINT64 value, DWORD maxMs)
	{
		if (r.fence->GetCompletedValue() >= value)
			return true;
		const ULONGLONG until = GetTickCount64() + maxMs;
		while (r.fence->GetCompletedValue() < value)
		{
			const HRESULT removed = r.device->GetDeviceRemovedReason();
			if (removed != S_OK)
			{
				Log("the device was removed (0x%08lx): the overlay stops drawing", static_cast<unsigned long>(removed));
				r.failed = true;
				return false;
			}
			if (GetTickCount64() >= until)
				return false;
			r.fence->SetEventOnCompletion(value, r.fenceEvent);
			WaitForSingleObject(r.fenceEvent, 50);
		}
		return true;
	}

	constexpr DWORD kHookDelayMs = 5000;

	std::mutex g_queueMutex;
	ID3D12CommandQueue* g_swapQueue = nullptr;   // queue given to CreateSwapChain*
	std::atomic<IDXGISwapChain*> g_createdSwapchain{ nullptr };
	std::atomic<unsigned long long> g_presents{ 0 };
	thread_local int g_inPresent = 0;
	float g_fontScale = 1.f;

	template <class T>
	bool PatchVtable(void* object, int slot, T hook, T& original)
	{
		void** table = *static_cast<void***>(object);
		DWORD old;
		if (!VirtualProtect(&table[slot], sizeof(void*), PAGE_READWRITE, &old))
			return false;
		original = reinterpret_cast<T>(table[slot]);
		table[slot] = reinterpret_cast<void*>(hook);
		VirtualProtect(&table[slot], sizeof(void*), old, &old);
		return true;
	}

	// Whether the game's in HDR, and which kind, is only said here: the format alone can't tell HDR10 from 10-bit SDR
	HRESULT STDMETHODCALLTYPE hkSetColorSpace1(IDXGISwapChain3* sc, DXGI_COLOR_SPACE_TYPE space)
	{
		const HRESULT hr = oSetColorSpace1(sc, space);
		if (SUCCEEDED(hr) && g_colourSpace.exchange(static_cast<int>(space)) != static_cast<int>(space))
			Log("the game set the colour space to %d", static_cast<int>(space));
		return hr;
	}

	void RememberSwapchain(IUnknown* device, IDXGISwapChain* swapchain)
	{
		ID3D12CommandQueue* queue = nullptr;
		if (!swapchain || !device || FAILED(device->QueryInterface(IID_PPV_ARGS(&queue))))
			return;
		{
			std::lock_guard lock(g_queueMutex);
			g_swapQueue = queue;   // both kept referenced on purpose
		}
		// Hooked at once, as the game sets the colour space straight after making the swapchain. Nothing else
		// (Steam's overlay, say) is known to hook this one, so there's no reason to wait as Present does.
		g_colourSpace = -1;
		IDXGISwapChain3* swapchain3 = nullptr;
		if (SUCCEEDED(swapchain->QueryInterface(IID_PPV_ARGS(&swapchain3))))
		{
			void** table = *reinterpret_cast<void***>(swapchain3);
			if (table[38] != reinterpret_cast<void*>(hkSetColorSpace1))
				PatchVtable(swapchain3, 38, hkSetColorSpace1, oSetColorSpace1);
			swapchain3->Release();
		}
		swapchain->AddRef();
		Log("swapchain %p created on queue %p", swapchain, queue);
		g_createdSwapchain = swapchain;
	}

	HRESULT STDMETHODCALLTYPE hkCreateSwapChain(IDXGIFactory* f, IUnknown* dev, DXGI_SWAP_CHAIN_DESC* d, IDXGISwapChain** out)
	{
		const HRESULT hr = oCreateSwapChain(f, dev, d, out);
		if (SUCCEEDED(hr) && out)
			RememberSwapchain(dev, *out);
		return hr;
	}

	HRESULT STDMETHODCALLTYPE hkCreateForHwnd(IDXGIFactory2* f, IUnknown* dev, HWND h, const DXGI_SWAP_CHAIN_DESC1* d, const DXGI_SWAP_CHAIN_FULLSCREEN_DESC* fs, IDXGIOutput* o, IDXGISwapChain1** out)
	{
		const HRESULT hr = oCreateForHwnd(f, dev, h, d, fs, o, out);
		if (SUCCEEDED(hr) && out)
			RememberSwapchain(dev, *out);
		return hr;
	}

	void SrvAlloc(ImGui_ImplDX12_InitInfo*, D3D12_CPU_DESCRIPTOR_HANDLE* cpu, D3D12_GPU_DESCRIPTOR_HANDLE* gpu)
	{
		const UINT i = r.srvNext++ % kImGuiSrvs;
		cpu->ptr = r.srvHeap->GetCPUDescriptorHandleForHeapStart().ptr + i * r.srvSize;
		gpu->ptr = r.srvHeap->GetGPUDescriptorHandleForHeapStart().ptr + i * r.srvSize;
	}
	void SrvFree(ImGui_ImplDX12_InitInfo*, D3D12_CPU_DESCRIPTOR_HANDLE, D3D12_GPU_DESCRIPTOR_HANDLE) {}

	template <class T>
	void Drop(T*& object)
	{
		if (object)
			object->Release();
		object = nullptr;
	}

	D3D12_CPU_DESCRIPTOR_HANDLE SrvCpu(UINT slot)
	{
		D3D12_CPU_DESCRIPTOR_HANDLE h = r.srvHeap->GetCPUDescriptorHandleForHeapStart();
		h.ptr += slot * r.srvSize;
		return h;
	}

	D3D12_CPU_DESCRIPTOR_HANDLE RtvCpu(UINT slot)
	{
		D3D12_CPU_DESCRIPTOR_HANDLE h = r.rtvHeap->GetCPUDescriptorHandleForHeapStart();
		h.ptr += slot * r.rtvSize;
		return h;
	}

	void ViewTexture(ID3D12Resource* image, DXGI_FORMAT format, UINT slot)
	{
		D3D12_SHADER_RESOURCE_VIEW_DESC view{};
		view.Format = format;
		view.ViewDimension = D3D12_SRV_DIMENSION_TEXTURE2D;
		view.Shader4ComponentMapping = D3D12_DEFAULT_SHADER_4_COMPONENT_MAPPING;
		view.Texture2D.MipLevels = 1;
		r.device->CreateShaderResourceView(image, &view, SrvCpu(slot));   // a null image makes a view that reads nothing
	}

	// Everything sent so far finished, so what it uses can be changed. False if the card didn't get there.
	bool WaitIdle()
	{
		const UINT64 value = ++r.fenceNext;
		r.queue->Signal(r.fence, value);
		return WaitForFence(value, 2000);
	}

	DXGI_FORMAT RtvFormat(DXGI_FORMAT f);

	int ModeFor(DXGI_FORMAT view)
	{
		const int space = g_colourSpace.load();
		if (space == DXGI_COLOR_SPACE_RGB_FULL_G2084_NONE_P2020 && (view == DXGI_FORMAT_R10G10B10A2_UNORM || view == DXGI_FORMAT_R16G16B16A16_FLOAT))
			return kPq;
		// A 16-bit float swapchain is linear scRGB unless the game says otherwise, as Windows treats it
		if (view == DXGI_FORMAT_R16G16B16A16_FLOAT && (space == -1 || space == DXGI_COLOR_SPACE_RGB_FULL_G10_NONE_P709))
			return kScRgb;
		return kSdr;
	}

	// White for the window, in nits: the game's Paper White, or the setting, never past the TV's peak
	float PaperWhite()
	{
		const Settings& st = GetSettings();
		float paper = st.hdrBrightness, peak = 0.f;
		float game = 0.f, gamePeak = 0.f;
		if (st.hdrMatchGame && GameHdrLevels(game, gamePeak))
		{
			paper = game;
			peak = gamePeak;
		}
		if (peak > 0.f)
			paper = std::min(paper, peak);
		return std::clamp(paper, 80.f, 10000.f);
	}

	bool MakeCompositeShaders()
	{
		using Compile_t = HRESULT(WINAPI*)(LPCVOID, SIZE_T, LPCSTR, const D3D_SHADER_MACRO*, ID3DInclude*, LPCSTR, LPCSTR, UINT, UINT, ID3DBlob**, ID3DBlob**);
		HMODULE compiler = LoadLibraryW(L"d3dcompiler_47.dll");
		const auto compile = compiler ? reinterpret_cast<Compile_t>(GetProcAddress(compiler, "D3DCompile")) : nullptr;
		if (!compile)
			return Log("the shader compiler isn't on this computer"), false;
		ID3DBlob* errors = nullptr;
		if (FAILED(compile(kComposite, sizeof(kComposite) - 1, "composite", nullptr, nullptr, "VS", "vs_5_0", 0, 0, &r.compVs, &errors))
			|| FAILED(compile(kComposite, sizeof(kComposite) - 1, "composite", nullptr, nullptr, "PS", "ps_5_0", 0, 0, &r.compPs, &errors)))
		{
			Log("composite shader: %s", errors ? static_cast<const char*>(errors->GetBufferPointer()) : "?");
			Drop(errors);
			return false;
		}

		D3D12_DESCRIPTOR_RANGE range{ D3D12_DESCRIPTOR_RANGE_TYPE_SRV, 2, 0, 0, 0 };
		D3D12_ROOT_PARAMETER params[2]{};
		params[0].ParameterType = D3D12_ROOT_PARAMETER_TYPE_32BIT_CONSTANTS;
		params[0].Constants.Num32BitValues = 4;
		params[0].ShaderVisibility = D3D12_SHADER_VISIBILITY_PIXEL;
		params[1].ParameterType = D3D12_ROOT_PARAMETER_TYPE_DESCRIPTOR_TABLE;
		params[1].DescriptorTable.NumDescriptorRanges = 1;
		params[1].DescriptorTable.pDescriptorRanges = &range;
		params[1].ShaderVisibility = D3D12_SHADER_VISIBILITY_PIXEL;
		D3D12_ROOT_SIGNATURE_DESC rootDesc{ 2, params, 0, nullptr, D3D12_ROOT_SIGNATURE_FLAG_NONE };
		ID3DBlob* serialized = nullptr;
		const bool ok = SUCCEEDED(D3D12SerializeRootSignature(&rootDesc, D3D_ROOT_SIGNATURE_VERSION_1, &serialized, &errors))
			&& SUCCEEDED(r.device->CreateRootSignature(0, serialized->GetBufferPointer(), serialized->GetBufferSize(), IID_PPV_ARGS(&r.compRoot)));
		Drop(serialized);
		Drop(errors);
		return ok ? true : (Log("composite root signature failed"), false);
	}

	bool MakeCompositePipelines(DXGI_FORMAT format)
	{
		Drop(r.compBlend);
		Drop(r.compHdr);
		r.compFormat = DXGI_FORMAT_UNKNOWN;
		D3D12_GRAPHICS_PIPELINE_STATE_DESC pso{};
		pso.pRootSignature = r.compRoot;
		pso.VS = { r.compVs->GetBufferPointer(), r.compVs->GetBufferSize() };
		pso.PS = { r.compPs->GetBufferPointer(), r.compPs->GetBufferSize() };
		pso.PrimitiveTopologyType = D3D12_PRIMITIVE_TOPOLOGY_TYPE_TRIANGLE;
		pso.NumRenderTargets = 1;
		pso.RTVFormats[0] = format;
		pso.SampleDesc.Count = 1;
		pso.SampleMask = UINT_MAX;
		pso.RasterizerState.FillMode = D3D12_FILL_MODE_SOLID;
		pso.RasterizerState.CullMode = D3D12_CULL_MODE_NONE;
		D3D12_RENDER_TARGET_BLEND_DESC& blend = pso.BlendState.RenderTarget[0];
		blend.RenderTargetWriteMask = D3D12_COLOR_WRITE_ENABLE_ALL;
		if (FAILED(r.device->CreateGraphicsPipelineState(&pso, IID_PPV_ARGS(&r.compHdr))))
			return Log("composite pipeline failed for format %d", format), false;
		blend.BlendEnable = TRUE;
		blend.SrcBlend = blend.SrcBlendAlpha = D3D12_BLEND_ONE;
		blend.DestBlend = blend.DestBlendAlpha = D3D12_BLEND_INV_SRC_ALPHA;
		blend.BlendOp = blend.BlendOpAlpha = D3D12_BLEND_OP_ADD;
		if (FAILED(r.device->CreateGraphicsPipelineState(&pso, IID_PPV_ARGS(&r.compBlend))))
			return Log("composite pipeline failed for format %d", format), false;
		r.compFormat = format;
		return true;
	}

	ID3D12Resource* MakeTexture(UINT64 width, UINT height, DXGI_FORMAT format, D3D12_RESOURCE_FLAGS flags, const D3D12_CLEAR_VALUE* clear)
	{
		D3D12_HEAP_PROPERTIES heap{ D3D12_HEAP_TYPE_DEFAULT };
		D3D12_RESOURCE_DESC desc{};
		desc.Dimension = D3D12_RESOURCE_DIMENSION_TEXTURE2D;
		desc.Width = width;
		desc.Height = height;
		desc.DepthOrArraySize = 1;
		desc.MipLevels = 1;
		desc.Format = format;
		desc.SampleDesc.Count = 1;
		desc.Flags = flags;
		ID3D12Resource* image = nullptr;
		r.device->CreateCommittedResource(&heap, D3D12_HEAP_FLAG_NONE, &desc, D3D12_RESOURCE_STATE_PIXEL_SHADER_RESOURCE, clear, IID_PPV_ARGS(&image));
		return image;
	}

	// Our textures and pipelines to suit the back buffer as it is now. They're only remade when it changes (a new
	// size, or HDR turned on or off), after the card has finished with the old ones. False to skip the frame.
	bool PrepareComposite(const D3D12_RESOURCE_DESC& buffer, int mode)
	{
		const DXGI_FORMAT view = RtvFormat(buffer.Format);
		const bool resized = !r.uiTarget || r.targetW != buffer.Width || r.targetH != buffer.Height;
		const bool reformatted = view != r.compFormat;
		const bool sceneWanted = mode != kSdr;
		const bool sceneStale = sceneWanted ? (!r.scene || resized || r.sceneFormat != buffer.Format) : r.scene != nullptr;
		if (!resized && !reformatted && !sceneStale)
			return true;
		if (!WaitIdle())
			return false;

		if (reformatted)
		{
			if (r.compFormat != DXGI_FORMAT_UNKNOWN)
				Log("back buffer format is now %d", buffer.Format);
			if (!MakeCompositePipelines(view))
			{
				r.failed = true;
				return false;
			}
		}
		if (resized)
		{
			Drop(r.uiTarget);
			const D3D12_CLEAR_VALUE clear{ kUiFormat, { 0.f, 0.f, 0.f, 0.f } };
			r.uiTarget = MakeTexture(buffer.Width, buffer.Height, kUiFormat, D3D12_RESOURCE_FLAG_ALLOW_RENDER_TARGET, &clear);
			if (!r.uiTarget)
				return Log("can't make the window's texture"), r.failed = true, false;
			r.device->CreateRenderTargetView(r.uiTarget, nullptr, RtvCpu(kUiRtv));
			ViewTexture(r.uiTarget, kUiFormat, kUiSlot);
			r.targetW = buffer.Width;
			r.targetH = buffer.Height;
		}
		if (sceneStale)
		{
			Drop(r.scene);
			r.sceneFormat = DXGI_FORMAT_UNKNOWN;
			if (sceneWanted)
			{
				r.scene = MakeTexture(buffer.Width, buffer.Height, buffer.Format, D3D12_RESOURCE_FLAG_NONE, nullptr);
				if (!r.scene)
					return Log("can't make the copy of the game's frame"), r.failed = true, false;
				r.sceneFormat = buffer.Format;
			}
			ViewTexture(r.scene, view, kSceneSlot);
		}
		return true;
	}

	DXGI_FORMAT RtvFormat(DXGI_FORMAT f)
	{
		switch (f)
		{
		case DXGI_FORMAT_R8G8B8A8_TYPELESS: return DXGI_FORMAT_R8G8B8A8_UNORM;
		case DXGI_FORMAT_B8G8R8A8_TYPELESS: return DXGI_FORMAT_B8G8R8A8_UNORM;
		case DXGI_FORMAT_R10G10B10A2_TYPELESS: return DXGI_FORMAT_R10G10B10A2_UNORM;
		case DXGI_FORMAT_R16G16B16A16_TYPELESS: return DXGI_FORMAT_R16G16B16A16_FLOAT;
		default: return f;
		}
	}

	bool InitRenderer(IDXGISwapChain* sc)
	{
		if (!r.swapchain && FAILED(sc->QueryInterface(IID_PPV_ARGS(&r.swapchain))))
			return Log("no IDXGISwapChain3"), false;
		if (!r.device && FAILED(sc->GetDevice(IID_PPV_ARGS(&r.device))))
			return Log("swapchain isn't on a D3D12 device"), false;

		{
			std::lock_guard lock(g_queueMutex);
			r.queue = g_swapQueue;
		}
		if (!r.queue)
			return false;   // try again next Present: nothing has executed yet
		Log("using queue %p", r.queue);

		DXGI_SWAP_CHAIN_DESC desc{};
		sc->GetDesc(&desc);
		r.format = RtvFormat(desc.BufferDesc.Format);
		r.frameCount = std::clamp<UINT>(desc.BufferCount, 1, kMaxBuffers);
		Log("swapchain %p: %ux%u format %d buffers %u window %p flags 0x%x effect %d", sc, desc.BufferDesc.Width, desc.BufferDesc.Height, desc.BufferDesc.Format, desc.BufferCount, desc.OutputWindow, desc.Flags, desc.SwapEffect);

		D3D12_DESCRIPTOR_HEAP_DESC heap{ D3D12_DESCRIPTOR_HEAP_TYPE_RTV, kMaxBuffers + 1, D3D12_DESCRIPTOR_HEAP_FLAG_NONE, 0 };
		if (FAILED(r.device->CreateDescriptorHeap(&heap, IID_PPV_ARGS(&r.rtvHeap))))
			return Log("rtv heap failed"), false;
		heap = { D3D12_DESCRIPTOR_HEAP_TYPE_CBV_SRV_UAV, kSrvCount, D3D12_DESCRIPTOR_HEAP_FLAG_SHADER_VISIBLE, 0 };
		if (FAILED(r.device->CreateDescriptorHeap(&heap, IID_PPV_ARGS(&r.srvHeap))))
			return Log("srv heap failed"), false;
		r.rtvSize = r.device->GetDescriptorHandleIncrementSize(D3D12_DESCRIPTOR_HEAP_TYPE_RTV);
		r.srvSize = r.device->GetDescriptorHandleIncrementSize(D3D12_DESCRIPTOR_HEAP_TYPE_CBV_SRV_UAV);
		ViewTexture(nullptr, kUiFormat, kSceneSlot);   // nothing to copy until the game's in HDR
		if (!MakeCompositeShaders())
		{
			r.failed = true;
			return false;
		}

		for (Frame& f : r.frames)
			if (FAILED(r.device->CreateCommandAllocator(D3D12_COMMAND_LIST_TYPE_DIRECT, IID_PPV_ARGS(&f.allocator))))
				return Log("allocator failed"), false;
		if (FAILED(r.device->CreateCommandList(0, D3D12_COMMAND_LIST_TYPE_DIRECT, r.frames[0].allocator, nullptr, IID_PPV_ARGS(&r.list))))
			return Log("command list failed"), false;
		r.list->Close();
		if (FAILED(r.device->CreateFence(0, D3D12_FENCE_FLAG_NONE, IID_PPV_ARGS(&r.fence))))
			return Log("fence failed"), false;
		r.fenceEvent = CreateEventW(nullptr, FALSE, FALSE, nullptr);

		IMGUI_CHECKVERSION();
		ImGui::CreateContext();
		ImGuiIO& io = ImGui::GetIO();
		io.IniFilename = nullptr;
		io.LogFilename = nullptr;
		io.ConfigFlags |= ImGuiConfigFlags_NoMouseCursorChange;   // the window draws its own
		ImGui::StyleColorsDark();
		g_fontScale = std::max(0.25f, static_cast<float>(desc.BufferDesc.Height) / 1440.f);
		UiLoadFonts(g_fontScale);

		ImGui_ImplWin32_Init(desc.OutputWindow);
		ImGui_ImplDX12_InitInfo info{};
		info.Device = r.device;
		info.CommandQueue = r.queue;
		info.NumFramesInFlight = static_cast<int>(r.frameCount);   // the same ring as ours, so waiting on our slot covers its buffers
		info.RTVFormat = kUiFormat;   // ImGui draws on our texture, never the game's
		info.SrvDescriptorHeap = r.srvHeap;
		info.SrvDescriptorAllocFn = SrvAlloc;
		info.SrvDescriptorFreeFn = SrvFree;
		if (!ImGui_ImplDX12_Init(&info))
		{
			r.failed = true;
			return Log("ImGui D3D12 init failed"), false;
		}

		AttachWindow(desc.OutputWindow);
		Log("renderer ready");
		return true;
	}

	void DrawOverlay(IDXGISwapChain* sc)
	{
		if (r.failed)
			return;
		if (!r.ready)
		{
			if (!InitRenderer(sc))
				return;
			r.ready = true;
		}

		IDXGISwapChain* ours = nullptr;
		r.swapchain->QueryInterface(IID_PPV_ARGS(&ours));
		if (ours)
			ours->Release();
		if (sc != ours)
		{
			static IDXGISwapChain* warned;
			if (warned != sc)
			{
				warned = sc;
				Log("Present from another swapchain %p (ours %p), not drawing on it", sc, ours);
			}
			return;
		}

		// ImGui always runs so its state stays current, but nothing is submitted when there's nothing to draw.
		ImDrawData* data;
		{
			std::lock_guard lock(ImGuiMutex());

			// The scale setting, or a new resolution: bake the fonts again so the text stays sharp.
			const float wanted = UiWantedFontScale();
			if (std::fabs(wanted - g_fontScale) > 0.01f)
			{
				const UINT64 value = ++r.fenceNext;
				r.queue->Signal(r.fence, value);
				if (!WaitForFence(value, 2000))
					return;   // the card's behind: try again next frame, before anything of ImGui's is touched
				ImGui_ImplDX12_InvalidateDeviceObjects();
				ImGui::GetIO().Fonts->Clear();
				UiLoadFonts(wanted);
				g_fontScale = wanted;
				Log("fonts baked again at %.2f", wanted);
			}
			ImGui_ImplDX12_NewFrame();
			ImGui_ImplWin32_NewFrame();

			// The game can render smaller than its window and let the swapchain stretch it (a 2560x1440
			// buffer on a 3840x2160 window, say). The backend reports the window: drawing has to use the buffer.
			DXGI_SWAP_CHAIN_DESC now{};
			r.swapchain->GetDesc(&now);
			ImGuiIO& io = ImGui::GetIO();
			if (now.BufferDesc.Width > 0 && now.BufferDesc.Height > 0)
			{
				const ImVec2 client = io.DisplaySize;
				io.DisplaySize = ImVec2(static_cast<float>(now.BufferDesc.Width), static_cast<float>(now.BufferDesc.Height));
				if (client.x > 0.f && client.y > 0.f)
					UiSetMouseScale(io.DisplaySize.x / client.x, io.DisplaySize.y / client.y);
				static ImVec2 logged;
				if (logged.x != client.x || logged.y != client.y)
				{
					logged = client;
					Log("window %.0fx%.0f, back buffer %.0fx%.0f", client.x, client.y, io.DisplaySize.x, io.DisplaySize.y);
				}
			}
			ImGui::NewFrame();
			DrawUi();
			ImGui::Render();
			data = ImGui::GetDrawData();
		}
		if (!data || data->CmdListsCount == 0)
			return;

		// The slot used frameCount submissions ago, by us and by ImGui's vertex and index buffers: ImGui frees and
		// remakes those when they grow, with no wait of its own. Not drawing this frame is safe; reusing early isn't.
		Frame& frame = r.frames[r.submits % r.frameCount];
		if (!WaitForFence(frame.fenceValue, 5000))
		{
			static ULONGLONG told = 0;
			if (!r.failed && GetTickCount64() - told > 10000)
			{
				told = GetTickCount64();
				Log("the card is still busy with an earlier frame: not drawing this one");
			}
			return;
		}
		const UINT index = r.swapchain->GetCurrentBackBufferIndex() % kMaxBuffers;

		// Taken per frame and let go at once, so the game's own ResizeBuffers is never blocked by our reference.
		ID3D12Resource* buffer = nullptr;
		if (FAILED(r.swapchain->GetBuffer(index, IID_PPV_ARGS(&buffer))))
			return;

		// HDR turned on or off changes the format, and the colour space says which HDR it is
		const D3D12_RESOURCE_DESC bufferDesc = buffer->GetDesc();
		const DXGI_FORMAT view = RtvFormat(bufferDesc.Format);
		const int mode = ModeFor(view);
		if (!PrepareComposite(bufferDesc, mode))
		{
			buffer->Release();
			return;
		}
		if (mode != r.mode || view != r.format)
		{
			Log("drawing for %s: format %d, colour space %d", kModeNames[mode], view, g_colourSpace.load());
			r.mode = mode;
			r.format = view;
		}

		const D3D12_CPU_DESCRIPTOR_HANDLE rtv = RtvCpu(index), uiRtv = RtvCpu(kUiRtv);
		D3D12_RENDER_TARGET_VIEW_DESC rtvDesc{};
		rtvDesc.Format = view;
		rtvDesc.ViewDimension = D3D12_RTV_DIMENSION_TEXTURE2D;
		r.device->CreateRenderTargetView(buffer, &rtvDesc, rtv);

		frame.allocator->Reset();
		r.list->Reset(frame.allocator, nullptr);

		const auto move = [&](ID3D12Resource* what, D3D12_RESOURCE_STATES from, D3D12_RESOURCE_STATES to)
		{
			D3D12_RESOURCE_BARRIER barrier{};
			barrier.Type = D3D12_RESOURCE_BARRIER_TYPE_TRANSITION;
			barrier.Transition.pResource = what;
			barrier.Transition.Subresource = D3D12_RESOURCE_BARRIER_ALL_SUBRESOURCES;
			barrier.Transition.StateBefore = from;
			barrier.Transition.StateAfter = to;
			r.list->ResourceBarrier(1, &barrier);
		};
		r.list->SetDescriptorHeaps(1, &r.srvHeap);
		ReleaseRetired();
		ModelViewRender(r.list);

		// The window, in SDR, on our own clear texture
		move(r.uiTarget, D3D12_RESOURCE_STATE_PIXEL_SHADER_RESOURCE, D3D12_RESOURCE_STATE_RENDER_TARGET);
		const float clear[4] = { 0.f, 0.f, 0.f, 0.f };
		r.list->ClearRenderTargetView(uiRtv, clear, 0, nullptr);
		r.list->OMSetRenderTargets(1, &uiRtv, FALSE, nullptr);
		r.list->SetDescriptorHeaps(1, &r.srvHeap);
		ImGui_ImplDX12_RenderDrawData(data, r.list);
		move(r.uiTarget, D3D12_RESOURCE_STATE_RENDER_TARGET, D3D12_RESOURCE_STATE_PIXEL_SHADER_RESOURCE);

		// Then over the game's frame. HDR blends in the shader, so it reads a copy of the frame it writes over.
		if (mode == kSdr)
			move(buffer, D3D12_RESOURCE_STATE_PRESENT, D3D12_RESOURCE_STATE_RENDER_TARGET);
		else
		{
			move(buffer, D3D12_RESOURCE_STATE_PRESENT, D3D12_RESOURCE_STATE_COPY_SOURCE);
			move(r.scene, D3D12_RESOURCE_STATE_PIXEL_SHADER_RESOURCE, D3D12_RESOURCE_STATE_COPY_DEST);
			r.list->CopyResource(r.scene, buffer);
			move(r.scene, D3D12_RESOURCE_STATE_COPY_DEST, D3D12_RESOURCE_STATE_PIXEL_SHADER_RESOURCE);
			move(buffer, D3D12_RESOURCE_STATE_COPY_SOURCE, D3D12_RESOURCE_STATE_RENDER_TARGET);
		}
		r.list->OMSetRenderTargets(1, &rtv, FALSE, nullptr);
		r.list->SetGraphicsRootSignature(r.compRoot);
		r.list->SetPipelineState(mode == kSdr ? r.compBlend : r.compHdr);
		r.list->SetDescriptorHeaps(1, &r.srvHeap);
		D3D12_GPU_DESCRIPTOR_HANDLE table = r.srvHeap->GetGPUDescriptorHandleForHeapStart();
		table.ptr += kUiSlot * r.srvSize;
		r.list->SetGraphicsRootDescriptorTable(1, table);
		struct { UINT mode; float paper; float unused[2]; } constants{ static_cast<UINT>(mode), mode == kSdr ? 80.f : PaperWhite(), { 0.f, 0.f } };
		r.list->SetGraphicsRoot32BitConstants(0, 4, &constants, 0);
		const D3D12_VIEWPORT viewport{ 0.f, 0.f, static_cast<float>(bufferDesc.Width), static_cast<float>(bufferDesc.Height), 0.f, 1.f };
		const D3D12_RECT scissor{ 0, 0, static_cast<LONG>(bufferDesc.Width), static_cast<LONG>(bufferDesc.Height) };
		r.list->RSSetViewports(1, &viewport);
		r.list->RSSetScissorRects(1, &scissor);
		r.list->IASetPrimitiveTopology(D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST);
		r.list->DrawInstanced(3, 1, 0, 0);
		move(buffer, D3D12_RESOURCE_STATE_RENDER_TARGET, D3D12_RESOURCE_STATE_PRESENT);
		r.list->Close();

		ID3D12CommandList* lists[] = { r.list };
		r.queue->ExecuteCommandLists(1, lists);
		frame.fenceValue = ++r.fenceNext;
		r.queue->Signal(r.fence, frame.fenceValue);
		++r.submits;
		buffer->Release();
	}

	void OnPresent(IDXGISwapChain* sc, const char* via)
	{
		const auto count = ++g_presents;
		if (count == 1 || count == 600)
			Log("Present #%llu via %s, swapchain %p", count, via, sc);
		if (g_inPresent++ == 0)
			DrawOverlay(sc);
		g_inPresent--;
	}

	// What the game's own Present said, if the device went: the driver's reason, and how many frames we'd sent
	HRESULT NotePresent(HRESULT hr)
	{
		static bool told = false;
		if (!told && (hr == DXGI_ERROR_DEVICE_REMOVED || hr == DXGI_ERROR_DEVICE_RESET || hr == DXGI_ERROR_DEVICE_HUNG))
		{
			told = true;
			const HRESULT reason = r.device ? r.device->GetDeviceRemovedReason() : E_FAIL;
			Log("the game's Present returned 0x%08lx, device removed reason 0x%08lx, after %llu presents and %llu frames drawn by the overlay",
				static_cast<unsigned long>(hr), static_cast<unsigned long>(reason), g_presents.load(), r.submits);
		}
		return hr;
	}

	HRESULT STDMETHODCALLTYPE hkPresent(IDXGISwapChain* sc, UINT interval, UINT flags)
	{
		if (!(flags & DXGI_PRESENT_TEST))
			OnPresent(sc, "Present");
		return NotePresent(oPresent(sc, interval, flags));
	}

	HRESULT STDMETHODCALLTYPE hkPresent1(IDXGISwapChain1* sc, UINT interval, UINT flags, const DXGI_PRESENT_PARAMETERS* params)
	{
		if (!(flags & DXGI_PRESENT_TEST))
			OnPresent(sc, "Present1");
		return NotePresent(oPresent1(sc, interval, flags, params));
	}
}

namespace
{
	UINT g_nextIconSlot = 0;
	std::vector<UINT> g_freeIconSlots;
	std::map<unsigned long long, std::pair<ID3D12Resource*, UINT>> g_iconImages;
}

namespace
{
	// Let go of once the card has passed this point: nothing here waits for it
	struct Retired
	{
		UINT64 fence = 0;
		std::vector<IUnknown*> objects;
		std::vector<UINT> slots;
	};
	std::deque<Retired> g_retired;

	void Retire(Retired item)
	{
		item.fence = ++r.fenceNext;
		r.queue->Signal(r.fence, item.fence);
		g_retired.push_back(std::move(item));
	}
}

// One copy up to the card, sent ahead of the frame that draws it
bool UploadIconTexture(const GameTexture& source, unsigned long long& texture)
{
	if (!r.ready || (g_nextIconSlot >= kIconSrvs && g_freeIconSlots.empty()))
		return false;

	D3D12_HEAP_PROPERTIES defaultHeap{ D3D12_HEAP_TYPE_DEFAULT }, uploadHeap{ D3D12_HEAP_TYPE_UPLOAD };
	D3D12_RESOURCE_DESC desc{};
	desc.Dimension = D3D12_RESOURCE_DIMENSION_TEXTURE2D;
	desc.Width = source.width;
	desc.Height = source.height;
	desc.DepthOrArraySize = 1;
	const UINT levels = 1 + static_cast<UINT>(source.lowerMips.size());
	desc.MipLevels = static_cast<UINT16>(levels);
	desc.Format = static_cast<DXGI_FORMAT>(source.dxgiFormat);
	desc.SampleDesc.Count = 1;
	ID3D12Resource* image = nullptr;
	if (FAILED(r.device->CreateCommittedResource(&defaultHeap, D3D12_HEAP_FLAG_NONE, &desc, D3D12_RESOURCE_STATE_COPY_DEST, nullptr, IID_PPV_ARGS(&image))))
		return Log("icons: can't make a texture"), false;

	std::vector<D3D12_PLACED_SUBRESOURCE_FOOTPRINT> footprints(levels);
	UINT64 uploadSize = 0;
	r.device->GetCopyableFootprints(&desc, 0, levels, 0, footprints.data(), nullptr, nullptr, &uploadSize);
	D3D12_RESOURCE_DESC bufferDesc{};
	bufferDesc.Dimension = D3D12_RESOURCE_DIMENSION_BUFFER;
	bufferDesc.Width = uploadSize;
	bufferDesc.Height = bufferDesc.DepthOrArraySize = bufferDesc.MipLevels = 1;
	bufferDesc.SampleDesc.Count = 1;
	bufferDesc.Layout = D3D12_TEXTURE_LAYOUT_ROW_MAJOR;
	ID3D12Resource* upload = nullptr;
	ID3D12CommandAllocator* allocator = nullptr;
	ID3D12GraphicsCommandList* list = nullptr;
	BYTE* mapped = nullptr;
	bool ok = SUCCEEDED(r.device->CreateCommittedResource(&uploadHeap, D3D12_HEAP_FLAG_NONE, &bufferDesc, D3D12_RESOURCE_STATE_GENERIC_READ, nullptr, IID_PPV_ARGS(&upload)))
		&& SUCCEEDED(upload->Map(0, nullptr, reinterpret_cast<void**>(&mapped)))
		&& SUCCEEDED(r.device->CreateCommandAllocator(D3D12_COMMAND_LIST_TYPE_DIRECT, IID_PPV_ARGS(&allocator)))
		&& SUCCEEDED(r.device->CreateCommandList(0, D3D12_COMMAND_LIST_TYPE_DIRECT, allocator, nullptr, IID_PPV_ARGS(&list)));
	if (ok)
	{
		for (UINT level = 0; level < levels; ++level)
		{
			const GameTexture& mip = level == 0 ? source : source.lowerMips[level - 1];
			for (UINT y = 0; y < mip.rows; ++y)
				memcpy(mapped + footprints[level].Offset + y * footprints[level].Footprint.RowPitch, mip.pixels.data() + static_cast<size_t>(y) * mip.rowBytes, mip.rowBytes);
		}
		upload->Unmap(0, nullptr);
		for (UINT level = 0; level < levels; ++level)
		{
			D3D12_TEXTURE_COPY_LOCATION to{ image, D3D12_TEXTURE_COPY_TYPE_SUBRESOURCE_INDEX };
			to.SubresourceIndex = level;
			D3D12_TEXTURE_COPY_LOCATION from{ upload, D3D12_TEXTURE_COPY_TYPE_PLACED_FOOTPRINT };
			from.PlacedFootprint = footprints[level];
			list->CopyTextureRegion(&to, 0, 0, 0, &from, nullptr);
		}
		D3D12_RESOURCE_BARRIER barrier{};
		barrier.Type = D3D12_RESOURCE_BARRIER_TYPE_TRANSITION;
		barrier.Transition.pResource = image;
		barrier.Transition.Subresource = D3D12_RESOURCE_BARRIER_ALL_SUBRESOURCES;
		barrier.Transition.StateBefore = D3D12_RESOURCE_STATE_COPY_DEST;
		barrier.Transition.StateAfter = D3D12_RESOURCE_STATE_PIXEL_SHADER_RESOURCE;
		list->ResourceBarrier(1, &barrier);
		list->Close();
		ID3D12CommandList* lists[] = { list };
		r.queue->ExecuteCommandLists(1, lists);
		// The frame that draws it goes after on the same queue, so the copy's done by then. The upload buffer,
		// list and allocator are let go of once the card has passed it, never before.
		Retired done;
		done.objects = { list, allocator, upload };
		Retire(std::move(done));
		list = nullptr;
		allocator = nullptr;
		upload = nullptr;
	}
	if (list) list->Release();
	if (allocator) allocator->Release();
	if (upload) upload->Release();
	if (!ok)
	{
		image->Release();
		return Log("icons: can't upload one"), false;
	}

	UINT slot;
	if (!g_freeIconSlots.empty())
	{
		slot = g_freeIconSlots.back();
		g_freeIconSlots.pop_back();
	}
	else
	{
		slot = kImGuiSrvs + g_nextIconSlot++;
	}
	D3D12_SHADER_RESOURCE_VIEW_DESC view{};
	view.Format = desc.Format;
	view.ViewDimension = D3D12_SRV_DIMENSION_TEXTURE2D;
	view.Shader4ComponentMapping = D3D12_DEFAULT_SHADER_4_COMPONENT_MAPPING;
	view.Texture2D.MipLevels = levels;
	D3D12_CPU_DESCRIPTOR_HANDLE cpu = r.srvHeap->GetCPUDescriptorHandleForHeapStart();
	cpu.ptr += slot * r.srvSize;
	r.device->CreateShaderResourceView(image, &view, cpu);   // the image stays referenced until it's released
	texture = r.srvHeap->GetGPUDescriptorHandleForHeapStart().ptr + slot * r.srvSize;
	g_iconImages[texture] = { image, slot };
	return true;
}

struct PreparedTexture
{
	ID3D12Resource* image = nullptr, * upload = nullptr;
	std::vector<D3D12_PLACED_SUBRESOURCE_FOOTPRINT> footprints;
	DXGI_FORMAT format = DXGI_FORMAT_UNKNOWN;
	~PreparedTexture()
	{
		if (image) image->Release();
		if (upload) upload->Release();
	}
};

void ReleaseRetired()
{
	while (!g_retired.empty() && r.fence->GetCompletedValue() >= g_retired.front().fence)
	{
		for (IUnknown* object : g_retired.front().objects)
			object->Release();
		for (const UINT slot : g_retired.front().slots)
			g_freeIconSlots.push_back(slot);
		g_retired.pop_front();
	}
}

std::shared_ptr<PreparedTexture> PrepareIconTexture(const GameTexture& source)
{
	if (!r.ready)
		return nullptr;
	auto prepared = std::make_shared<PreparedTexture>();
	D3D12_HEAP_PROPERTIES defaultHeap{ D3D12_HEAP_TYPE_DEFAULT }, uploadHeap{ D3D12_HEAP_TYPE_UPLOAD };
	D3D12_RESOURCE_DESC desc{};
	desc.Dimension = D3D12_RESOURCE_DIMENSION_TEXTURE2D;
	desc.Width = source.width;
	desc.Height = source.height;
	desc.DepthOrArraySize = 1;
	const UINT levels = 1 + static_cast<UINT>(source.lowerMips.size());
	desc.MipLevels = static_cast<UINT16>(levels);
	desc.Format = static_cast<DXGI_FORMAT>(source.dxgiFormat);
	desc.SampleDesc.Count = 1;
	prepared->format = desc.Format;
	if (FAILED(r.device->CreateCommittedResource(&defaultHeap, D3D12_HEAP_FLAG_NONE, &desc, D3D12_RESOURCE_STATE_COPY_DEST, nullptr, IID_PPV_ARGS(&prepared->image))))
		return nullptr;
	prepared->footprints.resize(levels);
	UINT64 uploadSize = 0;
	r.device->GetCopyableFootprints(&desc, 0, levels, 0, prepared->footprints.data(), nullptr, nullptr, &uploadSize);
	D3D12_RESOURCE_DESC bufferDesc{};
	bufferDesc.Dimension = D3D12_RESOURCE_DIMENSION_BUFFER;
	bufferDesc.Width = uploadSize;
	bufferDesc.Height = bufferDesc.DepthOrArraySize = bufferDesc.MipLevels = 1;
	bufferDesc.SampleDesc.Count = 1;
	bufferDesc.Layout = D3D12_TEXTURE_LAYOUT_ROW_MAJOR;
	BYTE* mapped = nullptr;
	if (FAILED(r.device->CreateCommittedResource(&uploadHeap, D3D12_HEAP_FLAG_NONE, &bufferDesc, D3D12_RESOURCE_STATE_GENERIC_READ, nullptr, IID_PPV_ARGS(&prepared->upload)))
		|| FAILED(prepared->upload->Map(0, nullptr, reinterpret_cast<void**>(&mapped))))
		return nullptr;
	for (UINT level = 0; level < levels; ++level)
	{
		const GameTexture& mip = level == 0 ? source : source.lowerMips[level - 1];
		for (UINT y = 0; y < mip.rows; ++y)
			memcpy(mapped + prepared->footprints[level].Offset + y * prepared->footprints[level].Footprint.RowPitch, mip.pixels.data() + static_cast<size_t>(y) * mip.rowBytes, mip.rowBytes);
	}
	prepared->upload->Unmap(0, nullptr);
	return prepared;
}

void SubmitIconTextures(const std::vector<std::shared_ptr<PreparedTexture>>& textures, std::vector<unsigned long long>& views)
{
	views.assign(textures.size(), 0);
	if (!r.ready || textures.empty())
		return;
	ID3D12CommandAllocator* allocator = nullptr;
	ID3D12GraphicsCommandList* list = nullptr;
	if (FAILED(r.device->CreateCommandAllocator(D3D12_COMMAND_LIST_TYPE_DIRECT, IID_PPV_ARGS(&allocator)))
		|| FAILED(r.device->CreateCommandList(0, D3D12_COMMAND_LIST_TYPE_DIRECT, allocator, nullptr, IID_PPV_ARGS(&list))))
	{
		if (allocator) allocator->Release();
		return Log("item models: can't send the textures");
	}
	Retired finished;
	finished.objects.push_back(allocator);
	finished.objects.push_back(list);
	std::vector<D3D12_RESOURCE_BARRIER> barriers;
	for (size_t i = 0; i < textures.size(); ++i)
	{
		PreparedTexture* t = textures[i].get();
		if (!t || (g_nextIconSlot >= kIconSrvs && g_freeIconSlots.empty()))
			continue;
		const UINT levels = static_cast<UINT>(t->footprints.size());
		for (UINT level = 0; level < levels; ++level)
		{
			D3D12_TEXTURE_COPY_LOCATION to{ t->image, D3D12_TEXTURE_COPY_TYPE_SUBRESOURCE_INDEX };
			to.SubresourceIndex = level;
			D3D12_TEXTURE_COPY_LOCATION from{ t->upload, D3D12_TEXTURE_COPY_TYPE_PLACED_FOOTPRINT };
			from.PlacedFootprint = t->footprints[level];
			list->CopyTextureRegion(&to, 0, 0, 0, &from, nullptr);
		}
		D3D12_RESOURCE_BARRIER barrier{};
		barrier.Type = D3D12_RESOURCE_BARRIER_TYPE_TRANSITION;
		barrier.Transition.pResource = t->image;
		barrier.Transition.Subresource = D3D12_RESOURCE_BARRIER_ALL_SUBRESOURCES;
		barrier.Transition.StateBefore = D3D12_RESOURCE_STATE_COPY_DEST;
		barrier.Transition.StateAfter = D3D12_RESOURCE_STATE_PIXEL_SHADER_RESOURCE;
		barriers.push_back(barrier);

		UINT slot;
		if (!g_freeIconSlots.empty())
		{
			slot = g_freeIconSlots.back();
			g_freeIconSlots.pop_back();
		}
		else
		{
			slot = kImGuiSrvs + g_nextIconSlot++;
		}
		D3D12_SHADER_RESOURCE_VIEW_DESC view{};
		view.Format = t->format;
		view.ViewDimension = D3D12_SRV_DIMENSION_TEXTURE2D;
		view.Shader4ComponentMapping = D3D12_DEFAULT_SHADER_4_COMPONENT_MAPPING;
		view.Texture2D.MipLevels = levels;
		D3D12_CPU_DESCRIPTOR_HANDLE cpu = r.srvHeap->GetCPUDescriptorHandleForHeapStart();
		cpu.ptr += slot * r.srvSize;
		r.device->CreateShaderResourceView(t->image, &view, cpu);
		views[i] = r.srvHeap->GetGPUDescriptorHandleForHeapStart().ptr + slot * r.srvSize;
		g_iconImages[views[i]] = { t->image, slot };
		t->image = nullptr;   // the window's now
		finished.objects.push_back(t->upload);
		t->upload = nullptr;
	}
	if (!barriers.empty())
		list->ResourceBarrier(static_cast<UINT>(barriers.size()), barriers.data());
	list->Close();
	ID3D12CommandList* lists[] = { list };
	r.queue->ExecuteCommandLists(1, lists);
	Retire(std::move(finished));
}

void RetireIconTexture(unsigned long long texture)
{
	const auto found = g_iconImages.find(texture);
	if (found == g_iconImages.end())
		return;
	Retired item;
	item.objects.push_back(found->second.first);
	item.slots.push_back(found->second.second);
	g_iconImages.erase(found);
	Retire(std::move(item));
}

void RetireResource(ID3D12Resource* resource)
{
	Retired item;
	item.objects.push_back(resource);
	Retire(std::move(item));
}

bool MakeIconView(ID3D12Resource* image, int dxgiFormat, unsigned long long& view)
{
	if (!r.ready || g_nextIconSlot >= kIconSrvs)
		return false;
	const UINT slot = kImGuiSrvs + g_nextIconSlot++;
	D3D12_SHADER_RESOURCE_VIEW_DESC desc{};
	desc.Format = static_cast<DXGI_FORMAT>(dxgiFormat);
	desc.ViewDimension = D3D12_SRV_DIMENSION_TEXTURE2D;
	desc.Shader4ComponentMapping = D3D12_DEFAULT_SHADER_4_COMPONENT_MAPPING;
	desc.Texture2D.MipLevels = 1;
	D3D12_CPU_DESCRIPTOR_HANDLE cpu = r.srvHeap->GetCPUDescriptorHandleForHeapStart();
	cpu.ptr += slot * r.srvSize;
	r.device->CreateShaderResourceView(image, &desc, cpu);
	view = r.srvHeap->GetGPUDescriptorHandleForHeapStart().ptr + slot * r.srvSize;
	return true;
}

void ReleaseIconTexture(unsigned long long texture)
{
	const auto found = g_iconImages.find(texture);
	if (found == g_iconImages.end())
		return;
	// Everything already sent may still be drawing it: let go of once the card has passed this point
	RetireIconTexture(texture);
}

std::recursive_mutex& ImGuiMutex()
{
	static std::recursive_mutex mutex;
	return mutex;
}

bool InstallD3D12Hooks()
{
	// From the system folder explicitly, not anything the game has wrapped.
	wchar_t path[MAX_PATH];
	GetSystemDirectoryW(path, MAX_PATH);
	wcscat_s(path, L"\\dxgi.dll");
	HMODULE dxgi = LoadLibraryW(path);
	auto createFactory = dxgi ? reinterpret_cast<HRESULT(WINAPI*)(REFIID, void**)>(GetProcAddress(dxgi, "CreateDXGIFactory1")) : nullptr;
	if (!createFactory)
		return Log("system dxgi not loaded"), false;

	IDXGIFactory4* factory = nullptr;
	if (FAILED(createFactory(IID_PPV_ARGS(&factory))))
		return Log("factory failed"), false;
	PatchVtable(factory, 10, hkCreateSwapChain, oCreateSwapChain);
	PatchVtable(factory, 15, hkCreateForHwnd, oCreateForHwnd);
	factory->Release();
	Log("watching for the swapchain");

	IDXGISwapChain* swapchain;
	while (!(swapchain = g_createdSwapchain.load()))
		Sleep(50);
	Sleep(kHookDelayMs);

	// The object the game really presents on gives the vtable, so no throwaway device is needed.
	PatchVtable(swapchain, 8, hkPresent, oPresent);
	IDXGISwapChain1* swapchain1 = nullptr;
	if (SUCCEEDED(swapchain->QueryInterface(IID_PPV_ARGS(&swapchain1))))
	{
		PatchVtable(swapchain1, 22, hkPresent1, oPresent1);
		swapchain1->Release();
	}

	HMODULE owner = nullptr;
	wchar_t ownerName[MAX_PATH] = L"?";
	if (GetModuleHandleExW(GET_MODULE_HANDLE_EX_FLAG_FROM_ADDRESS | GET_MODULE_HANDLE_EX_FLAG_UNCHANGED_REFCOUNT, reinterpret_cast<LPCWSTR>(oPresent), &owner))
		GetModuleFileNameW(owner, ownerName, MAX_PATH);
	Log("Present hooked after %lu ms: now wrapping %p in %ls", kHookDelayMs, oPresent, ownerName);
	return true;
}
