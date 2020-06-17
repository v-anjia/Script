#!/bin/sh

#author:antony weijiang
#date:2019-12-3

# $1: network ip address 10.2.35.xx
# $2: serial number /dev/ttyUSB0
network=${1}
serial_device=${2}
#configure network
function init_network()
{
	echo ${2}
	echo -en "ifconfig ax0 ${1}\n"  > ${2}
	echo -en "echo -en \"\nifconfig ax0 ${1}\n\" >> /scripts/startup.sh\n" > ${2}
}

function configurate_ssh_service()
{
	echo -en "ssh-keygen -R ${2}\n" > ${1}
	echo -en "random -U 16:16 -t\n" > ${1}
	echo -en "mkdir -p /var/ssh\n" > ${1}
	echo -en "rm -rf /var/ssh/*\n" > ${1} 
	echo -en "ssh-keygen -N '' -q -t dsa  -f /var/ssh/ssh_host_dsa_key\n" > ${1}
	echo -en "ssh-keygen -N '' -q -t rsa  -f /var/ssh/ssh_host_rsa_key\n" > ${1}
	echo -en "chmod 700 /var/ssh/*\n" > ${1}
	echo -en "echo \"sshd:x:74:74:Privilege-separated SSH:/var/empty/sshd:/sbin/nologin\" >> /etc/passwd\n" > ${1}
	echo -en "mkdir -p /var/chroot/sshd\n" > ${1}
       	echo -en "chmod 755 /var/chroot/sshd\n" > ${1}
	echo -en "/usr/sbin/sshd & \n" > ${1}	
 
}

init_network ${network} ${serial_device}
configurate_ssh_service ${serial_device} ${network}

