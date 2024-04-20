@echo off

if %1==[] (
	echo Please pass a format argument
	EXIT /B 1
)
echo Copying %1

SET ext=
if %1==VST2 SET ext=dll
if %1==CLAP SET ext=clap
echo Extension %ext%

SET dest=
if %1==VST2 SET dest="%PROGRAMFILES%\Steinberg\VstPlugins"
if %1==CLAP SET dest="%COMMONPROGRAMFILES%\CLAP"
echo Dest %dest%

echo Building...
zig build -Dformat=%1
if %errorlevel% neq 0 exit /b %errorlevel%
echo Copying...
copy /Y zig-out\lib\ZigVerb.dll %dest%\ZigVerb.%ext%
copy /Y zig-out\lib\ZigVerb.pdb %dest%\
