:: https://lallouslab.net/2019/04/16/batchography-detect-windows-language/
:: https://docs.microsoft.com/en-us/previous-versions/office/developer/speech-technologies/hh361638(v=office.14)
set "_lang_id=0409"
set "_lang=English"

reg query "HKLM\SYSTEM\ControlSet001\Control\Nls\Language" /v Installlanguage >nul ^
  && for /f "tokens=3" %%G in ('reg query "HKLM\SYSTEM\ControlSet001\Control\Nls\Language" /v Installlanguage') do (
    set "_lang_id=%%G"
  ) ^
  || echo No support for localization on this OS.

if "%_lang_id%" == "0804" set "_lang=Chinese"
if "%_lang_id%" == "0411" set "_lang=Japanese"
if "%_lang_id%" == "0412" set "_lang=Korean"
:: Add more languages here

if not exist "%~dp0..\languages\%_lang%.lng" (
  echo Language file is not found: %_lang%.
  if not exist "%~dp0..\languages\English.lng" (
    echo There are no language files.
    exit /b 1
  )
)

for /f "tokens=1-2 delims==" %%G in ('type "%~dp0..\languages\%_lang%.lng" ^| findstr /v /r /c:"^[;\[]"') do (
  set "%%G=%%H"
)
