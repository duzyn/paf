setlocal enabledelayedexpansion

if "%~1" == "" (
  echo %Please input an app name.%
  exit /b 21
)

if not exist "%~d0\PortableApps\%~1\" (
  if not exist "%~d0\PortableApps\CommonFiles\%~1\" (
    echo %App is not installed:% %~1
    exit /b 81
  )
)

if exist "%~d0\PortableApps\%~1\" (
  call "%~dp0_get_installed_app_info.cmd" %~1 || (
    set /p "_removing_tips=%Removing% %~1 ... " <nul
    rmdir /q /s "%~d0\PortableApps\%~1\" || exit /b 82
    echo %Done%
    exit /b 1
  )
  set /p "_uninstalling_tips=%Uninstalling% !_installed_app_appid! !_installed_app_display_version! ... " <nul
  rmdir /q /s "%~d0\PortableApps\%~1\" || exit /b 82
  echo %Done%
)

if exist "%~d0\PortableApps\CommonFiles\%~1\" (
  call "%~dp0_get_installed_plugin_info.cmd" %~1 || (
    set /p "_removing_tips=%Removing% %~1 ... " <nul
    rmdir /q /s "%~d0\PortableApps\CommonFiles\%~1\" || exit /b 82
    echo %Done%
    exit /b 1
  )
  set /p "_uninstalling_tips=%Uninstalling% !_installed_plugin_appid! !_installed_plugin_display_version! ... " <nul
  rmdir /q /s "%~d0\PortableApps\CommonFiles\%~1\" || exit /b 82
  echo %Done%
)

endlocal
