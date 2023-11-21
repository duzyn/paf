setlocal enabledelayedexpansion

if not exist "%~d0\PortableApps" (
  echo %There is no portable apps in% %~d0\PortableApps.
  exit /b 31
)
echo %Outdated apps:%
set _apps_count_tmp=0
if exist "%~d0\PortableApps" (
  for /f %%G in ('dir /b "%~d0\PortableApps" ^| findstr /c:Portable') do (
    if [%%G] == [] (
      echo %There is no portable apps.%
      exit /b 21
    )
    if not exist "%_bucket_dir%\%%G.csv" (
      echo %There is no this app:% %~1
      exit /b 22
    )
    if not exist "%~d0\PortableApps\%%G\App\AppInfo\appinfo.ini" (
      echo %App is not installed:% %~1
      exit /b 81
    )
    call "%~dp0_get_app_info.cmd" %%G || exit /b 1
    call "%~dp0_get_installed_app_info.cmd" %%G || exit /b 1
    if "!_installed_app_display_version!" neq "!_app_version!" (
      echo !_installed_app_appid! !_installed_app_display_version! -^> !_app_version!
      set /a _apps_count_tmp+=1 >nul
    )
  )
)

if exist "%~d0\PortableApps\CommonFiles" (
  for /f %%G in ('dir /b "%~d0\PortableApps\CommonFiles"') do (
    if [%%G] == [] (
      echo %There is no portable plugins.%
      exit /b 21
    )
    if not exist "%_bucket_dir%\%%G.csv" (
      echo %There is no this plugins:% %~1
      exit /b 22
    )
    if not exist "%~d0\PortableApps\CommonFiles\%%G\App\AppInfo\plugininstaller.ini" (
      echo %Plugin is not installed:% %~1
      exit /b 81
    )
    call "%~dp0_get_app_info.cmd" %%G || exit /b 1
    call "%~dp0_get_installed_plugin_info.cmd" %%G || exit /b 1
    if "!_installed_plugin_display_version!" neq "!_app_version!" (
      echo !_installed_plugin_appid! !_installed_plugin_display_version! -^> !_app_version!
      set /a _apps_count_tmp+=1 >nul
    )
  )
)

for /f "delims=" %%G in ('echo %_apps_count_tmp%') do set _apps_count=%%G
echo %Total of apps:% %_apps_count%
set "_apps_count_tmp="
endlocal
