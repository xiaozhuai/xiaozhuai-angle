@echo off
cd /d %~dp0

call "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat"

@REM dumpbin /EXPORTS lib\windows-x64\libEGL.dll > libEGL.exports
lib /MACHINE:x64 /def:libEGL.def /out:lib\windows-x64\libEGL.lib
del lib\windows-x64\libEGL.exp

@REM dumpbin /EXPORTS lib\windows-x64\libGLESv2.dll > libGLESv2.exports
lib /MACHINE:x64 /def:libGLESv2.def /out:lib\windows-x64\libGLESv2.lib
del lib\windows-x64\libGLESv2.exp

pause
