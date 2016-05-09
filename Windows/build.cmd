 @echo off
setlocal enabledelayedexpansion

rem download Wix Toolset from https://wix.codeplex.com/releases/view/617257

set PATH="C:\Program Files (x86)\WiX Toolset v3.10\bin";%PATH%
set VIXTOOLSET="C:\Program Files (x86)\WiX Toolset v3.10"

rem Usage:
rem ------
rem build 			VSYEAR POCO_BASE
rem VSYEAR			:  VS2008 | VS2010 | VS2012 | VS2013 | VS2015
rem POCO_BASE       : the usual POCO_BASE absolute directory

:parse
rem VSYEAR			:  VS2008 | VS2010 | VS2012 | VS2013 | VS2015
if "%1"=="" goto usage
set VSYEAR=%1
if not "%VSYEAR%"=="VS2008" (
if not "%VSYEAR%"=="VS2010" (
if not "%VSYEAR%"=="VS2012" (
if not "%VSYEAR%"=="VS2013" (
if not "%VSYEAR%"=="VS2015" goto usage))))

if "%2"=="" goto usage
rem set REL_PATH=..\..\..\
rem set ABS_PATH=
rem pushd %REL_PATH%
rem set ABS_PATH=%CD%
rem popd
rem set POCO_BASE=%ABS_PATH%
set POCO_BASE=%2

for /f %%i in (%POCO_BASE%\VERSION) do set POCO_VERSION=%%i


rem PLATFORM [Win32|x64|WinCE|WEC2013]
set PLATFORM=%4
if "%PLATFORM%"=="" (set PLATFORM=Win32)
if not "%PLATFORM%"=="Win32" (
if not "%PLATFORM%"=="x64" (
if not "%PLATFORM%"=="WinCE" (
if not "%PLATFORM%"=="WEC2013" goto usage)))


set PATH=%POCO_BASE%\bin64;%POCO_BASE%\bin;%PATH%

rem 
rem  VSYEAR		= { VS2009 | VS2010 | VS2012 | VS2013 | VS2015 }
 
rem
rem  %VSYEAR%/Poco %POCO_VERSION% (x86).msi from %POCO_BASE%
rem
echo.
echo.
echo Building %VSYEAR%/Poco %POCO_VERSION% (x86).msi from %POCO_BASE%
echo -------------------------------------------------------------------
Candle.exe -arch x86 -dVSYEAR=%VSYEAR% -dVERSION=%POCO_VERSION% -dPOCO=%POCO_BASE% -dPlatform=x86 -out "%VSYEAR%/Poco %POCO_VERSION% (x86).wixobj" -ext %VIXTOOLSET%\bin\WixUIExtension.dll Poco-%POCO_VERSION%.wxs
Light.exe  -out "%VSYEAR%/Poco %POCO_VERSION% (x86).msi" -cultures:null -ext %VIXTOOLSET%\bin\WixUIExtension.dll "%VSYEAR%/Poco %POCO_VERSION% (x86).wixobj" 


rem
rem  %VSYEAR%/Poco %POCO_VERSION% (x64).msi from %POCO_BASE%
rem
echo.
echo.
echo Building %VSYEAR%/Poco %POCO_VERSION% (x64).msi from %POCO_BASE%
echo -------------------------------------------------------------------
Candle.exe  -arch x64 -dVSYEAR=%VSYEAR% -dVERSION=%POCO_VERSION% -dPOCO=%POCO_BASE% -dPlatform=x64 -out "%VSYEAR%/Poco %POCO_VERSION% (x64).wixobj" -ext %VIXTOOLSET%\bin\WixUIExtension.dll Poco-%POCO_VERSION%.wxs
Light.exe   -out "%VSYEAR%/Poco %POCO_VERSION% (x64).msi" -cultures:null -ext %VIXTOOLSET%\bin\WixUIExtension.dll "%VSYEAR%/Poco %POCO_VERSION% (x64).wixobj"

goto :end
 
:usage
echo "build <VSYEAR> <POCO_BASE>"
echo "VSYEAR          : { VS2008 | VS2010 | VS2012 | VS2013 | VS2015 }"
echo "POCO_BASE       : the usual POCO_BASE absolute directory

:end
endlocal
