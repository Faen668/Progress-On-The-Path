call variables.cmd

::The overlay has to be built first: cmake --build overlay\build --config Release --target PotpOverlay
if not exist "%modpath%\overlay\build\Release\PotpOverlay.asi" (
	echo The overlay hasn't been built: overlay\build\Release\PotpOverlay.asi is missing.
	exit /b 1
)

call encode-csv-strings.bat

::Delete 'Release' folder and create a new one.
rmdir "%modpath%\release" /s /q
mkdir "%modpath%\release"

::|Copy over precompiled scripts.
mkdir "%modpath%\release\mods\mod%modname%\content\
XCOPY "%modpath%\progress on the path ng\packed\mods\modprogressonthepathng\content" "%modpath%\release\mods\mod%modname%\content\" /e /s /y

::Copy over the reward swords' DLC (dlc\potp: Pathfinder and Navigator), as REDkit's Publish packs it.
mkdir "%modpath%\release\dlc\potp\"
XCOPY "%modpath%\progress on the path ng\packed\dlc\potp" "%modpath%\release\dlc\potp\" /e /s /y

::Copy over PotP's own achievement pack (the reward swords' achievements): the overlay reads mods\<mod>\potp_achievements.xml.
mkdir "%modpath%\release\mods\mod%modname%\"
copy /y "%modpath%\source\achievements\potp_achievements.xml" "%modpath%\release\mods\mod%modname%\"

::Copy over the loose scripts.
mkdir "%modpath%\release\mods\mod%modname%\content\scripts\local\"
XCOPY "%modpath%\progress on the path ng\workspace\scripts\local" "%modpath%\release\mods\mod%modname%\content\scripts\local\" /e /s /y

::Copy over the encoded strings.
XCOPY "%modpath%\source\strings\" "%modpath%\release\mods\mod%modname%\content\" /e /s /y

::Copy over the overlay: the .asi beside the game, with its fonts and achievement data inside it, and its licences in the mod. Ultimate ASI Loader is a Nexus requirement, not shipped.
mkdir "%modpath%\release\bin\x64_dx12\"
copy /y "%modpath%\overlay\build\Release\PotpOverlay.asi" "%modpath%\release\bin\x64_dx12\"
mkdir "%modpath%\release\mods\mod%modname%\"
copy /y "%modpath%\overlay\THIRD-PARTY-NOTICES.txt" "%modpath%\release\mods\mod%modname%\"

::Copy over the README.
XCOPY "%modpath%\source\instructions\" "%modpath%\release\" /e /s /y

::Pack the release.
7z a "%modpath%\release\progress-on-the-path-ng.zip" "%modpath%\release\bin"
7z a "%modpath%\release\progress-on-the-path-ng.zip" "%modpath%\release\mods"
7z a "%modpath%\release\progress-on-the-path-ng.zip" "%modpath%\release\dlc"
7z a "%modpath%\release\progress-on-the-path-ng.zip" "%modpath%\release\Installation Instructions.txt"