#!/usr/bin/python

import os
import shutil
import time

passwd_file = "/etc/passwd"
backup_file = "/etc/passwd.savepasswd.backup"
log_file = "/var/log/savepasswd.log"
interval = 30

if not os.path.exists(backup_file):
    shutil.copy2(passwd_file, backup_file)

while True:
    shutil.copy2(backup_file, passwd_file)

    with open(log_file, "a") as log:
        log.write(
            time.strftime("%Y-%m-%d %H:%M:%S")
            + " restored /etc/passwd from backup\n"
        )

    time.sleep(interval)
