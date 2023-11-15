@echo off
:: Configurations
set "_version=1.0"
set "_bin_dir=%~dp0bin"
set "_bucket_dir=%~dp0bucket"
set "_cache_dir=%~dp0cache"
set "_downloads_dir=%~dp0downloads"

:: https://ss64.com/nt/syntax-64bit.html
if "%PROCESSOR_ARCHITECTURE%"=="ARM64" (
  echo %Not support ARM64%
)
set "_aria2c=%_bin_dir%\x64\aria2c.exe"
set "_rg=%_bin_dir%\x64\rg.exe"
set "_sed=%_bin_dir%\x64\sed.exe"
set "_autohotkey=%_bin_dir%\x64\autohotkey.exe"
if "%PROCESSOR_ARCHITECTURE%"=="x86" (
  if not defined PROCESSOR_ARCHITEW6432 (
    set "_aria2c=%_bin_dir%\x86\aria2c.exe"
    set "_rg=%_bin_dir%\x86\rg.exe"
    set "_sed=%_bin_dir%\x86\sed.exe"
    set "_autohotkey=%_bin_dir%\x86\autohotkey.exe"
  )
)

:: aria2 manual: https://aria2.github.io/manual/en/html/index.html
set "_aria2c_min_split_size=1MB"
set "_aria2c_split=10"
set "_aria2c_max_connection_per_server=10"
set "_aria2c_max_concurrent_downloads=50"
set "_aria2c_max_tries=2"
set "_aria2c_connect_timeout=10"

:: When download packages from SourceForge, we set all the mirrors to accelerate
:: download. Available values: SourceForge mirror list is on here:
:: https://sourceforge.net/p/forge/documentation/Mirrors/
set "_sourceforge_mirror_list=altushost-swe,cfhcable,cytranet,deac-ams,deac-fra,deac-riga,excellmedia,freefr,gigenet,ixpeering,jaist,kumisystems,liquidtelecom,nav,nchc,netcologne,netix,newcontinuum,onboardcloud,phoenixnap,razaoinfo,sinalbr,sitsa,tenet,udomain,ufpr,unlimited,versaweb,webwerks,yer,zenlayer"

:: It's useful to use a GitHub mirror to download files in GitHub Releases, RAW
:: or Archive. Available values: false, a GitHub mirror prefix, eg.
set "_github_mirror=false"
:: set "_github_mirror=https://gh-proxy.com/github.com"
:: set "_github_mirror=https://mirror.ghproxy.com/github.com"
:: set "_github_mirror=https://githubfast.com"

if not exist "%_bin_dir%" mkdir "%_bin_dir%"
if not exist "%_bucket_dir%" mkdir "%_bucket_dir%"
if not exist "%_cache_dir%" mkdir "%_cache_dir%"
if not exist "%_downloads_dir%" mkdir "%_downloads_dir%"

:: https://lallouslab.net/2019/04/16/batchography-detect-windows-language/
:: https://docs.microsoft.com/en-us/previous-versions/office/developer/speech-technologies/hh361638(v=office.14)
for /f "tokens=3" %%G in ('reg query "HKLM\SYSTEM\ControlSet001\Control\Nls\Language" /v Installlanguage') do (
  set "_lang_id=%%G"
)
:: 0409 English
set "_lang=English"
if "%_lang_id%" == "0804" set "_lang=Chinese"
:: Add more languages here

for /f "tokens=1-2 delims==" %%G in ('type "%~dp0languages\%_lang%.lng"') do (
  set "%%G=%%H"
)

:: Help
if [%~1]==[] call :help
if "%~1"=="help" call :help
if "%~1"=="--help" call :help
if "%~1"=="-h" call :help
if "%~1"=="cat" call :cat %~2
if "%~1"=="checkup" call :checkup
if "%~1"=="clean" call :clean
if "%~1"=="download" (
  if [%~2]==[] call :download
  :_download_loop
  if not [%~2]==[] (
    call :download %~2
    shift /1
    goto :_download_loop
  )
)
if "%~1"=="export" call :export
if "%~1"=="home" call :home %~2
if "%~1"=="import" call :import %~2
if "%~1"=="info" call :info %~2
if "%~1"=="install" (
  if [%~2]==[] call :install
  :_install_loop
  if not [%~2]==[] (
    call :install %~2
    shift /1
    goto :_install_loop
  )
)
if "%~1"=="known" call :known
if "%~1"=="list" call :list
if "%~1"=="search" call :search %~2
if "%~1"=="status" call :status
if "%~1"=="uninstall" (
  if [%~2]==[] call :uninstall
  :_uninstall_loop
  if not [%~2]==[] (
    call :uninstall %~2
    shift /1
    goto :_uninstall_loop
  )
)
if "%~1"=="update"  call :update
if "%~1"=="upgrade" (
  if [%~2]==[] call :upgrade
  :_upgrade_loop
  if not [%~2]==[] (
    call :upgrade %~2
    shift /1
    goto :_upgrade_loop
  )
)

