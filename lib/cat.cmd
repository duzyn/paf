setlocal
call "%~dp0_get_app_info.cmd" %~1 || exit /b 1

type "%_bucket_dir%\%~1.csv" ^
  || (
    echo %Failed to show  app manifest:% %~1 
    exit /b 25
  )
endlocal
