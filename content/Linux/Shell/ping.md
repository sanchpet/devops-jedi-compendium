---
tags:
  - network
  - linux
  - IT
---
ping - simple tool that sends packets `ECHO-REQUEST` of [[ICMP]] protocol to check connection between 2 hosts. 

[[ICMP]] is a L4 protocol, just as [[TCP]] and [[UDP]]. 

[[Kubernetes]] [[Service]] support TCP and UDP, but no [[ICMP]]. Ping will have no effect when it interacts with service, so to check connection it is better to use [[telnet]]. 

# Commands
Send exactly 2 packets:
```
ping -c 2 k8s.io
```
Options:
- `-c <num>`: send the exact number of packets
- `-i <sec>`: sets interval between consequent sendings. By default it is 1 sec. Low values are not recommended as they can flood bandwidth
- `-o` - exit after receiving 1 packet, equivalent of `-c 1`
- `-S <addr>` - for packet routing use defined source address
- `-W <milisec>` - interval of waiting for packet receive. 