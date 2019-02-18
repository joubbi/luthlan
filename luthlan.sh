#!/bin/sh

echo 1 >/proc/sys/net/ipv4/conf/all/arp_ignore
echo 2 >/proc/sys/net/ipv4/conf/all/arp_announce
echo 2 >/proc/sys/net/ipv4/conf/all/rp_filter

#device="$1.$2"
device="$1.$(printf %02d $2)"

#ip link add link "$1" address 58:9c:fc:00:11:"$2" $device type macvlan
ip link add link "$1" address 58:9c:fc:00:11:"$(printf %02d $2)" $device type macvlan
ip addr add 192.168.0.11/24 brd + dev $device
ip link set $device up

echo "$device created"
