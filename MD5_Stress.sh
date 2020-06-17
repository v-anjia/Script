#!/system/bin/sh
#author: antony weijiang
#datetime: 2019/8/19 
[ -d /update ] || mkdir -p /update
collect_log="/update/stress.log"
udisk_path="/mnt/udisk/"
echo -en "start md5 stress test\n" >> ${collect_log}
[ -L /mnt/udisk ] &&  package_name=$(cd ${udisk_path};ls -al ota-ASE2DHUAQ000*|/oem/bin/busybox awk '{print $NF}')
echo -en "package version is :${package_name}\n" >>  ${collect_log}
[ -L /mnt/udisk ] && except_md5=$(md5sum ${udisk_path}${package_name} |/oem/bin/busybox awk '{print $1}')
echo -en "origin md5 value is :${except_md5}\n"  >> ${collect_log}
[ -f /update/${package_name} ] &&  rm -f /update/${package_name}
pass=0
fail=0
total=0
while  [ 1 ]
do
	if [ -L /mnt/udisk ];then
		cp -f /mnt/udisk/${package_name}   /update  &
		wait $!
		actual_md5=$(md5sum /update/${package_name} |/oem/bin/busybox awk '{print $1}')
		echo "current md5 value is :${actual_md5}" >>  ${collect_log}
		if [ ${actual_md5} == ${except_md5} ];then
			pass=`expr ${pass} + 1`
			echo "verify md5 value successfully :${pass}"  >>  ${collect_log}
		else
			fail=`expr ${fail} + 1`
			echo "verify md5 value failed :${fail}" >> ${collect_log}
		fi
		total=`expr ${fail} + ${pass}`
		echo -en "Total\t\tPass\t\tFail\t\t\n" >>  ${collect_log}
		echo -en "*****************************************\n" >>  ${collect_log}
		echo -en "*****************************************\n" >> ${collect_log}
		echo -en "${total}\t\t${pass}\t\t${fail}\t\t\n" >> ${collect_log}
		[ -f /update/${package_name} ] && rm -f /update/${package_name} 
	else
		exit -1
	fi	
done