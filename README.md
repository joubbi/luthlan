# luthlan.sh

A script for adding macvlan interfaces on a linux device.

Each device will communicate using it's own hardware address.
The hardware address is `58:9c:fc:00:11:x`, where x is the same as the device number supploed to the script.


### Usage

To create a device named eth0.1 with the IP address 192.168.0.100/24:

`$ ./luthlan.sh eth0 1 192.168.0.100/24`



To create a device named eth0.2 with the IP address obtained from DHCP:

`$ ./luthlan.sh eth0 2 dhcp`

___

Licensed under the [__Apache License Version 2.0__](https://www.apache.org/licenses/LICENSE-2.0)

Written by __farid@joubbi.se__
