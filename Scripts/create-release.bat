call variables.cmd
call encode-csv-strings.bat

::Delete 'Release' folder and create a new one.
rmdir "%modpath%\release" /s /q
mkdir "%modpath%\release"

::Compile and copy over all local .ws scripts.
mkdir "%modpath%\release\mods\mod%modname%\content\scripts\local\
> "%modpath%\release\mods\mod%modname%\content\scripts\local\ProgressOnThePath_Compiled.ws" (for /r "%modpath%\Source\local" %%F in (*.ws) do @type "%%F")

::Copy over the compiled scripts .ws scripts.
XCOPY "%modpath%\release\mods\mod%modname%\content\scripts\local\" "%modpath%\Compiled" /e /s /y

::Copy over all vanilla .ws scripts.
XCOPY "%modpath%\Source\game" "%modpath%\release\mods\mod%modname%\content\Scripts\game\" /e /s /y

::Copy over the menu xml.
mkdir "%modpath%\release\bin\config\r4game\user_config_matrix\pc\"
XCOPY "%modPath%\Menu" "%modpath%\release\bin\config\r4game\user_config_matrix\pc\" /e /s /y

::Copy over the encoded strings.
XCOPY "%modpath%\Strings\" "%modpath%\release\mods\mod%modname%\content\" /e /s /y

::Copy over the DLC bundle files.
XCOPY "%modpath%\Build\ProgressOnThePath\packed\Mods\modProgressOnThePath\content" "%modpath%\release\mods\mod%modname%\content\" /e /s /y
XCOPY "%modpath%\Build\ProgressOnThePath\packed\DLC\dlc_progressonthepath\content" "%modpath%\release\dlc\dlc%modname%\content\" /e /s /y

::Copy over the README.
XCOPY "%modpath%\Instructions\" "%modpath%\release\" /e /s /y

::Copy over the Shared Util dependencies
XCOPY "%supath%\mod_sharedutils_mappins\" "%modpath%\release\mods\mod_sharedutils_mappins\" /e /s /y
XCOPY "%supath%\mod_sharedutils_helpers\" "%modpath%\release\mods\mod_sharedutils_helpers\" /e /s /y
XCOPY "%supath%\mod_sharedutils_tiny_bootstrapper\" "%modpath%\release\mods\mod_sharedutils_tiny_bootstrapper\" /e /s /y
XCOPY "%supath%\mod_sharedutils_storage\" "%modpath%\release\mods\mod_sharedutils_storage\" /e /s /y
XCOPY "%supath%\mod_sharedutils_glossary\" "%modpath%\release\mods\mod_sharedutils_glossary\" /e /s /y

"C:\Program Files\7-Zip\7z.exe" a "%modpath%\release\Progress-on-the-Path.zip" "%modpath%\release\mods"
"C:\Program Files\7-Zip\7z.exe" a "%modpath%\release\Progress-on-the-Path.zip" "%modpath%\release\dlc"
"C:\Program Files\7-Zip\7z.exe" a "%modpath%\release\Progress-on-the-Path.zip" "%modpath%\release\bin"
"C:\Program Files\7-Zip\7z.exe" a "%modpath%\release\Progress-on-the-Path.zip" "%modpath%\release\Installation Instructions.txt"