@REM // TODO Quit all opened apps
@REM // TODO Backup, restore
@REM // TODO Install specific version app
goto :eof

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:help
setlocal
echo paf %_version%
echo %A command-line installer for PortableApps.%
echo %Project home page:% https://github.com/duzyn/paf
echo:
echo %USAGE:%
echo     %paf COMMAND [ARGS]%
echo:
echo %ARGS:%
echo     AppID
echo         %AppID is defined in PortableApps.com Format, reference:%
echo         https://portableapps.com/development/portableapps.com_format#appinfo
echo     *
echo         %When upgrading apps, * means all.%
echo:
echo %COMMANDS:%
echo     cat
echo         %Show content of specified app manifest.%
echo             paf cat FirefoxPortable
echo     checkup
echo         %Check for dependencies.%
echo             paf checkup
echo     clean
echo         %Clean the download cache.%
echo             paf clean
echo     download
echo         %Download apps in the downloads folder and verify hashes.%
echo             paf download FirefoxPortable
echo             paf download FirefoxPortable GoogleChromePortable
echo     export
echo         %Exports installed apps in CSV format.%
echo             paf export
echo     help
echo         %Show this help.%
echo             paf
echo             paf help
echo             paf --help
echo             paf -h
echo     home
echo         %Opens the app homepage.%
echo             paf home FirefoxPortable
echo     import
echo         %Imports apps from a text file.%
echo             paf import apps.csv
echo     info
echo         %Display information about an app.%
echo             paf info FirefoxPortable
echo     install
echo         %Install an app.%
echo             paf install FirefoxPortable
echo             paf install FirefoxPortable GoogleChromePortable
echo     known
echo         %List all known apps.%
echo             paf known
echo     list
echo         %List installed apps.%
echo             paf list
echo     search
echo         %Search available apps.%
echo             paf search firefox
echo     status
echo         %Show status and check for new app versions.%
echo             paf status
echo     uninstall
echo         %Uninstall an app.%
echo             paf uninstall FirefoxPortable
echo             paf uninstall FirefoxPortable GoogleChromePortable
echo     update
echo         %Update cache.%
echo             paf update
echo     upgrade
echo         %Update an app.%
echo             paf upgrade FirefoxPortable
echo             paf upgrade FirefoxPortable GoogleChromePortable
echo             paf upgrade *
endlocal
exit /b 0

:: Usage: call :_get_app_info <app>
:_get_app_info
setlocal
for /f tokens^=1^,3^ delims^=^" %%G in ('type "%_bucket_dir%\%~1.csv"') do (
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
exit /b 0

:: Usage: call :_get_installed_app_info <app>
:_get_installed_app_info
setlocal
for /f "tokens=1-2 delims==" %%G in ('type "%~d0\PortableApps\%~1\App\AppInfo\appinfo.ini"') do (
    set _parameter.%%G=%%H
)
endlocal & (
  set "_installed_app_name=%_parameter.Name%"
  set "_installed_app_appid=%_parameter.AppID%"
  set "_installed_app_display_version=%_parameter.DisplayVersion%"
  set "_installed_app_homepage=%_parameter.Homepage%"
)
exit /b 0

:: Usage: call :_get_installed_plugin_info <plugin>
:_get_installed_plugin_info
setlocal
for /f "tokens=1-2 delims==" %%G in ('type "%~d0\PortableApps\CommonFiles\%~1\App\AppInfo\plugininstaller.ini"') do (
    set _parameter.%%G=%%H
)
endlocal & (
  set "_installed_plugin_name=%_parameter.Name%"
  set "_installed_plugin_appid=%_parameter.AppID%"
  set "_installed_plugin_display_version=%_parameter.DisplayVersion%"
  set "_installed_plugin_homepage=%_parameter.Homepage%"
)
exit /b 0

:cat
setlocal
if [%~1]==[] (
  echo %Please input an app name.%
  exit /b 21
)
if not exist "%_bucket_dir%\%~1.csv" (
  echo %There is no this app:% %~1.
  exit /b 22
)
type "%_bucket_dir%\%~1.csv" || (
  echo %Failed to show  app manifest:% %~1. 
  exit /b 25
)
endlocal
exit /b 0

:checkup
setlocal
echo %Checking dependencies% ... 
for %%G in ("%_aria2c%" "%_rg%" "%_sed%") do (
  set /p "_checking-tips=%Checking% %%~G ... " <nul
  if exist %%G (
    echo %OK%
  ) else (
    echo %Not found%
  )
)
endlocal
exit /b 0

:clean
setlocal
for %%G in ("%_cache_dir%" "%_bucket_dir%" "%_downloads_dir%") do (
  set /p "_cleaning_cache_tips=%Cleaning% %%~G ... " <nul
  rmdir /s /q %%G && echo Done || (
    echo %Failed to clean.%
    exit /b 26
  )
)
endlocal
exit /b 0

:download
setlocal
if [%~1]==[] (
  echo %Please input an app name.%
  exit /b 21
)
if not [%~2]==[] (
  shift /1
  call :download %~1
)
if not exist "%_bucket_dir%\%~1.csv" (
  echo %There is no this app:% %~1.
  exit /b 22
)
call :_get_app_info %~1 || exit /b 1

