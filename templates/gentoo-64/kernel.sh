#!/bin/bash
source /etc/profile

# add required use flags and keywords
cat <<DATAEOF >> "$chroot/etc/portage/package.use"
sys-kernel/gentoo-sources symlink
DATAEOF

cat <<DATAEOF >> "$chroot/etc/portage/package.keywords"
dev-util/kbuild ~$architecture
DATAEOF

# Kernel Version
chroot "$chroot" /bin/bash <<DATAEOF
emerge --color n --nospinner --search gentoo-sources | grep 'Latest version available' | cut -d ':' -f 2 | tr -d ' ' > /root/kernel_version
DATAEOF

kernel_version=$(cat /mnt/gentoo/root/kernel_version)

echo "export kernel_version=$kernel_version" >> /etc/profile.d/veewee.sh

# get, configure, compile and install the kernel and modules
chroot "$chroot" /bin/bash <<DATAEOF
emerge --nospinner =sys-kernel/gentoo-sources-$kernel_version

cd /usr/src/linux

#copy config file created before
cp /root/config ./.config

#compile the kernel
make oldconfig
make -j3
make install modules_install

DATAEOF
