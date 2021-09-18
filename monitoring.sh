#!/bin/bash
ARCH=`uname -a`
CPU=`lscpu | grep 'Socket' | cut -d: -f2 | tr -d ' '`
vCPU_CORES=`lscpu | grep 'CPU(s)' | head -1 | awk '{printf("%d", $2)}'`
vCPU_THREADS=`lscpu | grep 'Thread(s) per core:' | head -1 | awk '{printf("%d", $4)}'`
vCPU=$(($vCPU_CORES / $vCPU_THREADS))
MEM_USE=`free -m | grep 'Mem' | awk '{printf("%s/%sMB (%.2f%%)"), $3, $2, $3/$2*100}'`
DISK_USE=`df -H --total | grep 'total' | awk '{printf("%s/%s (%s)"), $3, $4, $5}'`
CPU_LOAD=`top -bn 1 | grep '%Cpu(s)' | awk '{printf("%s%%"), $2}'`
LAST_BOOT=`who -b | awk '{printf("%s %s"), $3, $4}'`
LVM_USE=`lsblk | grep lvm`
TCP_CONN=`ss -s | awk 'NR == 2 {printf("%s"), $4}' | tr -d ','`
USER_LOG=`who | cut -d " " -f 1 | sort -u | wc -l`
NET_WORK_IP=`ip a | grep enp0s3: -A 2 | awk 'NR == 3 {printf("%s"), $2}' | cut -d '/' -f1`
NET_WORK_MAC=`ip a | grep enp0s3: -A 2 | awk 'NR == 2 {printf("%s"), $2}' | cut -d '/' -f1`
SUDO=`grep -a USER=root /var/log/sudo/sudo.log | wc -l`

echo "#Architecture: $ARCH"
echo "#CPU physical: $CPU"
echo "#vCPU: $vCPU"
echo "#Memory Usage: $MEM_USE"
echo "#Disk Usage: $DISK_USE"
echo "#CPU load: $CPU_LOAD"
echo "#Last boot: $LAST_BOOT"
if [[ ! -z "$LVM_USE" ]]
then
        echo "#LVM use: yes"
else
        echo "#LVM use: no"
fi
echo "#TCP Connections: $TCP_CONN ESTABLISHED"
echo "#User log: $USER_LOG"
echo "#Network: $NET_WORK_IP ($NET_WORK_MAC)"
echo "#Sudo: $SUDO cmd"
