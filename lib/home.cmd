setlocal
call "%~dp0_get_app_info.cmd" %~1 || exit /b 1
start %_app_homepage%
endlocal
