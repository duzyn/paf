setlocal
call "%~dp0_get_app_info.cmd" %~1 || exit /b 1
call "%~dp0_get_installed_app_info.cmd" %~1 >nul
call "%~dp0_get_installed_plugin_info.cmd" %~1 >nul

if not exist "%~d0\PortableApps\%~1\App\AppInfo\appinfo.ini" (
  if not exist "%~d0\PortableApps\CommonFiles\%~1\App\AppInfo\plugininstaller.ini" (
    call "%~dp0download.cmd" %~1 || exit /b 1
  )
)

if exist "%~d0\PortableApps\%~1\App\AppInfo\appinfo.ini" (
  if "%_installed_app_display_version%" neq "%_app_version%" (
    echo %~1 %_installed_app_display_version% is installed.
    echo %~1 %_installed_app_display_version% -^> %_app_version%
    call "%~dp0download.cmd" %~1 || exit /b 1
  ) else (
    echo %~1 %_installed_app_display_version% is up to date.
    exit /b 72
  )
)

if exist "%~d0\PortableApps\CommonFiles\%~1\App\AppInfo\plugininstaller.ini" (
  if "%_installed_plugin_display_version%" neq "%_app_version%" (
    echo %~1 %_installed_plugin_display_version% is installed.
    echo %~1 %_installed_plugin_display_version% -^> %_app_version%
    call "%~dp0download.cmd" %~1 || exit /b 1
  ) else (
    echo %~1 %_installed_plugin_display_version% is up to date.
    exit /b 72
  )
)

if exist "%_downloads_dir%\%_app_filename%" (
  echo Installing %_app_appid% %_app_version% ... 
  call "%_autohotkey%" "%~dp0paf_install.ahk" "%_downloads_dir%\%_app_filename%" "%~d0\PortableApps\%~1" ^
    && echo %_app_appid% %_app_version% was installed successfully. ^
    || (
      echo Installation failed.
      exit /b 71
    )
)

endlocal
