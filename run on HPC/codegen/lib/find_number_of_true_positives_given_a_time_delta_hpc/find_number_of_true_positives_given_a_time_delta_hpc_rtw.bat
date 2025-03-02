@echo off

set skipSetupArg=%2
if "%skipSetupArg%" NEQ "skip_setup_msvc" (
call "setup_msvc.bat"
)

cd .

if "%1"=="" (nmake  -f find_number_of_true_positives_given_a_time_delta_hpc_rtw.mk all) else (nmake  -f find_number_of_true_positives_given_a_time_delta_hpc_rtw.mk %1)
@if errorlevel 1 goto error_exit

exit /B 0

:error_exit
echo The make command returned an error of %errorlevel%
exit /B 1