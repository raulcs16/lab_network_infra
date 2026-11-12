# Infrastructure Overview

## Topology

```bash
[CLOUD]-----[ R1 ]----[ CD1 ]----[ ACC1 ]
            |    |    |          |
            |  [ MANGEMENT SWITCH ]
            |        |
        [ Console Server ]
```

## Objectives

The key objective for this lab is to set up a bashton host which also acts as a console server, the bashton host will allows us to ssh into the server where then we set up ansible to it and via an MGM switch we get connected to each network device, allowing use to configure them using ansible,

Set up OOB managment, such that the console server only one who can ssh into each network devices, essentially creating the management plane

## Router Set Up

```bash router
config t
int loopback 0
ip address 192.168.100.254 255.255.255.2555
no shutdown
int eth 0/0
ip address 10.1.100.0 255.255.255.254
no shutdown
ip route 192.168.100.0 255.255.255.0 10.1.100.1

int eth 1/3
ip address dhcp # "public ip"
no shutdown 
ip nat outside


int eth 1/2
ip address 192.168.200.1 255.255.255.252
no shutdown
ip nat inside
exit

access-list 1 permit 192.168.200.0 0.0.0.3 
ip nat inside source list 1 interface eth 1/3 
ip nat inside source static tcp 192.168.200.2 22 int eth 1/3 2222
ip route 192.168.200.0 255.255.255.252 192.168.200.1
```

## Ubuntu Server Set up

```bash ubuntu
sudo -i 
vi /etc/netplan/00-config.yml
```

```yaml netplan/00-config.yml
network:
    ethernets:
        ens3:
            dhcp4: no
            addresses:
                - 192.168.100.99/24
        ens4:
            dhcp4: no 
            addresses:
                - 192.168.200.2/30
            routes:  
                - to: default
                  via: 192.168.200.1
            nameservers:
                addresses:
                    - 8.8.8.8
version: 2
```

```bash
netplan try
netplan apply
sudo apt update
sudo apt install -y git
git clone htts://github.com/raulcs16/lab_network_infra.git repo
cd repo/boostrap
chmod +x ansible.sh
./ansible.sh

```

## Switch Set up

```bash OOB
config t
vlan 100
name OOB
int vlan 100
ip address 192.168.100.1 255.255.255.0
no shutdown
int eth 0/0
switchport mode access
switchport access vlan 100
spanning-tree portfast
spanning tree bpdugaurd enable
no shutdown

int eth 0/1 [to routers]
no switchport 
ip address 10.1.100.1 255.255.255.254
no shutdown
exit 
ip routing
ip route 192.168.100.254 255.255.255.255 10.1.100.0

int eth [to switches]
switchport trunk encapsulation dot1q
switchport mode trunk
switchport trunk allowed vlan 100
no shutdown
```

```bash SWITCHES
config t
vlan 100
name OOB
int vlan 100
ip address 192.168.100.x1 255.255.255.0 # x = 1 for cd 2 for acc switch
no shutdown
int eth 0/0
switchport trunk encapsulation dot1q
switchport mode trunk
switchport trunk allowed vlan 100
no shutdown
```
