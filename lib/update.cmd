setlocal
call "%~dp0config.cmd" || exit /b 1

del /q "%_bucket_dir%\*" >nul || exit /b 1
del /q "%_cache_dir%\*" >nul || exit /b 1

:: Download apps index page
set /p "_updating_cache_tips=Updating apps cache ... " <nul
"%_aria2c%" https://portableapps.com/apps ^
  --dir="%_cache_dir%" ^
  --out=apps.html ^
  --quiet=true ^
  --conditional-get=true ^
  --allow-overwrite=true ^
  || (
    echo Download failed.
    exit /b 23
  )

:: List all apps' url
copy nul "%_cache_dir%\apps-url.txt" >nul || exit /b 1
for /f tokens^=2^ delims^=^" %%G in ('call "%_rg%" a\s+href^=\"/apps/.+\" --only-matching "%_cache_dir%\apps.html"') do (
  echo https://portableapps.com%%G>>"%_cache_dir%\apps-url.txt"
)

:: URL redirection
"%_sed%" -i -e "s|utilities/eraser_portable|security/eraser-portable|g" ^
            -e "s|utilities/eraserdrop_portable|security/eraserdrop-portable|g" ^
            -e "s|development/nvu_portable|development/kompozer-portable|g" ^
            "%_cache_dir%\apps-url.txt" ^
  || exit /b 1

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
            "%_cache_dir%\apps-url.txt" ^
  || exit /b 1

:: Extra apps not on apps.html page
(
  echo https://portableapps.com/apps/development/nsis_portable
  echo https://portableapps.com/apps/development/nsis_portable_ansi
  echo https://portableapps.com/apps/development/nsis_portable_unicode
  echo https://portableapps.com/apps/graphics_pictures/freecad-portable
  echo https://portableapps.com/apps/graphics_pictures/freecad-portable-legacy-x86
  echo https://portableapps.com/apps/graphics_pictures/xnview_portable
  echo https://portableapps.com/apps/graphics_pictures/xnview-mp-portable
  echo https://portableapps.com/apps/internet/firefox_portable
  echo https://portableapps.com/apps/internet/firefox_portable/legacy
  echo https://portableapps.com/apps/internet/firefox_portable/test
  echo https://portableapps.com/apps/internet/firefox-portable-esr
  echo https://portableapps.com/apps/internet/firefox-portable-nightly
  echo https://portableapps.com/apps/internet/google_chrome_portable
  echo https://portableapps.com/apps/internet/google-chrome-portable-64
  echo https://portableapps.com/apps/internet/google-chrome-portable-beta
  echo https://portableapps.com/apps/internet/google-chrome-portable-dev
  echo https://portableapps.com/apps/internet/opera_portable
  echo https://portableapps.com/apps/internet/opera-gx-portable
  echo https://portableapps.com/apps/internet/opera-portable-legacy-12
  echo https://portableapps.com/apps/internet/opera-portable-legacy-36
  echo https://portableapps.com/apps/internet/thunderbird_portable
  echo https://portableapps.com/apps/internet/thunderbird_portable/test
  echo https://portableapps.com/apps/internet/thunderbird-portable-legacy-102
  echo https://portableapps.com/apps/internet/thunderbird-portable-legacy-52
  echo https://portableapps.com/apps/internet/thunderbird-portable-legacy-68
  echo https://portableapps.com/apps/internet/thunderbird-portable-legacy-91
  echo https://portableapps.com/apps/music_video/musescore_portable
  echo https://portableapps.com/apps/music_video/musescore-portable-legacy-3
  echo https://portableapps.com/apps/office/abiword_portable
  echo https://portableapps.com/apps/office/abiword-portable-test
  echo https://portableapps.com/apps/office/libreoffice_portable
  echo https://portableapps.com/apps/office/libreoffice-portable-legacy-5.4
  echo https://portableapps.com/apps/office/libreoffice-portable-still
  echo https://portableapps.com/apps/security/eraser-dot-net-portable
  echo https://portableapps.com/apps/security/eraser-portable
  echo https://portableapps.com/apps/utilities/colour-contrast-analyser-classic-portable
  echo https://portableapps.com/apps/utilities/java_portable
  echo https://portableapps.com/apps/utilities/java_portable_64
  echo https://portableapps.com/apps/utilities/jdkportable
  echo https://portableapps.com/apps/utilities/jdkportable64
  echo https://portableapps.com/apps/utilities/keepass_portable
  echo https://portableapps.com/apps/utilities/keepass-pro-portable
  echo https://portableapps.com/apps/utilities/OpenJDK
  echo https://portableapps.com/apps/utilities/OpenJDK64
  echo https://portableapps.com/apps/utilities/winmerge-2011-portable
  echo https://portableapps.com/apps/utilities/yumi-portable
  echo https://portableapps.com/apps/utilities/yumi-uefi-portable
)>>"%_cache_dir%\apps-url.txt" || exit /b 1

