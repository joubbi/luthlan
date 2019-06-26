# luthlan

A script for adding macvlan interfaces on a linux device.

Each device will communicate using it's own hardware address.
You can either pass in values as arguments to the scripts, or run it interactively. 

Policy routing is used to add a default gateway for each interface.

### VLAN support
The script has support for VLANs.
You can for example configure a Cisco switchport as a VLAN trunk:
```
interface GigabitEthernet1/0/5
 description luthlan
 switchport trunk allowed vlan 600,1100-1999
 switchport mode trunk
``` 


### Usage

First, make sure that the variable **hw_device** is set to the right interface.
You need to edit the script to set this. It's at the top of the script.

To create 200 devices named eno1.100.x with the IP address 192.168.1.2/24 in VLAN 100 with default gateway 192.168.1.1, where x is the device number 1-200:

`# ./luthlan.sh 1 200 192.168.1.2/24 100 192.168.1.1`



To create a device named eno1.1 with the IP address obtained from DHCP:

`# ./luthlan.sh 1 1 dhcp`


It's also possible to run the script interactively like this:
```
# ./luthlan_extreme.sh
First device number: 1
Amount of devices: 1
First IP address (with mask): 192.168.0.1/24
VLAN: 3
Added VLAN with VID == 3 to IF -:eno1:-
eno1.3
Default gateway: 192.168.0.254
eno1.3.1 created
```



___

Licensed under the [__Apache License Version 2.0__](https://www.apache.org/licenses/LICENSE-2.0)

Written by __farid@joubbi.se__
