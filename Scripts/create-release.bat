call variables.cmd
call encode-csv-strings.bat

::Delete 'Release' folder and create a new one.
rmdir "%modpath%\release" /s /q
mkdir "%modpath%\release"
mkdir "%modpath%\release\vanilla"
mkdir "%modpath%\release\redux"

::Compile and copy over all local .ws scripts.
mkdir "%modpath%\release\vanilla\mods\mod%modname%\content\scripts\local\
> "%modpath%\release\vanilla\mods\mod%modname%\content\scripts\local\ProgressOnThePath_Compiled.ws" (for /r "%modpath%\Source\local" %%F in (*.ws) do @type "%%F")

mkdir "%modpath%\release\redux\mods\mod%modname%\content\scripts\local\
> "%modpath%\release\redux\mods\mod%modname%\content\scripts\local\ProgressOnThePath_Compiled.ws" (for /r "%modpath%\Source - Redux\local" %%F in (*.ws) do @type "%%F")

::Copy over the compiled scripts .ws scripts.
XCOPY "%modpath%\release\vanilla\mods\mod%modname%\content\scripts\local\" "%modpath%\Compiled" /e /s /y
XCOPY "%modpath%\release\redux\mods\mod%modname%\content\scripts\local\" "%modpath%\Compiled" /e /s /y

::Copy over all vanilla .ws scripts.
XCOPY "%modpath%\Source\game" "%modpath%\release\vanilla\mods\mod%modname%\content\Scripts\game\" /e /s /y
XCOPY "%modpath%\Source - Redux\game" "%modpath%\release\redux\mods\mod%modname%\content\Scripts\game\" /e /s /y

::Copy over the menu xml.
mkdir "%modpath%\release\vanilla\bin\config\r4game\user_config_matrix\pc\"
XCOPY "%modPath%\Menu" "%modpath%\release\vanilla\bin\config\r4game\user_config_matrix\pc\" /e /s /y

mkdir "%modpath%\release\redux\bin\config\r4game\user_config_matrix\pc\"
XCOPY "%modPath%\Menu" "%modpath%\release\redux\bin\config\r4game\user_config_matrix\pc\" /e /s /y

::Copy over the encoded strings.
XCOPY "%modpath%\Strings\" "%modpath%\release\vanilla\mods\mod%modname%\content\" /e /s /y
XCOPY "%modpath%\Strings\" "%modpath%\release\redux\mods\mod%modname%\content\" /e /s /y

::Copy over the DLC bundle files.
XCOPY "%modpath%\Build\ProgressOnThePath\packed\Mods\modProgressOnThePath\content" "%modpath%\release\vanilla\mods\mod%modname%\content\" /e /s /y
XCOPY "%modpath%\Build\ProgressOnThePath\packed\DLC\dlc_progressonthepath\content" "%modpath%\release\vanilla\dlc\dlc%modname%\content\" /e /s /y

XCOPY "%modpath%\Build\ProgressOnThePath\packed\Mods\modProgressOnThePath\content" "%modpath%\release\redux\mods\mod%modname%\content\" /e /s /y
XCOPY "%modpath%\Build\ProgressOnThePath\packed\DLC\dlc_progressonthepath\content" "%modpath%\release\redux\dlc\dlc%modname%\content\" /e /s /y

::Copy over the README.
XCOPY "%modpath%\Instructions\" "%modpath%\release\vanilla\" /e /s /y
XCOPY "%modpath%\Instructions\" "%modpath%\release\redux\" /e /s /y

::Copy over the Shared Util dependencies
XCOPY "%supath%\mod_sharedutils_mappins\" "%modpath%\release\vanilla\mods\mod_sharedutils_mappins\" /e /s /y
XCOPY "%supath%\mod_sharedutils_helpers\" "%modpath%\release\vanilla\mods\mod_sharedutils_helpers\" /e /s /y
XCOPY "%supath%\mod_sharedutils_glossary\" "%modpath%\release\vanilla\mods\mod_sharedutils_glossary\" /e /s /y

XCOPY "%supath%\mod_sharedutils_mappins\" "%modpath%\release\redux\mods\mod_sharedutils_mappins\" /e /s /y
XCOPY "%supath%\mod_sharedutils_helpers\" "%modpath%\release\redux\mods\mod_sharedutils_helpers\" /e /s /y
XCOPY "%supath%\mod_sharedutils_glossary\" "%modpath%\release\redux\mods\mod_sharedutils_glossary\" /e /s /y

"C:\Program Files\7-Zip\7z.exe" a "%modpath%\release\vanilla\Progress-on-the-Path.zip" "%modpath%\release\vanilla\mods"
"C:\Program Files\7-Zip\7z.exe" a "%modpath%\release\vanilla\Progress-on-the-Path.zip" "%modpath%\release\vanilla\dlc"
"C:\Program Files\7-Zip\7z.exe" a "%modpath%\release\vanilla\Progress-on-the-Path.zip" "%modpath%\release\vanilla\bin"
"C:\Program Files\7-Zip\7z.exe" a "%modpath%\release\vanilla\Progress-on-the-Path.zip" "%modpath%\release\vanilla\Installation Instructions.txt"

"C:\Program Files\7-Zip\7z.exe" a "%modpath%\release\redux\Progress-on-the-Path.zip" "%modpath%\release\redux\mods"
"C:\Program Files\7-Zip\7z.exe" a "%modpath%\release\redux\Progress-on-the-Path.zip" "%modpath%\release\redux\dlc"
"C:\Program Files\7-Zip\7z.exe" a "%modpath%\release\redux\Progress-on-the-Path.zip" "%modpath%\release\redux\bin"
"C:\Program Files\7-Zip\7z.exe" a "%modpath%\release\redux\Progress-on-the-Path.zip" "%modpath%\release\redux\Installation Instructions.txt"