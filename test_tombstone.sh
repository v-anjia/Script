#!/system/bin/sh
#author : antony weijiang
#date: 2020/4/20

busybox="/yf/bin/busybox"
tomstone_path="/data/tombstones"
function check_tomstone()
{
	if  [ -f  /data/tombstones/tombstone* ];then
		file_flag=$(ls -al /data/tombstones/tombstone* | ${busybox} wc -l)
		echo  ${file_flag}
		return ${file_flag}
	fi
	return 0
}

function check_pid()
{
	pid=$(cat ${tomstone_path}/tombstone_00 |grep pid |cut -d ',' -f1|${busybox} awk '{print $2}')
	echo  "pid : ${pid}"
	child_pid_name=$(ps $(ps |grep ${pid}|grep -v grep|grep -v ps |${busybox} awk '{print $3}'|head -n1) | ${busybox} awk '{print $NF}')
	echo "app name is : ${child_pid_name}"
}

while  [ 1 ]
do 
	check_tomstone
	if [ $? -ge 1 ];then
		check_pid
		exit 0
	fi
done
	