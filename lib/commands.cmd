setlocal

::Help
set "_command_is_help="
if "%~1" == "" set "_command_is_help=yes"
if "%~1" == "help" set "_command_is_help=yes"
if "%~1" == "--help" set "_command_is_help=yes"
if "%~1" == "-h" set "_command_is_help=yes"
if "%_command_is_help%" == "yes" (
  call "%~dp0help.cmd" || exit /b 1
  exit /b 0
)

if "%~1" == "cat" (
  call "%~dp0cat.cmd" %~2 || exit /b 1
  exit /b 0
)

if "%~1" == "checkup" (
  call "%~dp0checkup.cmd" || exit /b 1
  exit /b 0
)

if "%~1" == "clean" (
  call "%~dp0clean.cmd" || exit /b 1
  exit /b 0
)

if "%~1" == "download" (
  if "%~2" == "" call "%~dp0download.cmd" || exit /b 1
  :_download_loop
  if not "%~2" == "" (
    call "%~dp0download.cmd" %~2
    shift /1
    goto :_download_loop
  )
  exit /b 0
)

if "%~1" == "export" (
  call "%~dp0export.cmd" || exit /b 1
  exit /b 0
)

if "%~1" == "home" (
  call "%~dp0home.cmd" %~2 || exit /b 1
  exit /b 0
)

if "%~1" == "import" (
  call "%~dp0import.cmd" "%~2" || exit /b 1
  exit /b 0
)

if "%~1" == "info" (
  call "%~dp0info.cmd" %~2 || exit /b 1
  exit /b 0
)

if "%~1" == "install" (
  if "%~2" == "" call "%~dp0install.cmd" || exit /b 1
  :_install_loop
  if not "%~2" == "" (
    call "%~dp0install.cmd" %~2
    shift /1
    goto :_install_loop
  )
  exit /b 0
)

if "%~1" == "known" (
  call "%~dp0known.cmd" || exit /b 1
  exit /b 0
)

if "%~1" == "list" (
  call "%~dp0list.cmd" || exit /b 1
  exit /b 0
)

if "%~1" == "search" (
  call "%~dp0search.cmd" %~2 || exit /b 1
  exit /b 0
)

if "%~1" == "status" (
  call "%~dp0status.cmd" || exit /b 1
  exit /b 0
)

if "%~1" == "uninstall" (
  if "%~2" == "" call "%~dp0uninstall.cmd" || exit /b 1
  :_uninstall_loop
  if not "%~2" == "" (
    call "%~dp0uninstall.cmd" %~2
    shift /1
    goto :_uninstall_loop
  )
  exit /b 0
)

if "%~1" == "update" (
  call "%~dp0update.cmd" || exit /b 1
  exit /b 0
)

if "%~1" == "upgrade" (
  if "%~2" == "" call "%~dp0upgrade.cmd" || exit /b 1
  :_upgrade_loop
  if not "%~2" == "" (
    call "%~dp0upgrade.cmd" %~2
    shift /1
    goto :_upgrade_loop
  )
  exit /b 0
)
endlocal

:: // TODO Quit all opened apps
:: // TODO Backup, restore
:: // TODO Install specific version app
