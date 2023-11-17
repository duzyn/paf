setlocal enabledelayedexpansion

if not exist "%~d0\PortableApps" (
  echo %There is no portable apps in% %~d0\PortableApps.
  exit /b 31
)

if not exist "%~d0\PortableApps\CommonFiles" (
  dir /b "%~d0\PortableApps" | findstr /c:Portable >nul || (
    echo %There is no portable apps in% %~d0\PortableApps.
    exit /b 31
  )
)

copy nul "%_cache_dir%\_export.txt" >nul || exit /b 1

for /f %%G in ('dir /b "%~d0\PortableApps" ^| findstr /c:Portable') do (
  call "%~dp0_get_installed_app_info.cmd" %%G || exit /b 1
  echo "!_installed_app_appid!","!_installed_app_display_version!">>"%_cache_dir%\_export.txt"
)

for /f %%G in ('dir /b "%~d0\PortableApps\CommonFiles"') do (
  call "%~dp0_get_installed_plugin_info.cmd" %%G || exit /b 1
  echo "!_installed_plugin_appid!","!_installed_plugin_display_version!">>"%_cache_dir%\_export.txt"
)

sort "%_cache_dir%\_export.txt"
del /q "%_cache_dir%\_export.txt" || exit /b 1
endlocal
