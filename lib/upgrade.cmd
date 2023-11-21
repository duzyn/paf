setlocal enabledelayedexpansion

if "%~1" == "" (
  echo %Please input an app name.%
  exit /b 21
)

if [%~1] == [*] (
  if exist "%~d0\PortableApps" (
    for /f %%G in ('dir /b "%~d0\PortableApps" ^| findstr /c:Portable') do (
      call "%~dp0_get_installed_app_info.cmd" %%G || exit /b 1
      call "%~dp0install.cmd" !_installed_app_appid!
    )
  )
  if exist "%~d0\PortableApps\CommonFiles" (
    for /f %%G in ('dir /b "%~d0\PortableApps\CommonFiles"') do (
      call "%~dp0_get_installed_plugin_info.cmd" %%G || exit /b 1
      call "%~dp0install.cmd" !_installed_plugin_appid!
    )
  )
) else (
  if not exist "%_bucket_dir%\%~1.csv" (
    echo %There is no this app:% %~1
    exit /b 22
  )
  call "%~dp0install.cmd" %~1 || exit /b 1
)
endlocal
