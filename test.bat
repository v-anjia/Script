@echo off
set s=/data/carservice
set t=%s%
:loop
for /F "tokens=1* delims=," %%a in ("%t%") do (
   echo %%a
   set t=%%b
   for /F %%i in ('adb shell "if [ -d %%a ];then echo 0; else echo 1;fi"') do (set output_result=%%i)
   if %output_result% == 0 (adb pull %%a     %pan_path%%date_time%) else (echo %%a not exist,so ignore this step)
   )
if defined t goto :loop