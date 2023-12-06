setlocal

if exist "%~dp0..\VERSION" (
  for /f %%G in ('type "%~dp0..\VERSION"') do set "_version=%%G"
)

echo paf %_version%
echo A command-line installer for PortableApps.
echo Project home page: https://github.com/duzyn/paf
echo:
echo USAGE:
echo     paf COMMAND [ARGS]
echo:
echo ARGS:
echo     AppID
echo         AppID is defined in PortableApps.com Format, reference:
echo         https://portableapps.com/development/portableapps.com_format#appinfo
echo     *
echo         When upgrading apps, * means all.
echo:
echo COMMANDS:
echo     cat
echo         Show content of specified app manifest.
echo             paf cat FirefoxPortable
echo     checkup
echo         Check for dependencies.
echo             paf checkup
echo     clean
echo         Clean the download cache.
echo             paf clean
echo     download
echo         Download apps in the downloads folder and verify hashes.
echo             paf download FirefoxPortable
echo             paf download FirefoxPortable GoogleChromePortable
echo     export
echo         Exports installed apps in CSV format.
echo             paf export
echo     help
echo         Show this help.
echo             paf
echo             paf help
echo             paf --help
echo             paf -h
echo     home
echo         Opens the app homepage.
echo             paf home FirefoxPortable
echo     import
echo         Imports apps from a text file.
echo             paf import apps.csv
echo     info
echo         Display information about an app.
echo             paf info FirefoxPortable
echo     install
echo         Install an app.
echo             paf install FirefoxPortable
echo             paf install FirefoxPortable GoogleChromePortable
echo     known
echo         List all known apps.
echo             paf known
echo     list
echo         List installed apps.
echo             paf list
echo     search
echo         Search available apps.
echo             paf search firefox
echo     status
echo         Show status and check for new app versions.
echo             paf status
echo     uninstall
echo         Uninstall an app.
echo             paf uninstall FirefoxPortable
echo             paf uninstall FirefoxPortable GoogleChromePortable
echo     update
echo         Update cache.
echo             paf update
echo     upgrade
echo         Update an app.
echo             paf upgrade FirefoxPortable
echo             paf upgrade FirefoxPortable GoogleChromePortable
echo             paf upgrade *
endlocal
