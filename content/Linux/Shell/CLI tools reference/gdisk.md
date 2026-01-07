---
tags:
  - linux
  - IT
---
`gdisk` is one of [[2 Knowledge/IT/Linux]] tools to work with hard drives.

# Example or creating a partition on a new disk
Enter into interactive mode:
```bash
$ sudo gdisk /dev/sdb
GPT fdisk (gdisk) version 1.0.8

Partition table scan:
  MBR: not present
  BSD: not present
  APM: not present
  GPT: not present

Creating new GPT entries in memory.
```
Next, let's create first partition (`n`):
```bash
Command (? for help): n
Partition number (1-128, default 1): 
First sector (34-6291422, default = 2048) or {+-}size{KMGTP}: 
Last sector (2048-6291422, default = 6291422) or {+-}size{KMGTP}: +1G
Current type is 8300 (Linux filesystem)
Hex code or GUID (L to show codes, Enter = 8300): 
Changed type of partition to 'Linux filesystem'
```
Then we can list partitions and apply changes (`p` and `w`):
```bash
Command (? for help): p
Disk /dev/sdb: 6291456 sectors, 3.0 GiB
Model: QEMU HARDDISK   
Sector size (logical/physical): 512/512 bytes
Disk identifier (GUID): EF81F3A6-E15E-46FF-AF29-3FCD97FF018B
Partition table holds up to 128 entries
Main partition table begins at sector 2 and ends at sector 33
First usable sector is 34, last usable sector is 6291422
Partitions will be aligned on 2048-sector boundaries
Total free space is 4194237 sectors (2.0 GiB)

Number  Start (sector)    End (sector)  Size       Code  Name
   1            2048         2099199   1024.0 MiB  8300  Linux filesystem

Command (? for help): w

Final checks complete. About to write GPT data. THIS WILL OVERWRITE EXISTING
PARTITIONS!!

Do you want to proceed? (Y/N): y
OK; writing new GUID partition table (GPT) to /dev/sdb.
The operation has completed successfully.
```