---
aliases:
  - SSH
---

Генерация ssh-ключа RSA-SHA2-512 c помощью ssh-keygen:
```bash
ssh-keygen -t rsa -b 4096 -C "ansible@sanchpet-pc"
```
Удобная отправка ключа на машину через ssh-copy-id:
```bash
ssh-copy-id -i /home/alpetrov/.ssh/id_rsa_lfactory_ansible.pub root@stage.ansible
```
Проверить список ключей, загруженных в агент:
```bash
ssh-add -l
```

Скрипт для быстрого отключения парольной авторизации на сервере:
```bash
ssh root@lfactory-prod "grep -rl '^PasswordAuthentication yes' /etc/ssh | xargs sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/'; systemctl restart ssh"
```
Находясь на сервере, отключаем логин root по SSH:
```bash
grep -lr PermitRootLogin /etc/ssh/ | xargs sed -i 's/PermitRootLogin yes/PermitRootLogin no/g'
```
