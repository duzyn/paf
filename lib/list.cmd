setlocal enabledelayedexpansion

if not exist "%~d0\PortableApps" (
  echo There is no portable apps in %~d0\PortableApps.
  exit /b 31
)

if not exist "%~d0\PortableApps\CommonFiles" (
  dir /b "%~d0\PortableApps" | findstr /c:Portable >nul || (
    echo There is no portable apps in %~d0\PortableApps.
    exit /b 31
  )
)

copy nul "%_cache_dir%\_list.txt" >nul || exit /b 1

echo Installed apps:
set _apps_count_tmp=0
if exist "%~d0\PortableApps" (
  for /f %%G in ('dir /b "%~d0\PortableApps" ^| findstr /c:Portable') do (
    call "%~dp0_get_installed_app_info.cmd" %%G || exit /b 1
    if [!_installed_app_appid!] neq [] (
      echo !_installed_app_appid! !_installed_app_display_version!>>"%_cache_dir%\_list.txt"
      set /a _apps_count_tmp+=1 >nul
    )
  )
)

if exist "%~d0\PortableApps\CommonFiles" (
  for /f %%G in ('dir /b "%~d0\PortableApps\CommonFiles"') do (
    call "%~dp0_get_installed_plugin_info.cmd" %%G || exit /b 1
    if [!_installed_plugin_appid!] neq [] (
      echo !_installed_plugin_appid! !_installed_plugin_display_version!>>"%_cache_dir%\_list.txt"
      set /a _apps_count_tmp+=1 >nul
    )
  )
)

sort "%_cache_dir%\_list.txt"
del /q "%_cache_dir%\_list.txt" || exit /b 1

for /f "delims=" %%G in ('echo %_apps_count_tmp%') do set _apps_count=%%G
echo Total of apps: %_apps_count%
set "_apps_count_tmp="
endlocal