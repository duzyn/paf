setlocal

if "%~1" == "" (
  echo Please input an app name.
  exit /b 21
)
dir "%_bucket_dir%" | findstr /i /c:%~1 >nul || (
  echo There is no this app: %~1
  exit /b 22
)
echo Search results:
set _apps_count_tmp=0
for /f %%G in ('dir /b "%_bucket_dir%" ^| findstr /i /c:%~1') do (
  if [%%G] neq [] set /a _apps_count_tmp+=1 >nul
  echo %%~nG
)
for /f "delims=" %%G in ('echo %_apps_count_tmp%') do set _apps_count=%%G
echo Total of apps: %_apps_count%
set "_apps_count_tmp="
endlocal