:: Remove duplicated lines
copy "%_cache_dir%\apps-url.txt" "%_cache_dir%\apps-url-1.txt" >nul || exit /b 1
copy nul "%_cache_dir%\apps-url.txt" >nul || exit /b 1
for /f "delims=" %%G in ('type "%_cache_dir%\apps-url-1.txt"') do (
  findstr /c:"%%G" "%_cache_dir%\apps-url.txt" >nul ^
    || echo %%G>>"%_cache_dir%\apps-url.txt"
)

:: Download all apps' pages
"%_aria2c%" --input-file="%_cache_dir%\apps-url.txt" ^
  --dir="%_cache_dir%" ^
  --quiet=true ^
  --conditional-get=true ^
  --allow-overwrite=false ^
  --max-concurrent-downloads=%_config.aria2-max-concurrent-downloads% ^
  && echo Done ^
  || (
    echo Download failed.
    exit /b 23
  )

set /p "_updating_bucket_tips=Updating bucket ... " <nul
:: Get an app's meta info from its app page
copy nul "%_cache_dir%\apps-parameters.txt" >nul || exit /b 1
for /f tokens^=1^ delims^=^" %%G in ('call "%_rg%" "antivirus\?(.+).+Antivirus.+" --only-matching --replace $1 --no-filename "%_cache_dir%"') do (
  echo %%G>>"%_cache_dir%\apps-parameters.txt"
)

:: Replace some special characters.
:: &amp; -> &
:: &#39; -> '
:: %%2B -> +
:: %%20 -> (space)
:: ^ -> -
:: & -> nul
"%_sed%" -i -e "s@amp;@@g" ^
            -e "s@&#39;@'@g" ^
            -e "s@%%2B@+@g" ^
            -e "s@%%20@ @g" ^
            -e "s@\^@-@g" ^
            -e "s@Search & Destroy@Search Destroy@g" ^
            "%_cache_dir%\apps-parameters.txt" ^
  || exit /b 1

for /f "tokens=2,4,6,8,10 delims=^&=" %%O in ('type "%_cache_dir%\apps-parameters.txt"') do (
  (
    echo "Name","%%O"
    echo "AppID","%%P"
    echo "Version","%%Q"
    echo "FileName","%%R"
    echo "Hash","%%S"
    echo "PackageUrl1","https://download2.portableapps.com/portableapps/%%P/%%R"
    echo "RefererUrl1","https://portableapps.com/downloading/?a=%%P&s=s&p=&d=pa&n=%%O&f=%%R"
    echo "PackageUrl2","https://sourceforge.net/projects/portableapps/files/%%O/%%R/download"
  )>>"%_bucket_dir%\%%P.csv" || exit /b 1
)

:: Write homepage to app manifest
for /f "tokens=3-5 delims=/" %%G in ('type "%_cache_dir%\apps-url.txt"') do (
  for /f "tokens=1 delims=^&" %%O in ('call "%_rg%" ";a=(.+)&amp;v=" --only-matching --replace $1 "%_cache_dir%\%%I" ^| "%_sed%" "s@%%2B@+@g"') do (
    echo "Homepage","https://portableapps.com/%%G/%%H/%%I">>"%_bucket_dir%\%%O.csv" || exit /b 1
  )
)

