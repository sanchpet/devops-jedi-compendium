---
tags:
  - linux
  - IT
---
## Filesystems
There are many filesystems in [[Linux/index|Linux]], all they offer a unified interface to organize and store data:
- [[Ext4]] - main and most common FS. Offers a good balance between performance and features, such as transaction journaling, big file sizes support, persistence to data loss.
- [[XFS]] - FS with high performance, designed to work with big data volumes on a high loads. XFS supports big file sizes, has inbuilt backups, provides impressive i/o speed.
- [[Btrfs]] (B-tree FS) - modern FS offering set of advanced features, including FS snapshots, providing extremely high data capacity and smart Copy-on-Write.
- [[ZFS]] (Zettabyte FS) - another modern FS, developed on Sun Microsystems and supported by Oracle. ZFS provides strict control over data, auto-recovery from errors, snapshots and copying on-the-fly. ZFS needs more RAM for stable work.
- [[FAT32]] and [[NTFS]] - FS written for [[Windows]], yet supported in Linux for compatibility.