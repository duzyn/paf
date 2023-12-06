setlocal
call "%~dp0config.cmd" || exit /b 1
call "%~dp0_get_app_info.cmd" %~1 || exit /b 1

if not exist "%_downloads_dir%\%_app_filename%" (
  echo Downloading %_app_filename% ...
  if [%_app_package_url_1%] == [] (
    call "%_aria2c%" "%_app_package_url_2%?use_mirror={%_config.sourceforge-mirror-list%}" ^
      --dir="%_downloads_dir%" ^
      --out="%_app_filename%" ^
      --parameterized-uri=true ^
      --continue=true ^
      --console-log-level=error ^
      --max-concurrent-downloads=%_config.aria2-max-concurrent-downloads% ^
      --max-connection-per-server=%_config.aria2-max-connection-per-server% ^
      --min-split-size=%_config.aria2-min-split-size% ^
      --split=%_config.aria2-split% ^
      --connect-timeout=%_config.aria2-connect-timeout% ^
      --max-tries=%_config.aria2-max-tries% ^
      || (
        echo Download failed.
        exit /b 23
      )
  ) else (
    call "%_aria2c%" "%_app_package_url_1%" ^
      --referer="%_app_referer_url_1%" ^
      --dir="%_downloads_dir%" ^
      --out="%_app_filename%" ^
      --continue=true ^
      --console-log-level=error ^
      --max-concurrent-downloads=%_config.aria2-max-concurrent-downloads% ^
      --max-connection-per-server=%_config.aria2-max-connection-per-server% ^
      --min-split-size=%_config.aria2-min-split-size% ^
      --split=%_config.aria2-split% ^
      --connect-timeout=%_config.aria2-connect-timeout% ^
      --max-tries=%_config.aria2-max-tries% ^
      || (
        echo Download failed.
        exit /b 23
      )
  )
)

set /p "_checking_hash_tips=Checking hash of %_app_filename% ... " <nul

where /q certutil || (
  echo CertUtil is not found.
  exit /b 27
)

for /f "skip=1 delims=" %%G in ('certutil -hashfile "%_downloads_dir%\%_app_filename%" sha256 ^| findstr /v /i /c:certutil') do (
  set _hash_sha256=%%G
)
for /f "skip=1 delims=" %%G in ('certutil -hashfile "%_downloads_dir%\%_app_filename%" md5 ^| findstr /v /i /c:certutil') do (
  set _hash_md5=%%G
)
set "_hash_is_correct="
if "%_hash_md5%" == "%_app_hash%" set "_hash_is_correct=yes"
if "%_hash_sha256%" == "%_app_hash%" set "_hash_is_correct=yes"
if "%_hash_is_correct%" == "yes" (
  echo OK
) else (
  echo Hash is wrong.
  del /q "%_downloads_dir%\%_app_filename%"
  exit /b 24
)
endlocal
