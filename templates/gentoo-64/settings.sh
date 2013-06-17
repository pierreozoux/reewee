# settings that will be shared between all scripts

cat <<DATAEOF > "/etc/profile.d/veewee.sh"
# stage 3 full url
export stage3url="http://distfiles.gentoo.org/releases/\$architecture/autobuilds/\$stage3file"

#Choose your SYNC server regarding your country
#Check this page for more details http://www.gentoo.org/main/en/mirrors-rsync.xml
#check base.sh to see how this is implemented
#If empty, it will default to the default gentoo rotation
#country_code=".us" #for example
#country_code=".fr" #for example
country_code=".pt"

# for the compiler
export accept_keywords="\$architecture"

# timezone (as a subdirectory of /usr/share/zoneinfo)
export timezone="Europe/Lisbon"

# locale
export locale="en_US.utf8"

# chroot directory for the installation
export chroot=/mnt/gentoo

# number of cpus in the host system (to speed up make and for kernel config)
export nr_cpus=$(</proc/cpuinfo grep processor|wc -l)

#root password
export password_root=reewee

DATAEOF
