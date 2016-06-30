cls
@echo off
@SETLOCAL enableextensions disabledelayedexpansion
echo.
echo ******************************************************************************
echo *       Select file size                                                     *
echo *         0. 100mb                                                           *
echo *         1. 5gb                                                             *
echo *                                                                            *
echo *                                                                            *
echo *                                                              by hprombex   *
echo ******************************************************************************
echo.

SET "setupRESULT="
SET /P setupRESULT=CHOOSE YOUR VARIANT [0-1]: 
IF "%setupRESULT%"=="0" GOTO 100mb_size
IF "%setupRESULT%"=="1" GOTO 5gb_size
echo                          "%setupRESULT%" Wrong value, Please try again.
ping 127.0.0.1 -n 2 | echo off


:5gb_size
SET file_Size=5gb.bin
SET file_Size_number=5368709120
SET /A loopCOUNTER_numer=200
if exist %file_Size% (
    GOTO STEP_1
) else (
	fsutil file createnew %file_Size% %file_Size_number%
	GOTO STEP_1
)


:100mb_size
SET file_Size=100mb.bin
SET file_Size_number=104857600
SET /A loopCOUNTER_numer=2000
if exist %file_Size% (
    GOTO STEP_1
) else (
	fsutil file createnew %file_Size% %file_Size_number%
	GOTO STEP_1
)


:STEP_1
SET /A loopCOUNTER=0

IF "%time:~0,1%"==" " (
    SET timeLog=%date:~-4,4%%date:~-10,2%%date:~-7,2%.0%time:~1,1%%time:~3,2%%time:~6,2%
) ELSE (
    set timeLog=%date:~-4,4%%date:~-10,2%%date:~-7,2%.%time:~0,2%%time:~3,2%%time:~6,2%
)

:TRANSFER_LOOP
set timeIteration=%date:~-4,4%%date:~-10,2%%date:~-7,2%.%time:~0,2%%time:~3,2%%time:~6,2%
SET /A loopCOUNTER+=1

::WRITE

echo.
echo Transfer start, iteration %loopCOUNTER%!
echo.
timeout /t 3 /nobreak > nul
.\adb.exe push %file_Size% /sdcard/
if errorlevel 1 (
echo.
echo Transfer write error
echo %timeIteration% - %loopCOUNTER% iteration, WRITE transfer ERROR >> ./LOGS/log_%file_Size%_%timeLog%.log
GOTO SCAN
echo.
) ELSE (
echo Transfer write end
echo.
echo %timeIteration% - %loopCOUNTER% iteration, WRITE file transfer completed >> ./LOGS/log_%file_Size%_%timeLog%.log
)

::READ

.\adb.exe pull /sdcard/%file_Size% \%file_Size%
if errorlevel 1 (
echo.
echo Transfer read error
echo %timeIteration% - %loopCOUNTER% iteration, READ file transfer ERROR >> ./LOGS/log_%file_Size%_%timeLog%.log
GOTO SCAN
echo.
) ELSE (
echo Transfer read end
echo.
echo %timeIteration% - %loopCOUNTER% iteration, READ file transfer completed >> ./LOGS/log_%file_Size%_%timeLog%.log
)

del /f "C:\%file_Size%"


:SCAN
IF "%loopCOUNTER%" == "%loopCOUNTER_numer%" (
  GOTO TRANSFER_END
) ELSE (
  GOTO TRANSFER_LOOP
)

:TRANSFER_END
echo.
echo DONE %loopCOUNTER% iteration.
echo.