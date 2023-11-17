@echo off
setlocal
call "%~dp0lib\locale.cmd" || exit /b 1
call "%~dp0lib\depends.cmd" || exit /b 1
call "%~dp0lib\commands.cmd" %* || exit /b 1

endlocal
