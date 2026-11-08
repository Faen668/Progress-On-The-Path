call variables.cmd

@RD /S /Q "%gamePath%\mods\mod%modname%"
del "%gamePath%\bin\config\r4game\user_config_matrix\pc\mod%modname%.xml" /s /q

XCOPY "%modPath%\release\bin" "%gamePath%\bin" /e /s /y
XCOPY "%modPath%\release\mods" "%gamePath%\mods" /e /s /y

::The reward swords' DLC (Pathfinder and Navigator)
@RD /S /Q "%gamePath%\dlc\dlc%modname%"
::and where it went before it was named as the mod is
@RD /S /Q "%gamePath%\dlc\potp"
XCOPY "%modPath%\release\dlc" "%gamePath%\dlc" /e /s /y