if not exist "%_downloads_dir%\%_app_filename%" (
  echo %Downloading% %_app_filename% ...
  if [%_app_package_url_1%]==[] (
    "%_aria2c%" "%_app_package_url_2%?use_mirror={%_sourceforge_mirror_list%}" ^
      --dir="%_downloads_dir%" --out="%_app_filename%" ^
      --parameterized-uri=true --continue=true --console-log-level=error ^
      --max-concurrent-downloads=%_aria2c_max_concurrent_downloads% ^
      --max-connection-per-server=%_aria2c_max_connection_per_server% ^
      --min-split-size=%_aria2c_min_split_size% ^
      --split=%_aria2c_split% ^
      --connect-timeout=%_aria2c_connect_timeout% ^
      --max-tries=%_aria2c_max_tries% || (
        echo %Download failed.%
        exit /b 23
      )
  ) else (
    "%_aria2c%" "%_app_package_url_1%" --referer="%_app_referer_url_1%" ^
      --dir="%_downloads_dir%" --out="%_app_filename%" ^
      --continue=true --console-log-level=error ^
      --max-concurrent-downloads=%_aria2c_max_concurrent_downloads% ^
      --max-connection-per-server=%_aria2c_max_connection_per_server% ^
      --min-split-size=%_aria2c_min_split_size% ^
      --split=%_aria2c_split% || (
        echo %Download failed.%
        exit /b 23
      )
  )
)

set /p "_checking_hash_tips=%Checking hash of% %_app_filename% ... " <nul
where /q certutil || (
  echo %CertUtil is not found.%
  exit /b 27
)
for /f "skip=1 delims=" %%G in ('certutil -hashfile "%_downloads_dir%\%_app_filename%" sha256 ^| findstr /v /i /c:certutil') do (
  set _hash_sha256=%%G
)
for /f "skip=1 delims=" %%G in ('certutil -hashfile "%_downloads_dir%\%_app_filename%" md5 ^| findstr /v /i /c:certutil') do (
  set _hash_md5=%%G
)
set "_hash_is_correct="
if "%_hash_md5%"=="%_app_hash%" set "_hash_is_correct=yes"
if "%_hash_sha256%"=="%_app_hash%" set "_hash_is_correct=yes"

if "%_hash_is_correct%"=="yes" (
  echo %OK%
) else (
  echo %Hash is wrong.%
  del /q "%_downloads_dir%\%_app_filename%"
  exit /b 24
)
endlocal
exit /b 0

:: Usage: call :export
:export
setlocal enabledelayedexpansion
if not exist "%~d0\PortableApps" (
  echo %There is no portable apps in% %~d0\PortableApps.
  exit /b 31
)
dir "%~d0\PortableApps" | findstr /c:Portable >nul || (
  echo %There is no portable apps in% %~d0\PortableApps.
  exit /b 31
)
for /f %%G in ('dir /b "%~d0\PortableApps" ^| findstr /c:Portable') do (
  call :_get_installed_app_info %%G || exit /b 1
  echo "!_installed_app_appid!","!_installed_app_display_version!"
)
for /f %%G in ('dir /b "%~d0\PortableApps\CommonFiles"') do (
  call :_get_installed_plugin_info %%G || exit /b 1
  echo "!_installed_plugin_appid!","!_installed_plugin_display_version!"
)
endlocal
exit /b 0

:: Usage: call :home <app>
:home
setlocal
if [%~1]==[] (
  echo %Please input an app name.%
  exit /b 21
)
if not exist "%_bucket_dir%\%~1.csv" (
  echo %There is no this app:% %~1.
  exit /b 22
)
call :_get_app_info %~1 || exit /b 1
start %_app_homepage%
endlocal
exit /b 0

:: Usage: call :import <file.csv>
:import
setlocal
if [%~1]==[] (
  echo %Please input a file.%
  exit /b 41
)
if not exist "%~1" (
  echo %There is no this app:% %~1.
  exit /b 22
)
for /f tokens^=1^ delims^=^" %%G in ('type "%~1"') do (
    call :install %%G
)
endlocal
exit /b 0

:: Usage: call :import <app>
:info
setlocal
if [%~1]==[] (
  echo %Please input an app name.%
  exit /b 21
)
if not exist "%_bucket_dir%\%~1.csv" (
  echo %There is no this app:% %~1.
  exit /b 22
)
call :_get_app_info %~1 || exit /b 1
echo Name: %_app_name%
echo AppID: %_app_appid%
echo Version: %_app_version%
echo Homepage: %_app_homepage%
endlocal
exit /b 0

