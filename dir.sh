#!/bin/bash

# Set LFS root
echo "Input LFS Root: " 
	read LFS_ROOT
echo "Setting up LFS Root"

# Create FHS
echo "Creating File System Hierarchy"

mkdir -pv ${LFS_ROOT}/{bin,boot,dev,etc,opt,home,lib,lib64,mnt,proc,media,srv,sys,var}

mkdir -p ${LFS_ROOT}/boot/grub
mkdir -p ${LFS_ROOT}/lib/{firmware,modules}
mkdir -p ${LFS_ROOT}/media/{floppy,cdrom}
mkdir -p ${LFS_ROOT}/var/{lock,log,mail,run,spool}
mkdir -p ${LFS_ROOT}/var/{opt,cache,lib/{misc,locate},local}
mkdir -p ${LFS_ROOT}/usr/local/{bin,include,lib,sbin,src}
mkdir -p ${LFS_ROOT}/usr/local/share/{doc,info,locale,man,misc,terminfo,zoneinfo}
mkdir -p ${LFS_ROOT}/usr/local/share/man/man/{1,2,3,4,5,6,7,8}

for dir in ${LFS_ROOT}/usr/local; do
	ln -sv ${LFS_ROOT}/share/{man,doc,info} ${dir}
done

echo "Setting directory attributes"
install -dv -m 0750 ${LFS_ROOT}/root
install -dv -m 1777 ${LFS_ROOT}/var/tmp
install -dv ${LFS_ROOT}/etc/init.d/
install -dv ${LFS_ROOT}/xtools{,/bin}

echo "Done"
