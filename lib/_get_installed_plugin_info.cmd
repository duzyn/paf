setlocal

if "%~1" == "" (
  echo Please input an app name.
  exit /b 21
)

if not exist "%~d0\PortableApps\CommonFiles\%~1\App\AppInfo\plugininstaller.ini" (
  echo App is not installed: %~1
  exit /b 81
)

for /f "tokens=1-2 delims==" %%G in ('type "%~d0\PortableApps\CommonFiles\%~1\App\AppInfo\plugininstaller.ini" ^| findstr /v /r /c:"^[;\[]"') do (
  set _parameter.%%G=%%H
)

endlocal & (
  set "_installed_plugin_name=%_parameter.Name%"
  set "_installed_plugin_appid=%_parameter.AppID%"
  set "_installed_plugin_display_version=%_parameter.DisplayVersion%"
  set "_installed_plugin_homepage=%_parameter.Homepage%"
)