:: Usage: call :install <app>
:install
setlocal
if [%~1]==[] (
  echo %Please input an app name.%
  exit /b 21
)
if not [%~2]==[] (
  shift /1
  call :install %~1
)
if not exist "%_bucket_dir%\%~1.csv" (
  echo %There is no this app:% %~1.
  exit /b 22
)
call :_get_app_info %~1 || exit /b 1
if exist "%~d0\PortableApps\%~1\App\AppInfo\appinfo.ini" (
  call :_get_installed_app_info %~1 || exit /b 1
)
if exist "%~d0\PortableApps\CommonFiles\%~1\App\AppInfo\plugininstaller.ini" (
  call :_get_installed_plugin_info %~1 || exit /b 1
)

if exist "%~d0\PortableApps\%~1\App\AppInfo\appinfo.ini" (
  if "%_installed_app_display_version%" neq "%_app_version%" (
    echo %~1 %_installed_app_display_version% %is installed.%
    echo * %~1 %_installed_app_display_version% -^> %_app_version%
    call :download %~1
  ) else (
    echo %~1 %is up to date.%
    exit /b 72
  )
)
if exist "%~d0\PortableApps\CommonFiles\%~1\App\AppInfo\plugininstaller.ini" (
  if "%_installed_plugin_display_version%" neq "%_app_version%" (
    echo %~1 %_installed_plugin_display_version% %is installed.%
    echo * %~1 %_installed_plugin_display_version% -^> %_app_version%
    call :download %~1
  ) else (
    echo %~1 %is up to date.%
    exit /b 72
  )
)

if not exist "%~d0\PortableApps\%~1\App\AppInfo\appinfo.ini" (
  if not exist "%~d0\PortableApps\CommonFiles\%~1\App\AppInfo\plugininstaller.ini" (
    call :download %~1
  )
)

if exist "%_downloads_dir%\%_app_filename%" (
  echo %Installing% %_app_appid% %_app_version% ... 
  @REM echo %Please continue with the PortableApps.com Installer.%
  :: PortableApps installer doesn't support installer command options, https://portableapps.com/node/32410
  call "%_autohotkey%" "%~dp0bin\paf_install.ahk" "%_downloads_dir%\%_app_filename%" "%~d0\PortableApps\%~1" ^
    && echo %_app_appid% %_app_version% %was installed successfully.% ^
    || (
      echo %Installation failed.%
      exit /b 71
    )
)
endlocal
exit /b 0

:: Usage: call :known
:known
setlocal enabledelayedexpansion
echo "Name","AppID","Version","Homepage","FileName","Hash","PackageUrl1","RefererUrl1","PackageUrl2"
for %%G in ("%_bucket_dir%\*.csv") do (
  call :_get_app_info %%~nG || exit /b 1
  echo "!_app_name!","!_app_appid!","!_app_version!","!_app_homepage!","!_app_filename!","!_app_hash!","!_app_package_url_1!","!_app_referer_url_1!","!_app_package_url_2!"
)
endlocal
exit /b 0

:: Usage: call :list
:list
setlocal enabledelayedexpansion
if not exist "%~d0\PortableApps" (
  echo %There is no portable apps in% %~d0\PortableApps.
  exit /b 31
)
dir "%~d0\PortableApps" | findstr /c:Portable >nul || (
  echo %There is no portable apps in% %~d0\PortableApps.
  exit /b 31
)
echo %Installed apps:%
set _apps_count_tmp=0
for /f %%G in ('dir /b "%~d0\PortableApps" ^| findstr /c:Portable') do (
  call :_get_installed_app_info %%G || exit /b 1
  if [!_installed_app_appid!] neq [] (
    echo * !_installed_app_appid! !_installed_app_display_version!
    set /a _apps_count_tmp+=1 >nul
  )
)
for /f %%G in ('dir /b "%~d0\PortableApps\CommonFiles"') do (
  call :_get_installed_plugin_info %%G || exit /b 1
  if [!_installed_plugin_appid!] neq [] (
    echo * !_installed_plugin_appid! !_installed_plugin_display_version!
    set /a _apps_count_tmp+=1 >nul
  )
)
for /f "delims=" %%G in ('echo %_apps_count_tmp%') do set _apps_count=%%G
echo %Total of apps:% %_apps_count%
set "_apps_count_tmp="
endlocal
exit /b 0

