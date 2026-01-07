---
tags:
  - network
  - linux
  - IT
---
tcpdump tool unpacks description of content of packets on network interface.

In common case the output format of TCP has following fields:
- `tos` - name of service
- `TTL` - TTL of packet
- `id` - IP-indentifier
- `offset` - field of fragment offset. It can show us that packet is a part of fragmented datagram.
- `flags` - DF/MF and so on, see [[IP]] doc. 
- `proto` - protocol identifier
- `length` 
- `options` - options of IP protocol
# Example
Run simple http-server on localhost. Then curl:
```bash
sudo tcpdump -i lo tcp port 8080 -vvv
```
See result:
```
tcpdump: listening on lo, link-type EN10MB (Ethernet), snapshot length 262144 bytes
10:20:41.682317 IP (tos 0x0, ttl 64, id 16819, offset 0, flags [DF], proto TCP (6), length 60)
    localhost.40222 > localhost.http-alt: Flags [S], cksum 0xfe30 (incorrect -> 0x9920), seq 1363803880, win 65495, options [mss 65495,sackOK,TS val 1801207460 ecr 0,nop,wscale 7], length 0
10:20:41.682325 IP (tos 0x0, ttl 64, id 0, offset 0, flags [DF], proto TCP (6), length 60)
    localhost.http-alt > localhost.40222: Flags [S.], cksum 0xfe30 (incorrect -> 0xca9f), seq 3512029989, ack 1363803881, win 65483, options [mss 65495,sackOK,TS val 1801207460 ecr 1801207460,nop,wscale 7], length 0
10:20:41.682332 IP (tos 0x0, ttl 64, id 16820, offset 0, flags [DF], proto TCP (6), length 52)
    localhost.40222 > localhost.http-alt: Flags [.], cksum 0xfe28 (incorrect -> 0xf15b), seq 1, ack 1, win 512, options [nop,nop,TS val 1801207460 ecr 1801207460], length 0
10:20:41.682418 IP (tos 0x0, ttl 64, id 16821, offset 0, flags [DF], proto TCP (6), length 129)
    localhost.40222 > localhost.http-alt: Flags [P.], cksum 0xfe75 (incorrect -> 0x6dc9), seq 1:78, ack 1, win 512, options [nop,nop,TS val 1801207460 ecr 1801207460], length 77: HTTP, length: 77
        GET / HTTP/1.1
        Host: localhost:8080
        User-Agent: curl/8.5.0
        Accept: */*

10:20:41.682423 IP (tos 0x0, ttl 64, id 54362, offset 0, flags [DF], proto TCP (6), length 52)
    localhost.http-alt > localhost.40222: Flags [.], cksum 0xfe28 (incorrect -> 0xf10f), seq 1, ack 78, win 511, options [nop,nop,TS val 1801207460 ecr 1801207460], length 0
10:20:41.682567 IP (tos 0x0, ttl 64, id 54363, offset 0, flags [DF], proto TCP (6), length 173)
    localhost.http-alt > localhost.40222: Flags [P.], cksum 0xfea1 (incorrect -> 0xe6c3), seq 1:122, ack 78, win 512, options [nop,nop,TS val 1801207460 ecr 1801207460], length 121: HTTP, length: 121
        HTTP/1.1 200 OK
        Date: Thu, 30 Jan 2025 07:20:41 GMT
        Content-Length: 5
        Content-Type: text/plain; charset=utf-8

        Hello [|http]
10:20:41.682594 IP (tos 0x0, ttl 64, id 16822, offset 0, flags [DF], proto TCP (6), length 52)
    localhost.40222 > localhost.http-alt: Flags [.], cksum 0xfe28 (incorrect -> 0xf095), seq 78, ack 122, win 512, options [nop,nop,TS val 1801207460 ecr 1801207460], length 0
10:20:41.682745 IP (tos 0x0, ttl 64, id 16823, offset 0, flags [DF], proto TCP (6), length 52)
    localhost.40222 > localhost.http-alt: Flags [F.], cksum 0xfe28 (incorrect -> 0xf093), seq 78, ack 122, win 512, options [nop,nop,TS val 1801207461 ecr 1801207460], length 0
10:20:41.682841 IP (tos 0x0, ttl 64, id 54364, offset 0, flags [DF], proto TCP (6), length 52)
    localhost.http-alt > localhost.40222: Flags [F.], cksum 0xfe28 (incorrect -> 0xf091), seq 122, ack 79, win 512, options [nop,nop,TS val 1801207461 ecr 1801207461], length 0
10:20:41.682851 IP (tos 0x0, ttl 64, id 16824, offset 0, flags [DF], proto TCP (6), length 52)
    localhost.40222 > localhost.http-alt: Flags [.], cksum 0xfe28 (incorrect -> 0xf091), seq 79, ack 123, win 512, options [nop,nop,TS val 1801207461 ecr 1801207461], length 0
```