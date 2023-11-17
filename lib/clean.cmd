setlocal

for %%G in ("%_cache_dir%" "%_bucket_dir%" "%_downloads_dir%") do (
  set /p "_cleaning_cache_tips=%Cleaning% %%~nG ... " <nul
  rmdir /s /q %%G ^
    && echo %Done% ^
    || (
      echo %Failed to clean.%
      exit /b 26
    )
)
endlocal