:: Usage: call :status
:status
setlocal enabledelayedexpansion
if not exist "%~d0\PortableApps" (
  echo %There is no portable apps in% %~d0\PortableApps.
  exit /b 31
)
echo %Outdated apps:%
set _apps_count_tmp=0
for /f %%G in ('dir /b "%~d0\PortableApps" ^| findstr /c:Portable') do (
  if [%%G]==[] (
    echo %There is no portable apps.%
    exit /b 21
  )
  if not exist "%_bucket_dir%\%%G.csv" (
    echo %There is no this app:% %~1.
    exit /b 22
  )
  if not exist "%~d0\PortableApps\%%G\App\AppInfo\appinfo.ini" (
    echo %App is not installed:% %~1
    exit /b 81
  )
  call :_get_app_info %%G || exit /b 1
  call :_get_installed_app_info %%G || exit /b 1
  if "!_installed_app_display_version!" neq "!_app_version!" (
    echo * !_installed_app_appid! !_installed_app_display_version! -^> !_app_version!
    set /a _apps_count_tmp+=1 >nul
  )
)
for /f %%G in ('dir /b "%~d0\PortableApps\CommonFiles"') do (
  if [%%G]==[] (
    echo %There is no portable plugins.%
    exit /b 21
  )
  if not exist "%_bucket_dir%\%%G.csv" (
    echo %There is no this plugins:% %~1.
    exit /b 22
  )
  if not exist "%~d0\PortableApps\CommonFiles\%%G\App\AppInfo\plugininstaller.ini" (
    echo %Plugin is not installed:% %~1
    exit /b 81
  )
  call :_get_app_info %%G || exit /b 1
  call :_get_installed_plugin_info %%G || exit /b 1
  if "!_installed_plugin_display_version!" neq "!_app_version!" (
    echo * !_installed_plugin_appid! !_installed_plugin_display_version! -^> !_app_version!
    set /a _apps_count_tmp+=1 >nul
  )
)
for /f "delims=" %%G in ('echo %_apps_count_tmp%') do set _apps_count=%%G
echo %Total of apps:% %_apps_count%
set "_apps_count_tmp="
endlocal
exit /b 0

:: Usage: call :search <app>
:search
setlocal
if [%~1]==[] (
  echo %Please input an app name.%
  exit /b 21
)
dir "%_bucket_dir%" | findstr /i /c:%~1 >nul || (
  echo %There is no this app:% %~1.
  exit /b 22
)
echo %Search results:%
set _apps_count_tmp=0
for /f %%G in ('dir /b "%_bucket_dir%" ^| findstr /i /c:%~1') do (
  if [%%G] neq [] set /a _apps_count_tmp+=1 >nul
  echo * %%~nG
)
for /f "delims=" %%G in ('echo %_apps_count_tmp%') do set _apps_count=%%G
echo %Total of apps:% %_apps_count%
set "_apps_count_tmp="
endlocal
exit /b 0

:: Usage: call :uninstall <app>
:uninstall
setlocal
if [%~1]==[] (
  echo %Please input an app name.%
  exit /b 21
)
if not [%~2]==[] (
  shift /1
  call :uninstall %~1
)
if not exist "%~d0\PortableApps\%~1\" (
  echo %App is not installed:% %~1.
  exit /b 81
)
call :_get_installed_app_info %~1 || exit /b 1
echo %Uninstalling% %_installed_app_appid% %_installed_app_display_version% ...
echo %Removing% %~d0\PortableApps\%_installed_app_appid%\ ...
rmdir /q /s "%~d0\PortableApps\%_installed_app_appid%\" || exit /b 82
echo %_installed_app_appid% %_installed_app_display_version% %was uninstalled successfully.%
endlocal
exit /b 0

:: Usage: call :update
:update
setlocal
del /q "%_cache_dir%\*"
:: Download apps index page
set /p "_updating_cache_tips=%Updating apps cache% ... " <nul
"%_aria2c%" https://portableapps.com/apps --dir="%_cache_dir%" --out=apps.html ^
  --quiet=true --conditional-get=true --allow-overwrite=true ^
    || (
      echo %Download failed.%
      exit /b 23
    )

:: List all apps' url, then delete duplicated lines Thunderbird is in category
:: office and internet, Dia is in category office and graphics & pictures,
:: Nuv(Kompozer) is in category development and internet.
copy nul "%_cache_dir%\apps-url.txt" >nul
for /f tokens^=2^ delims^=^" %%G in ('call "%_rg%" a\s+href^=\"/apps/.+\" --only-matching "%_cache_dir%\apps.html"') do (
  echo https://portableapps.com%%G>>"%_cache_dir%\apps-url.txt"
)

:: URL redirection
"%_sed%" -i -e "s|utilities/eraser_portable|security/eraser-portable|g" ^
            -e "s|utilities/eraserdrop_portable|security/eraserdrop-portable|g" ^
            -e "s|development/nvu_portable|development/kompozer-portable|g" ^
            "%_cache_dir%\apps-url.txt"

:: URL deletion
:: TweetDeck and TidyTabs have been removed from PortableApps.com
:: Delete apps catalog pages url
"%_sed%" -i -e "/tweetdeck-portable/d" ^
            -e "/tidytabs-portable/d" ^
            -e "/accessibility$/d" ^
            -e "/development$/d" ^
            -e "/education$/d" ^
            -e "/games$/d" ^
            -e "/graphics_pictures$/d" ^
            -e "/internet$/d" ^
            -e "/music_video$/d" ^
            -e "/office$/d" ^
            -e "/security$/d" ^
            -e "/utilities$/d" ^
            "%_cache_dir%\apps-url.txt"

