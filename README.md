# Network Infrastructure and Out-Of-Band Mangament Lab

A fully automated network enviroment utlizing a dual NIC ubuntu server to act as a bashton/console server.

## Topology

```bash
[CLOUD]-----[ R1 ]----[ CD1 ]----[ ACC1 ]
            |    |    |          |
            |  [ MANGEMENT SWITCH ]
            |        |
        [ Console Server ]
```

## Objectives

1. **Bastion & Console Server**: Establish a secure gateway server with dual network interfaces to separate transit traffic from internal management.

2. **Out-of-Band (OOB) Management Plane**: Isolate switch management traffic onto VLAN 100 so that only the console server can directly access and configure network devices.

3. **Infrastructure as Code (IaC)**: Use a minimal bootstrap shell script to provision the control environment, hand off configuration management entirely to local Ansible playbooks, and secure access via SSH key-only authentication.

## Quickstart & Deployment Guide

### 1. Edge Router (R1) configuration

configure teh gateway router with DHCP WAN interface, NAT overload (PAT) and inbound static port forwarding for extenrall ssh access

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

### 2. Ubunutu Bastion Server  

Configure the dual interfaces (ens3 OOB management, ens4 for transit) and apply provision ansible

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

### 3. OOB and Device Managment Set up

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
