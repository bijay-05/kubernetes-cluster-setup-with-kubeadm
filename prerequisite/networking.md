Subnetting happens at layer 3

What if we can make it at layer 2 ??

We can do it virtually.
VLAN will separate network logically
Broadcast domain is different for each VLAN
Layer 2 switch

Inter VLAN communication

For this, layer 2 switch is not enough.
We will need multi layer switch (L2 and L3) or a router.


|  Subnetting   |   VLAN    |
|---------------|-----------|
| Layer 3 (Network Layer) | Layer 2 (Data Link Layer, MAC) |
| Isolates traffic using IPs | Isolates traffic using VLAN Ids and tags |
| Needs router or L3 switch between subnets | Needs L3 switch or router for inter VLAN routing |
| Device in same subnet talk smoothly | Devices in same VLAN talk easily |
| Supports IP based security (ACLs, firewalls) | Supports security by isolating without IP |
| Can extend to WAN and internet | Limited to Local network without VLAN trunking |
| IPv4, IPv6, TCP, UDP, BGP | IEEE 802.10, STP, VTP |

## VLAN Terminology

VLAN ID / Tag: an ID added to data packets indicating the virtual network that packet belongs to

1. Untagged: the default VLAN ( with out specific VLAN ID ) will be assigned when plugged into a network port

2. Tagged: additional VLANs on a network port for devices that are aware of which VLAN they are supposed to be assigned to

Trunk port: a network port on a switch or router that is configured to carry traffic for multiple VLANs.

### Video References

[Demo using GNS3](https://www.youtube.com/watch?v=TQtpNSGAbpw)