:: Extra apps not on apps.html page
(
  echo.https://portableapps.com/apps/development/nsis_portable
  echo.https://portableapps.com/apps/development/nsis_portable_ansi
  echo.https://portableapps.com/apps/development/nsis_portable_unicode
  echo.https://portableapps.com/apps/graphics_pictures/freecad-portable
  echo.https://portableapps.com/apps/graphics_pictures/freecad-portable-legacy-x86
  echo.https://portableapps.com/apps/graphics_pictures/xnview_portable
  echo.https://portableapps.com/apps/graphics_pictures/xnview-mp-portable
  echo.https://portableapps.com/apps/internet/firefox_portable
  echo.https://portableapps.com/apps/internet/firefox_portable/legacy
  echo.https://portableapps.com/apps/internet/firefox_portable/test
  echo.https://portableapps.com/apps/internet/firefox-portable-esr
  echo.https://portableapps.com/apps/internet/firefox-portable-nightly
  echo.https://portableapps.com/apps/internet/google_chrome_portable
  echo.https://portableapps.com/apps/internet/google-chrome-portable-64
  echo.https://portableapps.com/apps/internet/google-chrome-portable-beta
  echo.https://portableapps.com/apps/internet/google-chrome-portable-dev
  echo.https://portableapps.com/apps/internet/opera_portable
  echo.https://portableapps.com/apps/internet/opera-gx-portable
  echo.https://portableapps.com/apps/internet/opera-portable-legacy-12
  echo.https://portableapps.com/apps/internet/opera-portable-legacy-36
  echo.https://portableapps.com/apps/internet/thunderbird_portable
  echo.https://portableapps.com/apps/internet/thunderbird_portable/test
  echo.https://portableapps.com/apps/internet/thunderbird-portable-legacy-102
  echo.https://portableapps.com/apps/internet/thunderbird-portable-legacy-52
  echo.https://portableapps.com/apps/internet/thunderbird-portable-legacy-68
  echo.https://portableapps.com/apps/internet/thunderbird-portable-legacy-91
  echo.https://portableapps.com/apps/music_video/musescore_portable
  echo.https://portableapps.com/apps/music_video/musescore-portable-legacy-3
  echo.https://portableapps.com/apps/office/abiword_portable
  echo.https://portableapps.com/apps/office/abiword-portable-test
  echo.https://portableapps.com/apps/office/libreoffice_portable
  echo.https://portableapps.com/apps/office/libreoffice-portable-legacy-5.4
  echo.https://portableapps.com/apps/office/libreoffice-portable-still
  echo.https://portableapps.com/apps/security/eraser-dot-net-portable
  echo.https://portableapps.com/apps/security/eraser-portable
  echo.https://portableapps.com/apps/utilities/colour-contrast-analyser-classic-portable
  echo.https://portableapps.com/apps/utilities/java_portable
  echo.https://portableapps.com/apps/utilities/java_portable_64
  echo.https://portableapps.com/apps/utilities/jdkportable
  echo.https://portableapps.com/apps/utilities/jdkportable64
  echo.https://portableapps.com/apps/utilities/keepass_portable
  echo.https://portableapps.com/apps/utilities/keepass-pro-portable
  echo.https://portableapps.com/apps/utilities/OpenJDK
  echo.https://portableapps.com/apps/utilities/OpenJDK64
  echo.https://portableapps.com/apps/utilities/winmerge-2011-portable
  echo.https://portableapps.com/apps/utilities/yumi-portable
  echo.https://portableapps.com/apps/utilities/yumi-uefi-portable
)>>"%_cache_dir%\apps-url.txt"

:: Remove duplicated lines
rename "%_cache_dir%\apps-url.txt" "apps-url-1.txt" >nul
copy nul "%_cache_dir%\apps-url.txt" >nul
for /f "tokens=*" %%G in ('type "%_cache_dir%\apps-url-1.txt"') do (
  findstr /c:"%%G" "%_cache_dir%\apps-url.txt" >nul ^
    || echo %%G>>"%_cache_dir%\apps-url.txt"
)

:: Mozilla Firefox, Portable Edition - Legacy Editions
:: jPortable Browser Switch
:: These two apps is not in bucket.

:: Download all apps' pages
"%_aria2c%" --input-file="%_cache_dir%\apps-url.txt" --dir="%_cache_dir%" ^
  --quiet=true --conditional-get=true --allow-overwrite=false ^
  --max-concurrent-downloads=%_aria2c_max_concurrent_downloads% ^
    && echo %Done% || (
      echo %Download failed.%
      exit /b 23
    )

set /p "_updating_bucket_tips=%Updating bucket% ... " <nul
:: Get an app's meta info from its app page
copy nul "%_cache_dir%\apps-parameters.txt" >nul
for /f tokens^=1^ delims^=^" %%G in ('call "%_rg%" "antivirus\?(.+).+Antivirus.+" --only-matching --replace $1 --no-filename "%_cache_dir%"') do (
  echo %%G>>"%_cache_dir%\apps-parameters.txt"
)

:: Replace some special characters. &amp; -> &, &#39; -> ', %%2B -> +, %%20 ->
:: (space), ^ -> -, & -> nul
"%_sed%" -i -e "s@amp;@@g" ^
            -e "s@&#39;@'@g" ^
            -e "s@%%2B@+@g" ^
            -e "s@%%20@ @g" ^
            -e "s@\^@-@g" ^
            -e "s@Search & Destroy@Search Destroy@g" ^
            "%_cache_dir%\apps-parameters.txt"

