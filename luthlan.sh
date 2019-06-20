#!/bin/sh
###############################################################################
#                                                                             #
# A script for adding macvlan interfaces on a linux device.                   #
# Each device will communicate using it's own hardware address.               #
#                                                                             #
# You can either pass in values as arguments to the scripts,                  #
# or run it interactively.                                                    #
# The variables are the following:                                            #
# "first device number" "amount of devices" "first address" "vlan"            #
# Example: ./luthlan.sh 1 200 192.168.1.2/24 100                              #
#                                                                             #
# Version 2.0 2019-06-20 Added support for VLANs and read from user.          #
# Version 1.0 2019-02-18 Initial release.                                     #
#                                                                             #
# Licensed under the Apache License Version 2.0                               #
# Written by farid@joubbi.se                                                  #
#                                                                             #
###############################################################################

hw_device=eno1


echo 1 >/proc/sys/net/ipv4/conf/all/arp_ignore
echo 2 >/proc/sys/net/ipv4/conf/all/arp_announce
echo 2 >/proc/sys/net/ipv4/conf/all/rp_filter

first="$1"
amount="$2"
first_address="$3"
vlan="$4"

if [ -z "$first" ]; then
  read -rp 'First device number: ' first
fi

if [ -z "$amount" ]; then
  read -rp 'Amount of devices: ' amount
fi

if [ -z "$first_address" ]; then
  read -rp 'First IP address (with mask): ' first_address
fi


if [ -z "$vlan" ]; then
  read -rp 'VLAN: ' vlan
  if [ -z "$vlan" ]; then
    vlan_device=$hw_device
  fi
fi
if [ -n "$vlan" ]; then
  modprobe 8021q
  vconfig add "$hw_device" "$vlan"
  vlan_device=$hw_device.$vlan
  ip link set "$vlan_device" up
fi
echo "$vlan_device"


three_first_octets=$(echo "$first_address" | grep -oE "\b((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}\b")
last_octet=$(echo "$first_address" | grep -oP '[0-9]+(?=/)')
mask=$(echo "$first_address" | grep -oP '(?<=/)[0-9]+')


number="$first"
while [ "$number" -lt $((first + amount)) ]
do
  device="$vlan_device.$number"
  if ip link add link "$vlan_device" "$device" type macvlan ; then
    echo "$device created"
  else
    echo "Something went wrong creating $device"
  fi
  ip link set "$device" up

  if [ "$first_address" = "dhcp" ]; then
    dhclient "$device"
  else
    address=$three_first_octets$last_octet"/"$mask
    ip addr add "$address" dev "$device"
  fi

  #  ip addr show dev $device
  number=$((number + 1))
  last_octet=$((last_octet + 1))
done

