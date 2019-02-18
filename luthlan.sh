#!/bin/sh
###############################################################################
#                                                                             #
# A script for adding macvlan interfaces on a linux device.                   #
# Each device will communicate using it's own hardware address.               #
#                                                                             #
# Version 1.0 2019-02-18 Initial release.                                     #
#                                                                             #
# Licensed under the Apache License Version 2.0                               #
# Written by farid@joubbi.se                                                  #
#                                                                             #
############################################################################### 



if [ $# -lt 3 ]; then
  echo "Wrong amount of arguments!"
  echo "./`basename $0` device number address"
  echo "Example: ./`basename $0` eth0 1 192.168.0.100/24"
  echo
  exit 1
fi

echo 1 >/proc/sys/net/ipv4/conf/all/arp_ignore
echo 2 >/proc/sys/net/ipv4/conf/all/arp_announce
echo 2 >/proc/sys/net/ipv4/conf/all/rp_filter

device="$1.$(printf %02d $2)"

ip link add link "$1" address 58:9c:fc:00:11:"$(printf %02d $2)" $device type macvlan
ip link set $device up

if [ $3 = "dhcp" ]; then
  dhclient $device
else
  ip addr add $3 brd + dev $device
fi

echo "$device created"
ip addr show dev $device

