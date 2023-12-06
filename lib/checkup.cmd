setlocal

echo Checking dependencies ... 
for %%G in ("%_aria2c%" "%_rg%" "%_sed%" "%_autohotkey%") do (
  set /p "_checking-tips=Checking %%~nG ... " <nul
  if exist %%G (
    echo OK
  ) else (
    echo Not found
  )
)
endlocal
