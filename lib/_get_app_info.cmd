setlocal

if "%~1" == "" (
  echo %Please input an app name.%
  exit /b 21
)

if not exist "%_bucket_dir%\%~1.csv" (
  echo %There is no this app:% %~1
  exit /b 22
)

for /f tokens^=1^,3^ delims^=^" %%G in ('type "%_bucket_dir%\%~1.csv" ^| findstr /v /r /c:"^[;\[]"') do (
  set _parameter.%%G=%%H
)

endlocal & (
  set "_app_name=%_parameter.Name%"
  set "_app_appid=%_parameter.AppID%"
  set "_app_version=%_parameter.Version%"
  set "_app_homepage=%_parameter.Homepage%"
  set "_app_filename=%_parameter.FileName%"
  set "_app_hash=%_parameter.Hash%"
  set "_app_package_url_1=%_parameter.PackageUrl1%"
  set "_app_referer_url_1=%_parameter.RefererUrl1%"
  set "_app_package_url_2=%_parameter.PackageUrl2%"
)
