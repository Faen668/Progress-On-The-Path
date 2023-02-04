call variables.cmd

@RD /S /Q "%gamePath%\mods\mod%modname%"
@RD /S /Q "%gamePath%\dlc\mod%modname%"
del "%gamePath%\bin\config\r4game\user_config_matrix\pc\mod%modname%.xml" /s /q

XCOPY "%modPath%\release" "%gamePath%\" /e /s /y

cd "%gamePath%"
call "tw3-menufilelist-updater.exe"