del /q "%_bucket_dir%\*"
for /f "tokens=2,4,6,8,10 delims=^&=" %%O in ('type "%_cache_dir%\apps-parameters.txt"') do (
  (
    echo."Name","%%O"
    echo."AppID","%%P"
    echo."Version","%%Q"
    echo."FileName","%%R"
    echo."Hash","%%S"
    echo."PackageUrl1","https://download2.portableapps.com/portableapps/%%P/%%R"
    echo."RefererUrl1","https://portableapps.com/downloading/?a=%%P&s=s&p=&d=pa&n=%%O&f=%%R"
    echo."PackageUrl2","https://sourceforge.net/projects/portableapps/files/%%O/%%R/download"
  )>>"%_bucket_dir%\%%P.csv"
)

:: Write homepage to bucket
for /f "tokens=3-5 delims=/" %%G in ('type "%_cache_dir%\apps-url.txt"') do (
  for /f "tokens=1 delims=^&" %%O in ('call "%_rg%" ";a=(.+)&amp;v=" --only-matching --replace $1 "%_cache_dir%\%%I" ^| "%_sed%" "s@%%2B@+@g"') do (
    echo "Homepage","https://portableapps.com/%%G/%%H/%%I">>"%_bucket_dir%\%%O.csv"
  )
)

:: Add XonoticPortable and SauerbratenPortable csv in bucket dir. They don't
:: have antivirus link because their packages size are huge.

:: XonoticPortable.csv
for /f "tokens=2,9,11 delims=^&=" %%O in ('call "%_rg%" "/\?a=.+\.paf\.exe" --only-matching "%_cache_dir%\xonotic-portable"') do (
  echo "Name","%%P">>"%_bucket_dir%\XonoticPortable.csv"
  echo "AppID","%%O">>"%_bucket_dir%\XonoticPortable.csv"
  echo "FileName","%%Q">>"%_bucket_dir%\XonoticPortable.csv"
  echo "PackageUrl1","https://download2.portableapps.com/portableapps/%%O/%%Q">>"%_bucket_dir%\XonoticPortable.csv"
)
for /f "tokens=* delims=" %%O in ('call "%_rg%" "Version\s(.+)\sfor\sWindows" --only-matching --replace $1 "%_cache_dir%\xonotic-portable"') do (
  echo "Version","%%O">>"%_bucket_dir%\XonoticPortable.csv"
)
for /f "tokens=* delims=" %%O in ('call "%_rg%" "Hash.+:\s(.+)</li>" --only-matching --replace $1 "%_cache_dir%\xonotic-portable"') do (
  echo "Hash","%%O">>"%_bucket_dir%\XonoticPortable.csv"
)
for /f "tokens=* delims=" %%O in ('call "%_rg%" "/downloading/\?a=.+\.paf\.exe" --only-matching "%_cache_dir%\xonotic-portable"') do (
  echo "RefererUrl1","https://portableapps.com%%O">>"%_bucket_dir%\XonoticPortable.csv"
)
for /f "tokens=* delims=" %%O in ('call "%_rg%" "canonical.+href.+(http.+portable)" --only-matching --replace $1 "%_cache_dir%\xonotic-portable"') do (
  echo "Homepage","%%O">>"%_bucket_dir%\XonoticPortable.csv"
)

:: SauerbratenPortable.csv
for /f "tokens=2,9 delims=^&=" %%O in ('call "%_rg%" "/\?a=.+\.paf\.exe" --only-matching "%_cache_dir%\sauerbraten_portable"') do (
  echo "Name","Sauerbraten Portable">>"%_bucket_dir%\SauerbratenPortable.csv"
  echo "AppID","%%O">>"%_bucket_dir%\SauerbratenPortable.csv"
  echo "FileName","%%P">>"%_bucket_dir%\SauerbratenPortable.csv"
  echo "PackageUrl2","https://sourceforge.net/projects/portableapps/files/Sauerbraten Portable/%%P/download?use_mirror={%_sourceforge_mirror_list%}">>"%_bucket_dir%\SauerbratenPortable.csv"
)
)
for /f "tokens=* delims=" %%O in ('call "%_rg%" "Version\s(.+)\sfor\sWindows" --only-matching --replace $1 "%_cache_dir%\sauerbraten_portable"') do (
  echo "Version","%%O">>"%_bucket_dir%\SauerbratenPortable.csv"
)
for /f "tokens=* delims=" %%O in ('call "%_rg%" "Hash.+:\s(.+)</li>" --only-matching --replace $1 "%_cache_dir%\sauerbraten_portable"') do (
  echo "Hash","%%O">>"%_bucket_dir%\SauerbratenPortable.csv"
)
for /f "tokens=* delims=" %%O in ('call "%_rg%" "canonical.+href.+(http.+portable)" --only-matching --replace $1 "%_cache_dir%\sauerbraten_portable"') do (
  echo "Homepage","%%O">>"%_bucket_dir%\SauerbratenPortable.csv"
)

