#!/bin/bash

##
# Ensure eth0 and eth1 as inteface names
##

GRUB=/etc/default/grub
GRUB_CMDLINE_VALUES=$(grep GRUB_CMDLINE_LINUX $GRUB | cut -d '"' -f 2) 

# Check if biosdevname exists
[[ $(grep biosdevname $GRUB) ]] || sed -i "s/^GRUB_CMDLINE_LINUX.*$/GRUB_CMDLINE_LINUX=\"${GRUB_CMDLINE_VALUES} biosdevname=0\"/g" $GRUB

# Make sure biosdevname=0
[[ $(grep 'biosdevname' $GRUB) ]] && sed -i "s/biosdevname=[0-9]/biosdevname=0/g" $GRUB

GRUB_CMDLINE_VALUES=$(grep GRUB_CMDLINE_LINUX $GRUB | cut -d '"' -f 2) 
# Check if net.ifnames exists
[[ $(grep net.ifnames $GRUB) ]] || sed -i "s/^GRUB_CMDLINE_LINUX.*$/GRUB_CMDLINE_LINUX=\"${GRUB_CMDLINE_VALUES} net.ifnames=0\"/" $GRUB

## Make sure net.ifnames=0
[[ $(grep 'net.ifnames' $GRUB) ]] && sed -i "s/net.ifnames=[0-9]/net.ifnames=0/g" $GRUB

/usr/sbin/grub2-mkconfig
