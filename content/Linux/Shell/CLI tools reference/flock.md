---
tags:
  - bash
  - linux
  - IT
---
flock - tool that allows to use lock-file to prevent running a copy of a script. For example, whe  you use cron script, you have to be sure that previous instance of the script is finished.

Example:
```bash
#!/bin/bash

lock="/tmp/bashdays.lock"

[[ -f "${lock}" ]] || touch "${lock}"

(
    flock -n -o -x ${fd_lock} || { echo 'Nice try' >&2; exit 0; }

    sleep 100

) {fd_lock}<"${lock}"
```