:: Add XonoticPortable and SauerbratenPortable csv in bucket dir. They don't
:: have antivirus link because their packages size are huge.

:: XonoticPortable.csv
for /f "tokens=2,9,11 delims=^&=" %%O in ('call "%_rg%" "/\?a=.+\.paf\.exe" --only-matching "%_cache_dir%\xonotic-portable"') do (
  (
    echo "Name","%%P"
    echo "AppID","%%O"
    echo "FileName","%%Q"
    echo "PackageUrl1","https://download2.portableapps.com/portableapps/%%O/%%Q"
  )>>"%_bucket_dir%\XonoticPortable.csv" || exit /b 1
)
for /f "tokens=* delims=" %%O in ('call "%_rg%" "Version\s(.+)\sfor\sWindows" --only-matching --replace $1 "%_cache_dir%\xonotic-portable"') do (
  echo "Version","%%O">>"%_bucket_dir%\XonoticPortable.csv" || exit /b 1
)
for /f "tokens=* delims=" %%O in ('call "%_rg%" "Hash.+:\s(.+)</li>" --only-matching --replace $1 "%_cache_dir%\xonotic-portable"') do (
  echo "Hash","%%O">>"%_bucket_dir%\XonoticPortable.csv" || exit /b 1
)
for /f "tokens=* delims=" %%O in ('call "%_rg%" "/downloading/\?a=.+\.paf\.exe" --only-matching "%_cache_dir%\xonotic-portable"') do (
  echo "RefererUrl1","https://portableapps.com%%O">>"%_bucket_dir%\XonoticPortable.csv" || exit /b 1
)
for /f "tokens=* delims=" %%O in ('call "%_rg%" "canonical.+href.+(http.+portable)" --only-matching --replace $1 "%_cache_dir%\xonotic-portable"') do (
  echo "Homepage","%%O">>"%_bucket_dir%\XonoticPortable.csv" || exit /b 1
)

:: SauerbratenPortable.csv
for /f "tokens=2,9 delims=^&=" %%O in ('call "%_rg%" "/\?a=.+\.paf\.exe" --only-matching "%_cache_dir%\sauerbraten_portable"') do (
  (
    echo "Name","Sauerbraten Portable"
    echo "AppID","%%O"
    echo "FileName","%%P"
    echo "PackageUrl2","https://sourceforge.net/projects/portableapps/files/Sauerbraten Portable/%%P/download?use_mirror={%_sourceforge_mirror_list%}"
  )>>"%_bucket_dir%\SauerbratenPortable.csv" || exit /b 1
)
for /f "tokens=* delims=" %%O in ('call "%_rg%" "Version\s(.+)\sfor\sWindows" --only-matching --replace $1 "%_cache_dir%\sauerbraten_portable"') do (
  echo "Version","%%O">>"%_bucket_dir%\SauerbratenPortable.csv" || exit /b 1
)
for /f "tokens=* delims=" %%O in ('call "%_rg%" "Hash.+:\s(.+)</li>" --only-matching --replace $1 "%_cache_dir%\sauerbraten_portable"') do (
  echo "Hash","%%O">>"%_bucket_dir%\SauerbratenPortable.csv" || exit /b 1
)
for /f "tokens=* delims=" %%O in ('call "%_rg%" "canonical.+href.+(http.+portable)" --only-matching --replace $1 "%_cache_dir%\sauerbraten_portable"') do (
  echo "Homepage","%%O">>"%_bucket_dir%\SauerbratenPortable.csv" || exit /b 1
)

:: // BUG Delete these apps' PackageUrl1 and RefererUrl1, because they are 404 not
:: found. It's a PortableApps.com's bug.

:: SMPlayer
"%_sed%" -i -e "/PackageUrl1/d" ^
            -e "/RefererUrl1/d" ^
            "%_bucket_dir%\SMPlayerPortable.csv" ^
  || exit /b 1

