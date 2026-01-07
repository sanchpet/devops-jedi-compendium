---
tags:
  - linux
  - bash
title: Shell
aliases:
  - Shell
---
Working in the shell is one of the main things you should start with when getting to know [[Linux]]. It's our toolkit for performing actions in the system; with commands, we configure everything else.
# Input/Output Streams (I/O streams)
## stdin
Send a file to a program’s standard input:
```shell
head < /proc/cpuinfo
```
## stdout
Has stream ID 1. Write command output to a file:
```shell
command > file # перезаписать файл
command >> file # добавить в файл снизу
```
In `bash`, to avoid overwriting files, you can use the `set -C` option.  
Pipe the output of one command into another’s input with `|`:
```shell
head /proc/cpuinfo | tr a-z A-Z
```
## stderr
Has stream ID 2. Send errors to a file:
```shell
ls /ffff 2> err
```
Send errors to the same place as `stdout`:
```shell
ls /fff > f 2>&1
```
# Shell Commands (my notes)
## File operations
- [[cat]]
- [[ln]]
- [[ls]]
- [[touch]]
- [[flock]]
## Network
- [[dig]]
- [[iperf]]
- [[ping]]
- [[ssh]]
- [[tcpdump]]
- [[wget]]
## Text formatting
- [[echo]]
## Disks and filesystems
- [[gdisk]]
## Processes, resources, and monitoring
- [[htop]]
- [[strace]]    
## Other
- [[openssl]]



