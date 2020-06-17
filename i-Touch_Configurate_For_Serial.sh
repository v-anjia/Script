#!/bin/sh
#for i-touch configurate
#author antony weijiang
#date 2019/12/5
serial_device=${1}
function Touch_configurate()
{
	echo -en "sed -i 's/default-display.*/default-display = 2/g' /lib64/graphics.conf\n" > ${1} 
	echo -en "sed -i '/\/living.*display=1.*ITouchUI.*/s/display=1/display=2/g' /scripts/startup.sh\n" > ${1}
	echo -en "slay -9 \$(echo \$(pidin arg|grep -E \"screen|openwfd\"|grep -v grep |awk -F ' ' '{print \$1}'))\n" > ${1}
	echo -en "openwfd_server\n" > ${1}
	echo -en "screen -c /lib64/graphics.conf  >/dev/null 2>&1 &\n" > ${1}
	echo -en "export LIBIMG_CFGFILE=/proc/boot/img_splash.conf\n" > ${1}
	echo -en "ssplash -f /proc/boot/logo.jpg >/dev/null 2>&1 &\n" > ${1}
	echo -en "slay -9 \$(echo \$(pidin arg|grep -E \"cluster\"|grep -Ev \"grep|cluster_service\"|awk -F ' ' '{print \$1}'))\n" > ${1}
	echo -en "sleep 5\n" > ${1}
#	reset
}

Touch_configurate ${serial_device}
