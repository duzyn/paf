set "_bin_dir=%~dp0..\bin"
set "_bucket_dir=%~dp0..\bucket"
set "_cache_dir=%~dp0..\cache"
set "_downloads_dir=%~dp0..\downloads"
@REM set "_downloads_dir=%~dp0..\downloads"

:: https://ss64.com/nt/syntax-64bit.html
if "%PROCESSOR_ARCHITECTURE%" == "ARM64" (
  echo Not support ARM64
  exit /b 1
)

set "_aria2c=%_bin_dir%\x64\aria2c.exe"
set "_rg=%_bin_dir%\x64\rg.exe"
set "_sed=%_bin_dir%\x64\sed.exe"
set "_autohotkey=%_bin_dir%\x64\autohotkey.exe"

if "%PROCESSOR_ARCHITECTURE%" == "x86" (
  if not defined PROCESSOR_ARCHITEW6432 (
    set "_aria2c=%_bin_dir%\x86\aria2c.exe"
    set "_rg=%_bin_dir%\x86\rg.exe"
    set "_sed=%_bin_dir%\x86\sed.exe"
    set "_autohotkey=%_bin_dir%\x86\autohotkey.exe"
  )
)

if not exist "%_bin_dir%" mkdir "%_bin_dir%"
if not exist "%_bucket_dir%" mkdir "%_bucket_dir%"
if not exist "%_cache_dir%" mkdir "%_cache_dir%"
if not exist "%_downloads_dir%" mkdir "%_downloads_dir%"
