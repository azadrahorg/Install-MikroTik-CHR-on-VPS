#!/bin/bash -e

echo
echo "=== azadrah.org ==="
echo "=== https://github.com/azadrahorg ==="
echo "=== MikroTik 6 Installer ==="
echo
sleep 3

wget https://download.mikrotik.com/routeros/6.48.6/chr-6.48.6.img.zip -O chr.img.zip  && \
gunzip -c chr.img.zip > chr.img  && \
mount -o loop,offset=512 chr.img /mnt && \
STORAGE=`lsblk | grep disk | cut -d ' ' -f 1 | head -n 1` && \
echo STORAGE is $STORAGE && \
ETH=`ip route show default | sed -n 's/.* dev \([^\ ]*\) .*/\1/p'` && \
echo ETH is $ETH && \
ADDRESS=`ip addr show $ETH | grep global | cut -d' ' -f 6 | head -n 1` && \
echo ADDRESS is $ADDRESS && \
GATEWAY=`ip route list | grep default | cut -d' ' -f 3` && \
echo GATEWAY is $GATEWAY && \
echo "/ip address add address=$ADDRESS interface=[/interface ethernet find where name=ether1]
/ip route add gateway=$GATEWAY
/ip service disable telnet
/user set 0 name=root password=root
/interface ethernet reset-mac-address numbers=0
 " > /mnt/run.auto.rsc && \
umount /mnt && \
echo u > /proc/sysrq-trigger && \
dd if=chr.img bs=1024 of=/dev/$STORAGE && \
echo "sync disk" && \
echo s > /proc/sysrq-trigger && \
echo "Sleep 5 seconds" && \
sleep 5 && \
echo "Ok, reboot" && \
echo b > /proc/sysrq-trigger
