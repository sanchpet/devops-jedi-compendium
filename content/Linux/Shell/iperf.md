---
tags:
  - linux
  - bash
  - IT
---
 iperf can test bandwith.

It can run both as client and as server. Install the package `iperf3`:
```
sudo apt update
sudo apt install -y iperf3
```
Then start iperf server:
```bash
sudo iperf3 -s 0.0.0.0
```

On the client start the test:
```bash
sudo iperf3 -c 77.222.53.15 -V -t 60
```
And see the result:
```bash
iperf 3.16
Linux sanchpetpc 5.15.167.4-microsoft-standard-WSL2 #1 SMP Tue Nov 5 00:21:55 UTC 2024 x86_64
Control connection MSS 1448
Time: Wed, 29 Jan 2025 16:03:12 GMT
Connecting to host 77.222.53.15, port 5201
      Cookie: 6fcejpmzmk52jrb637u4xwg2lpzd3mot66l4
      TCP MSS: 1448 (default)
[  5] local 172.19.245.29 port 48176 connected to 77.222.53.15 port 5201
Starting Test: protocol: TCP, 1 streams, 131072 byte blocks, omitting 0 seconds, 60 second test, tos 0
[ ID] Interval           Transfer     Bitrate         Retr  Cwnd
[  5]   0.00-1.00   sec  18.9 MBytes   158 Mbits/sec    0    148 KBytes
[  5]   1.00-2.02   sec  16.4 MBytes   135 Mbits/sec    0    148 KBytes
[  5]   2.02-3.04   sec  13.2 MBytes   109 Mbits/sec    0    148 KBytes
[  5]   3.04-4.01   sec  10.9 MBytes  94.0 Mbits/sec    0    148 KBytes
[  5]   4.01-5.04   sec  8.75 MBytes  71.5 Mbits/sec    0    148 KBytes
<...>
[  5]  57.03-58.01  sec  5.50 MBytes  47.4 Mbits/sec    0    148 KBytes
[  5]  58.01-59.03  sec  5.38 MBytes  44.1 Mbits/sec    0    148 KBytes
[  5]  59.03-60.00  sec  5.50 MBytes  47.3 Mbits/sec    0    148 KBytes
- - - - - - - - - - - - - - - - - - - - - - - - -
Test Complete. Summary Results:
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-60.00  sec   533 MBytes  74.5 Mbits/sec    0             sender
[  5]   0.00-57.73  sec   528 MBytes  76.7 Mbits/sec                  receiver
CPU Utilization: local/sender 0.2% (0.0%u/0.2%s), remote/receiver 5.4% (0.7%u/4.8%s)
snd_tcp_congestion cubic
rcv_tcp_congestion cubic

iperf Done.
```
If you use prometheus and node exportet, then you will detect a spike on CPU and Networking diagrams:
![[Pasted image 20250129190712.png]]
