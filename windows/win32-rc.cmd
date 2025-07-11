@if "%_echo%"=="" echo off
REM win32-rc.cmd: environment settings to be used with every Win32 command prompt
REM hooked into: "HKCU\Software\Microsoft\Command Processor" @AutoRun
REM autorun hook is set from bootstrap.cmd

REM only run once
if defined MY_BIN goto :eof

set _HERE=%~dp0
set HERE=%_HERE:~0,-1%
set _HERE=

set HOME=%USERPROFILE%
set MY_BIN=%HOME%\bin

call :addToPath "%USERPROFILE%\.dotfiles\bin-windows"
call :addToPath "%MY_BIN%\vim\vim74"
call :addToPath "%ProgramFiles%\7-Zip"

PATH=%PATH%;

:setEnv
set LESS=-i -M -N -q -x4
set LESSBINFMT=*d[%02x]

set VISUAL=neovide.exe
:: interacts badly with SD and windiff -lo
::set PAGER=vim.exe -R

call :loadDoskeyIfExists %HOME%\.dotfiles\windows\aliases.doskey

REM set prompt
prompt %USERNAME%@%COMPUTERNAME% [$+$P] $_$$$S
goto :eof

:loadDoskeyIfExists
    :: param1 path to doskey macro file
    if exist "%1" call doskey.exe /macrofile="%1"
    exit /b 0

:addToPath
    :: param1 path to add if it exists
    if exist "%~f1" PATH=%PATH%;%~f1
    exit /b 0

:eof
set HERE=
