#!/bin/bash
source /etc/profile

# set passwords (for after reboot)
chroot "$chroot" passwd<<EOF
$password_root
$password_root
EOF

cp -r /root/.ssh $chroot/root/

chroot "$chroot" /bin/bash <<DATAEOF
emerge app-admin/sudo
DATAEOF

