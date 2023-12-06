if not exist "%~dp0..\config.ini" (
  echo There is no config.ini.
  exit /b 1
)

for /f "tokens=1-2 delims==" %%G in ('type "%~dp0..\config.ini" ^| findstr /v /r /c:"^[;\[]"') do (
  set "_config.%%G=%%H"
)