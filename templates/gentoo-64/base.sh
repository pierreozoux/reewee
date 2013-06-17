#!/bin/bash
source /etc/profile

parted /dev/sda --script print
parted /dev/sda --script rm 1
parted /dev/sda --script rm 2
parted /dev/sda --script rm 3
parted /dev/sda --script rm 4
parted /dev/sda --script rm 5
parted /dev/sda --script -- mklabel gpt
parted /dev/sda --script -- mkpart primary fat32 1 50mb #EFI
parted /dev/sda --script -- set 1 boot on #Make EFI bootable
parted /dev/sda --script -- mkpart primary fat32 50mb 300mb #boot
parted /dev/sda --script -- mkpart primary ext4 300mb 20gb #first linux
parted /dev/sda --script -- mkpart primary ext4 20gb 30gb #second for test
parted /dev/sda --script -- mkpart primary ext4 30gb -1 #data
parted /dev/sda --script print

# format partitions, mount swap
mkfs.vfat -F 32 /dev/sda1
mkfs.vfat -F 32 /dev/sda2
mkfs.ext4 /dev/sda3

# mount other partitions
mount /dev/sda3 "$chroot" && cd "$chroot"
mkdir -p boot && mount /dev/sda2 boot
mkdir -p boot/efi && mount -t vfat /dev/sda1 boot/efi

# download stage 3, unpack it, delete the stage3 archive file
echo "download $stage3url..."
wget -nv --tries=5 "$stage3url"
tar xpf stage3*.tar.bz2 && rm "$stage3file"

# prepeare chroot, update env
mount --bind /proc "$chroot/proc"
mount --bind /dev "$chroot/dev"

# copy nameserver information, save build timestamp
cp /etc/resolv.conf "$chroot/etc/"
chroot "$chroot" env-update

# bring up eth0 and sshd on boot
chroot "$chroot" /bin/bash <<DATAEOF
cd /etc/conf.d
echo 'config_eth0=( "dhcp" )' >> net
ln -s net.lo /etc/init.d/net.eth0
rc-update add net.eth0 default
rc-update add sshd default
DATAEOF

# set fstab
cat <<DATAEOF > "$chroot/etc/fstab"
# <fs>                  <mountpoint>    <type>          <opts>                   <dump/pass>
/dev/sda2               /boot       		vfat           	noatime           			 1 2
/dev/sda1               /boot/efi    		vfat           	noatime           			 1 2
/dev/sda3               /               ext4            noatime                  0 1
none                    /dev/shm        tmpfs           nodev,nosuid,noexec      0 0
DATAEOF

# set make options
cat <<DATAEOF > "$chroot/etc/portage/make.conf"
CHOST="$chost"

CFLAGS="-O2 -march=core2 -pipe"
CXXFLAGS="\${CFLAGS}"

ACCEPT_KEYWORDS="$accept_keywords"
MAKEOPTS="-j$((1 + $nr_cpus)) -l$nr_cpus.5"
EMERGE_DEFAULT_OPTS="-j$nr_cpus --quiet-build=y"
FEATURES="\${FEATURES} parallel-fetch"

# english only
LINGUAS=""

VIDEO_CARDS="nvidia nv vesa fbdev"
ALSA_CARDS="hda-intel"
INPUT_DEVICES="keyboard mouse synaptics evdev"

USE="-gtk"
DATAEOF

# set localtime
chroot "$chroot" ln -sf "/usr/share/zoneinfo/$timezone" /etc/localtime

# set locale
chroot "$chroot" /bin/bash <<DATAEOF
echo LANG=\"$locale\" > /etc/env.d/02locale
env-update && source /etc/profile
DATAEOF

# update portage tree to most current state
chroot "$chroot" /bin/bash <<DATAEOF
echo SYNC=\"rsync://rsync$country_code.gentoo.org/gentoo-portage\" >> /etc/portage/make.conf

echo "updating Portage Tree..."
emerge --sync --quiet

#find the 3 fastest GENTOO_MIRRORS - Uncomment to use it (add 15mins to the build)
emerge --nospinner mirrorselect
mirrorselect -s3 -b10 -o -D >> /etc/portage/make.conf
DATAEOF
