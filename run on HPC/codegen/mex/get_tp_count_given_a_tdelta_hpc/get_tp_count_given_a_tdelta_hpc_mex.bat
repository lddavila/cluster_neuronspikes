@echo off
call setEnv.bat
"D:\MATLABR2024b\toolbox\shared\coder\ninja\win64\ninja.exe" -t compdb cc cxx cudac > compile_commands.json
"D:\MATLABR2024b\toolbox\shared\coder\ninja\win64\ninja.exe" -v %*
