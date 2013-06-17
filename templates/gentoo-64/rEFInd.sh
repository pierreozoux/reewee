#!/bin/bash
source /etc/profile

chroot "$chroot" /bin/bash <<DATAEOF

#Install Gentoo kernel
cd /boot
mkdir -p efi/EFI
mkdir -p efi/EFI/Gentoo
mv vmlinuz-*-gentoo efi/EFI/Gentoo/Gentoo.efi

#rEFInd
cd
emerge zip
wget http://sourceforge.net/projects/refind/files/0.6.7/refind-bin-0.6.7.zip/download -O refind-bin-0.6.7.zip
unzip refind-bin-0.6.7.zip
cd refind-bin-0.6.7
cp -r refind /boot/efi/EFI/
cd ..
rm -rf refind-bin-0.6.7*
cd /boot/efi/EFI
mv refind boot
cd boot
rm refind_ia32.efi
rm -r drivers_ia32
mv refind.conf-sample refind.conf
mv refind_x64.efi bootx64.efi

#If you want Gentoo to run directly, without EFI, uncomment the 2 following lines :
#mv /boot/efi/EFI/boot/bootx64.efi /root/refind_x64.efi
#cp /boot/efi/EFI/Gentoo/Gentoo.efi refind_x64.efi /boot/efi/EFI/boot/bootx64.efi

#EFI Shell
mkdir /boot/efi/EFI/tools
cd /boot/efi/EFI/tools
wget "http://tianocore.git.sourceforge.net/git/gitweb.cgi?p=tianocore/edk2-EdkShellBinPkg;a=blob;f=FullShell/X64/Shell_Full.efi;h=ec3a10c39ba68ff42d4003a4f95a30abe1a0fd29;hb=HEAD" -O shell.efi

DATAEOF
