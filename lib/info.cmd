setlocal
call "%~dp0_get_app_info.cmd" %~1 || exit /b 1

echo Name: %_app_name%
echo AppID: %_app_appid%
echo Version: %_app_version%
echo Homepage: %_app_homepage%
endlocal