@echo off
SET PATH_RES="Debug.win32"
echo %PATH_RES%

REM LIST_DIRS=(../../../src )

xcopy %cd%\..\..\..\src %cd%\%PATH_RES%\src /S/E/I/Y

REM xcopy %cd%\..\..\..\res\Published-iOS %cd%\%PATH_RES% /S/E/I

REM xcopy %cd%\..\..\..\res\Maps %cd%\%PATH_RES% /S/E/I

SET COPY_FROM=%cd%\..\..\..\res\Published-iOS
SET CUR_DIR=%cd%

echo %COPY_FROM%
cd %COPY_FROM%

for /r . %%i in (*) do xcopy %%i %CUR_DIR%\%PATH_RES% /S/E/I/Y

cd %CUR_DIR%

SET COPY_FROM=%cd%\..\..\..\res\Maps
cd %COPY_FROM%
for /r . %%i in (*) do xcopy %%i %CUR_DIR%\%PATH_RES% /S/E/I/Y
cd %CUR_DIR%

REM xcopy %%i %cd%\%PATH_RES% /S/E/I