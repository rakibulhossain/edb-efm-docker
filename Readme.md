## Edb-EFM-Docker

For demo purposes, we use `network_mode` = `host` and `pid` = `host`, which allows the containers to access the host's network namespaces and process namespaces. Thus, EFM requires physical network access for assigning the Virtual IP, It is better to use macVlan or IpVlan, rather than the host.

However, macVlan requires enabling `promiscuous mode` on the host, as macVlan assigns a unique MAC address to each container, and ingress and egress traffic pass through the host. Though in some cases you can enable it on the host itself, for some Virtualization platforms (Such as VMware vSphere), it can only be enabled in the EXSI settings. And it will affect the other VM using the same ESXi.


Though the solution is working, there's a bug regarding the failover. You should find it yourself.
