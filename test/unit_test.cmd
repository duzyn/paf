@echo off
chcp 65001
cd "%~dp0"
setlocal
set "_sourceforge_mirror_list=cfhcable,cytranet,deac-ams,deac-fra,deac-riga,excellmedia,freefr,gigenet,ixpeering,jaist,kumisystems,liquidtelecom,nav,nchc,netcologne,netix,newcontinuum,onboardcloud,phoenixnap,razaoinfo,sinalbr,sitsa,tenet,udomain,ufpr,unlimited,versaweb,webwerks,yer,zenlayer"

call :unit_test "..\paf"
call :unit_test "..\paf help"
call :unit_test "..\paf help cat"
call :unit_test "..\paf help checkup"
call :unit_test "..\paf help clean"
call :unit_test "..\paf help download"
call :unit_test "..\paf help export"
call :unit_test "..\paf help help"
call :unit_test "..\paf help home"
call :unit_test "..\paf help import"
call :unit_test "..\paf help info"
call :unit_test "..\paf help install"
call :unit_test "..\paf help known"
call :unit_test "..\paf help list"
call :unit_test "..\paf help search"
call :unit_test "..\paf help status"
call :unit_test "..\paf help uninstall"
call :unit_test "..\paf help update"
call :unit_test "..\paf help upgrade"

:: checkup
move ..\bin\aria2c.exe ..\bin\aria2c.exe.1
move ..\bin\rg.exe ..\bin\rg.exe.1
move ..\bin\sed.exe ..\bin\sed.exe.1
call :unit_test "..\paf checkup"

move ..\bin\aria2c.exe.1 ..\bin\aria2c.exe
move ..\bin\rg.exe.1 ..\bin\rg.exe
move ..\bin\sed.exe.1 ..\bin\sed.exe
call :unit_test "..\paf checkup"

@REM call :unit_test "..\paf update"
call :unit_test "..\paf known"

:: search
call :unit_test "..\paf search"
call :unit_test "..\paf search scoop"
call :unit_test "..\paf search scoop homebrew"
call :unit_test "..\paf search notepad3"
call :unit_test "..\paf search firefox"
call :unit_test "..\paf search notepad"

:: info
call :unit_test "..\paf info"
call :unit_test "..\paf info scoop"
call :unit_test "..\paf info scoop homebrew"
call :unit_test "..\paf info notepad3"
call :unit_test "..\paf info FirefoxPortable"
call :unit_test "..\paf info Notepad2Portable"

:: cat
call :unit_test "..\paf cat"
call :unit_test "..\paf cat scoop"
call :unit_test "..\paf cat scoop homebrew"
call :unit_test "..\paf cat notepad3"
call :unit_test "..\paf cat FirefoxPortable"
call :unit_test "..\paf cat Notepad2Portable"

:: home
call :unit_test "..\paf home"
call :unit_test "..\paf home scoop"
call :unit_test "..\paf home scoop homebrew"
call :unit_test "..\paf home notepad3"
call :unit_test "..\paf home FirefoxPortable"
call :unit_test "..\paf home Notepad2Portable"


..\bin\aria2c.exe "https://sourceforge.net/projects/portableapps/files/Notepad2 Portable/Notepad2Portable_4.2.25_English.paf.exe/download?use_mirror={%_sourceforge_mirror_list%}" ^
  -d .\ -o Notepad2Portable_4.2.25_English.paf.exe --parameterized-uri=true --continue=true --console-log-level=error -j 40
..\bin\aria2c.exe "https://sourceforge.net/projects/portableapps/files/Ventoy Portable/VentoyPortable_1.0.95.paf.exe/download?use_mirror={%_sourceforge_mirror_list%}" ^
  -d .\ -o VentoyPortable_1.0.95.paf.exe --parameterized-uri=true --continue=true --console-log-level=error -j 40
call .\Notepad2Portable_4.2.25_English.paf.exe
call .\VentoyPortable_1.0.95.paf.exe

:: download
call :unit_test "..\paf download"
call :unit_test "..\paf download scoop"
call :unit_test "..\paf download scoop homebrew"
call :unit_test "..\paf download notepad3"
call :unit_test "..\paf download Notepad2-modPortable"
call :unit_test "..\paf download NotepadPortable VentoyPortable"

:: install
call :unit_test "..\paf install"
call :unit_test "..\paf install scoop"
call :unit_test "..\paf install scoop homebrew"
call :unit_test "..\paf install notepad3"
call :unit_test "..\paf install Notepad2-modPortable"
call :unit_test "..\paf install 7-ZipPortable AutorunsPortable"

:: upgrade
call :unit_test "..\paf upgrade"
call :unit_test "..\paf upgrade scoop"
call :unit_test "..\paf upgrade scoop homebrew"
call :unit_test "..\paf upgrade notepad3"
call :unit_test "..\paf upgrade Notepad2Portable"
call :unit_test "..\paf upgrade Notepad2Portable VentoyPortable"
call :unit_test "..\paf upgrade *"

:: uninstall
call :unit_test "..\paf uninstall"
call :unit_test "..\paf uninstall scoop"
call :unit_test "..\paf uninstall scoop homebrew"
call :unit_test "..\paf uninstall notepad3"
call :unit_test "..\paf uninstall Notepad2-modPortable"
call :unit_test "..\paf uninstall Notepad2Portable 7-ZipPortable AutorunsPortable"

call :unit_test "..\paf list"
call :unit_test "..\paf status"
call :unit_test "..\paf export"
call :unit_test "..\paf export >.\paf.csv"

echo "Notepad2Portable","4.2.25">>.\paf.csv"
echo "Notepad2-modPortable","4.2.25.998">>.\paf.csv"
call :unit_test "..\paf import"
call :unit_test "..\paf import .\paf.csv"

@REM call :unit_test "..\paf clean"

endlocal
goto :eof

:: Usage unit_test <command>
:unit_test
setlocal
echo:
echo ----------------------------------------------------------------------
echo:
echo UNIT TEST: %~1
echo OUTPUT:
call %~1
echo:
echo ----------------------------------------------------------------------
echo:
exit /b 0

