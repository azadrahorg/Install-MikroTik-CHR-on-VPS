#!/bin/bash
wget https://download.mikrotik.com/routeros/7.8/chr-7.8.img.zip -O chr.img.zip  && \
gunzip -c chr.img.zip > chr.img  && \
STORAGE=`lsblk | grep disk | cut -d ' ' -f 1 | head -n 1` && \
ETH=`ip route show default | sed -n 's/.* dev \([^\ ]*\) .*/\1/p'` && \
ADDRESS=`ip addr show $ETH | grep global | cut -d' ' -f 6 | head -n 1` && \
GATEWAY=`ip route list | grep default | cut -d' ' -f 3` && \
echo u > /proc/sysrq-trigger && \
dd if=chr.img bs=1M of=/dev/$STORAGE iflag=fullblock && \
echo "sync disk" && \
echo s > /proc/sysrq-trigger && \
echo "Sleep 5 seconds" && \
sleep 5 && \
echo "Ok, reboot" && \
echo b > /proc/sysrq-trigger