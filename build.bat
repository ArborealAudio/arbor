@echo off

if %1==[] (
	echo Please pass example target
	EXIT /B 1
)
echo Building %1

SET ext=clap
echo Extension %ext%

SET dest="%COMMONPROGRAMFILES%\CLAP"
echo Dest %dest%

echo Building...
zig build -Dexample=%1 -Dtarget=x86_64-windows-msvc
if %errorlevel% neq 0 exit /b %errorlevel%
echo Copying...
copy /Y zig-out\lib\Distortion.dll %dest%\Distortion.%ext%
copy /Y zig-out\lib\Distortion.pdb %dest%\
