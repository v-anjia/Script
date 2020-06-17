#!/bin/sh
#for i-touch configurate
#author antony weijiang
#date 2019/12/5

sed -i 's/default-display.*/default-display = 2/g' /lib64/graphics.conf
sed -i '/\/living.*display=1.*ITouchUI.*/s/display=1/display=2/g' /scripts/startup.sh
slay -9 $(echo $(pidin arg|grep -E "screen|openwfd"|grep -v grep |awk -F ' ' '{print $1}'))
openwfd_server
screen -c /lib64/graphics.conf  >/dev/null 2>&1 &
export LIBIMG_CFGFILE=/proc/boot/img_splash.conf
ssplash -f /proc/boot/logo.jpg >/dev/null 2>&1 &
slay -9 $(echo $(pidin arg|grep -E "cluster"|grep -Ev "grep|cluster_service"|awk -F ' ' '{print $1}'))
sleep 5
#reset


