call variables.cmd

@RD /S /Q "%gamePath%\mods\mod%modname%"
@RD /S /Q "%gamePath%\dlc\mod%modname%"
del "%gamePath%\bin\config\r4game\user_config_matrix\pc\mod%modname%.xml" /s /q

XCOPY "%modPath%\release\bin" "%gamePath%\bin" /e /s /y
XCOPY "%modPath%\release\mods" "%gamePath%\mods" /e /s /y
XCOPY "%modPath%\release\dlc" "%gamePath%\dlc" /e /s /y
