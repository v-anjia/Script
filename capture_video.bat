@echo off
set /p a=how much times?
echo %a%
for /l %%i in (1,1,%a%) do (
adb wait-for-device
start /B adb logcat >%%i.log
TIMEOUT 23
adb shell dmesg -c >%%i.log
adb shell "mkdir /mnt/Pictures/
adb shell screencap -p /mnt/Pictures/%%iA.png
TIMEOUT 20
adb shell screencap -p /mnt/Pictures/%%iB.png
adb pull /mnt/Pictures/%%iA.png
adb pull /mnt/Pictures/%%iB.png
adb shell "rm -r /mnt/Pictures/%%iA.png
adb shell "rm -r /mnt/Pictures/%%iB.png
for /F %%j in ('adb shell "if [ -f /dev/video8 ];then echo 0;else echo 1;fi"') do ( if %%j == 1 (goto last))
adb reboot 
echo %%i
)
:last
pause
