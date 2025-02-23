@echo off

setlocal

REM this script is supposed to be in the same level as the source programs !
set INPUT_54_2=output\geb_drv_54_2.txt
set INPUT_54_1=output\geb_drv_54_1.txt

cd %~dp0

if "%~dp0"=="%CD%\" goto goon
	echo This bat file must run from inside its directory "%~dp0"!="%CD%"
        goto errorexit
:goon

echo ====================================================================
echo This script is a little helper to set the INPUTS of 
echo the pseudo device win_local.
echo The idea is to launch the semaphore program in debug mode 
echo (hardware launch, not in simulation) echo and use this script 
echo to toggle the inputs. 
echo You'd see the CHAnges in the IOVars view, in the Debug perspective
echo ====================================================================


:loop
echo Press '1' for toggling input %IX54.1 (SI=external sensor)
echo Press '2' for toggling input %IX54.2 (SE=internal sensor)
set /p pressedkey="Press other key for end this script "
if "%pressedkey%"=="1" goto toggle1
if "%pressedkey%"=="2" goto toggle2
goto bye

:toggle1
If NOT exist %INPUT_54_1% echo 0 > %INPUT_54_1%
set /p VAL=<%INPUT_54_1%
echo curVAL: "%VAL%"
if "%VAL:~0,1%"=="1" (
   echo toggling %INPUT_54_1% to FALSE
   echo 0 > %INPUT_54_1%
) else ( 
   echo toggling %INPUT_54_1% to TRUE
   echo 1 > %INPUT_54_1%
)
goto loop

:toggle2
If NOT exist %INPUT_54_2% echo 0 > %INPUT_54_2%
set /p VAL=<%INPUT_54_2%
echo curVAL: "%VAL%"
if "%VAL:~0,1%"=="1" (
   echo toggling %INPUT_54_2% to FALSE
   echo 0 > %INPUT_54_2%
) else ( 
   echo toggling %INPUT_54_2% to TRUE
   echo 1 > %INPUT_54_2%
)
goto loop


:bye
echo bye


