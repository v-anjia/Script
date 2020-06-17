@echo off
echo *********************************************
echo **************  -- Begain -- ***************
echo *********************************************
echo Wait Devices

adb wait-for-device
set pan_path=%~dp0Pull_Log\
set date_time=%date:~0,4%-%date:~5,2%-%date:~8,2%_%time:~1,1%%time:~3,2%%time:~6,2%
echo %date_time%

echo Location of all files is: %pan_path%%date_time%
if exist %pan_path%%date_time% (echo %pan_path%%date_time% has exist) else (md %pan_path%%date_time%)

start "collect logcat" cmd /c "adb shell logcat > %pan_path%%date_time%\logcat.log"
rem start "collect logcat" adb logcat > %pan_path%%date_time%\logcat.log
echo Begain catching the logcat
echo After the operation, press space to catch more
pause
adb root
adb wait-for-device
echo start pull file
set s=/data/carservice,/sdcard/lvlog,/data/system/dropbox,/data/anr,/data/data/com.living.secureservice/files/lvlog/,/data/tombstones,/sdcard/faceid
set t=%s%
:loop
for /F "tokens=1* delims=," %%a in ("%t%") do (
   echo %%a
   set t=%%b
   for /F %%i in ('adb shell "if [ -d %%a ] || [ -f %%a ] ;then echo 0; else echo 1;fi"') do (
   if %%i == 0 (adb pull %%a     %pan_path%%date_time%) else (echo %%a not exist,so ignore this step))  
   )
if defined t goto loop

adb shell "[ -d /sdcard/Pictures/ ] || mkdir -p /sdcard/Pictures/"   
adb shell "getprop | grep ro.headunit.version" > %pan_path%%date_time%\Version.txt
adb shell dmesg -c > %pan_path%%date_time%\dmesg.log
adb shell "screencap -p /sdcard/Pictures/screencap.png"
adb pull /sdcard/Pictures/screencap.png  %pan_path%%date_time%  
adb shell "rm -r /sdcard/Pictures/"
pause

echo kill logcat progress
for /F "tokens=2 " %%a in ('tasklist /fi "Windowtitle eq collect logcat" /nh') do ( taskkill /f /pid %%a )
adb shell sleep 2
for /F "tokens=2 " %%a in ('tasklist /fi "Windowtitle eq collect logcat" /nh') do ( taskkill /f /pid %%a )
echo *********************************************
echo **************   -- Done --   ***************
echo *********************************************
pause