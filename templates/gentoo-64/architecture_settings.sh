# settings that will be shared between all scripts

cat <<DATAEOF > "/etc/profile.d/architecture.sh"
export architecture="amd64"

# stage 3 filename
export stage3file=`wget http://distfiles.gentoo.org/releases/amd64/autobuilds/latest-stage3.txt -O - | grep -v nomultilib | grep amd64`

# for the compiler
export chost="x86_64-pc-linux-gnu"

# for grub
export grub_architecture="x86_64"

DATAEOF