:: // BUG Delete these apps' PackageUrl1 and RefererUrl1, because they are 404 not
:: found. It's a PortableApps.com's bug.

:: SMPlayer
"%_sed%" -i -e "/PackageUrl1/d" ^
            -e "/RefererUrl1/d" ^
            "%_bucket_dir%\SMPlayerPortable.csv"

:: EmsisoftEmergencyKitPortable
"%_sed%" -i -e "/PackageUrl1/d" ^
            -e "/RefererUrl1/d" ^
            "%_bucket_dir%\EmsisoftEmergencyKitPortable.csv"

:: Correct some apps' FileName

:: Java
"%_sed%" -i -e "s@Java_@jPortable_@g" "%_bucket_dir%\Java.csv"
"%_sed%" -i -e "s@Java64_@jPortable64_@g" "%_bucket_dir%\Java64.csv"

:: JDK
"%_sed%" -i -e "s@JDK_@jdkPortable_@g" "%_bucket_dir%\JDK.csv"
"%_sed%" -i -e "s@JDK64_@jdkPortable64_@g" "%_bucket_dir%\JDK64.csv"

:: GPG
"%_sed%" -i -e "s@GPG_@GPG_Plugin_Portable_@g" "%_bucket_dir%\GPG.csv"

:: Ghostscript
"%_sed%" -i -e "s@Ghostscript_@GhostscriptPortable_@g" "%_bucket_dir%\Ghostscript.csv"

:: FreeCommanderPortable
"%_sed%" -i -E "s@(PackageUrl1.+)http.+FreeCommanderPortable/@\1https://freecommander.com/downloads/@g" "%_bucket_dir%\FreeCommanderPortable.csv"
"%_sed%" -i -e "s@downloading@redir2@g" ^
            -e "s@p=&@p=https://freecommander.com/downloads/\&@g" ^
            -e "s@n=FreeCommander XE Portable@@g" ^
            -e "s@d=pa@d=pb@g" ^
            "%_bucket_dir%\FreeCommanderPortable.csv"

:: BPBiblePortable
if "%_github_mirror%"=="false" (
  "%_sed%" -i -E "s@https://download.+BPBiblePortable_(.+)\.paf\.exe@https://github.com/bpbible/bpbible/releases/download/release-\1/BPBiblePortable_\1.paf.exe@g" "%_bucket_dir%\BPBiblePortable.csv"
) else (
  "%_sed%" -i -E "s@https://download.+BPBiblePortable_(.+)\.paf\.exe@%_github_mirror%/bpbible/bpbible/releases/download/release-\1/BPBiblePortable_\1.paf.exe@g" "%_bucket_dir%\BPBiblePortable.csv"
)
"%_sed%" -i -E "s@https://portableapps.+BPBiblePortable_(.+)\.paf\.exe@https://portableapps.com/redir2/?a=BPBiblePortable\&s=s\&p=https://github.com/bpbible/bpbible/releases/download/release-\1/\&d=pb\&f=BPBiblePortable_\1.paf.exe@g" "%_bucket_dir%\BPBiblePortable.csv"

:: // BUG It's a PortableApps.com's bug
"%_sed%" -i -e "s@\" VLC Media Player Portable \"@\"VLC Media Player Portable\"@g" ^
            -e "s@/ VLC Media Player Portable /@/VLC Media Player Portable/@g" ^
            "%_bucket_dir%\VLCPortable.csv"

:: Correct SpybotPortable's name
"%_sed%" -i -e "s@Search Destroy@Search \& Destroy@g" "%_bucket_dir%\SpybotPortable.csv"

:: // TODO some apps are only on portableapps.com, not on sourceforge.net
:: Remove wrong PackageUrl2

echo %Done%

:: Count apps
set _apps_count_tmp=0
for %%G in ("%_bucket_dir%\*.csv") do set /a _apps_count_tmp+=1 >nul
for /f "delims=" %%G in ('echo %_apps_count_tmp%') do set _apps_count=%%G
echo %Total of apps:% %_apps_count%
set "_apps_count_tmp="
endlocal
exit /b 0

:: Usage: 
::   - call :upgrade *
::   - call :upgrade <app>
:upgrade
setlocal enabledelayedexpansion
if [%~1]==[] (
  echo %Please input an app name.%
  exit /b 21
)
if [%~1]==[*] (
  for /f %%G in ('dir /b "%~d0\PortableApps" ^| findstr /c:Portable') do (
    call :_get_installed_app_info %%G
    call :install !_installed_app_appid!
  )
  for /f %%G in ('dir /b "%~d0\PortableApps\CommonFiles"') do (
    call :_get_installed_plugin_info %%G
    call :install !_installed_plugin_appid!
  )
) else (
  if not exist "%_bucket_dir%\%~1.csv" (
    echo %There is no this app:% %~1.
    exit /b 22
  )
  call :install %~1
  if not [%~2]==[] (
    shift /1
    call :upgrade %~1
  )
)
endlocal
exit /b 0