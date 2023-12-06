setlocal

if "%~1" == "" (
  echo Please input a file.
  exit /b 41
)

if not exist "%~1" (
  echo There is no this app: %~1
  exit /b 22
)

for /f tokens^=1^ delims^=^" %%G in ('type "%~1"') do (
  call "%~dp0install.cmd" %%G
)
endlocal