:: EmsisoftEmergencyKitPortable
"%_sed%" -i -e "/PackageUrl1/d" ^
            -e "/RefererUrl1/d" ^
            "%_bucket_dir%\EmsisoftEmergencyKitPortable.csv" ^
  || exit /b 1

:: Correct some apps' FileName

:: Java
"%_sed%" -i -e "s@Java_@jPortable_@g" "%_bucket_dir%\Java.csv" ^
  || exit /b 1
"%_sed%" -i -e "s@Java64_@jPortable64_@g" "%_bucket_dir%\Java64.csv" ^
  || exit /b 1

:: JDK
"%_sed%" -i -e "s@JDK_@jdkPortable_@g" "%_bucket_dir%\JDK.csv" ^
  || exit /b 1
"%_sed%" -i -e "s@JDK64_@jdkPortable64_@g" "%_bucket_dir%\JDK64.csv" ^
  || exit /b 1

:: GPG
"%_sed%" -i -e "s@GPG_@GPG_Plugin_Portable_@g" "%_bucket_dir%\GPG.csv" ^
  || exit /b 1

:: Ghostscript
"%_sed%" -i -e "s@Ghostscript_@GhostscriptPortable_@g" "%_bucket_dir%\Ghostscript.csv" ^
  || exit /b 1

:: FreeCommanderPortable
"%_sed%" -i -E "s@(PackageUrl1.+)http.+FreeCommanderPortable/@\1https://freecommander.com/downloads/@g" "%_bucket_dir%\FreeCommanderPortable.csv" ^
  || exit /b 1
"%_sed%" -i -e "s@downloading@redir2@g" ^
            -e "s@p=&@p=https://freecommander.com/downloads/\&@g" ^
            -e "s@n=FreeCommander XE Portable@@g" ^
            -e "s@d=pa@d=pb@g" ^
            "%_bucket_dir%\FreeCommanderPortable.csv" ^
  || exit /b 1

:: BPBiblePortable
if "%_config.github-mirror%" == "false" (
  "%_sed%" -i -E "s@https://download.+BPBiblePortable_(.+)\.paf\.exe@https://github.com/bpbible/bpbible/releases/download/release-\1/BPBiblePortable_\1.paf.exe@g" "%_bucket_dir%\BPBiblePortable.csv" ^
  || exit /b 1
) else (
  "%_sed%" -i -E "s@https://download.+BPBiblePortable_(.+)\.paf\.exe@%_config.github-mirror%/bpbible/bpbible/releases/download/release-\1/BPBiblePortable_\1.paf.exe@g" "%_bucket_dir%\BPBiblePortable.csv" ^
  || exit /b 1
)
"%_sed%" -i -E "s@https://portableapps.+BPBiblePortable_(.+)\.paf\.exe@https://portableapps.com/redir2/?a=BPBiblePortable\&s=s\&p=https://github.com/bpbible/bpbible/releases/download/release-\1/\&d=pb\&f=BPBiblePortable_\1.paf.exe@g" "%_bucket_dir%\BPBiblePortable.csv" ^
  || exit /b 1

:: // BUG It's a PortableApps.com's bug
"%_sed%" -i -e "s@\" VLC Media Player Portable \"@\"VLC Media Player Portable\"@g" ^
            -e "s@/ VLC Media Player Portable /@/VLC Media Player Portable/@g" ^
            "%_bucket_dir%\VLCPortable.csv" ^
  || exit /b 1

:: Correct SpybotPortable's name
"%_sed%" -i -e "s@Search Destroy@Search \& Destroy@g" "%_bucket_dir%\SpybotPortable.csv" ^
  || exit /b 1

:: // TODO Remove wrong PackageUrl2

echo Done

:: Count apps
set _apps_count_tmp=0
for %%G in ("%_bucket_dir%\*.csv") do set /a _apps_count_tmp+=1 >nul
for /f "delims=" %%G in ('echo %_apps_count_tmp%') do set _apps_count=%%G
echo Total of apps: %_apps_count%
set "_apps_count_tmp="
endlocal
