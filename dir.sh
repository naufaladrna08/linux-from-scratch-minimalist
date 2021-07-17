#!/bin/bash

# Set MLFS root
echo "Input MLFS Root: " 
	read MLFS_ROOT
echo "Setting up MLFS Root"

# Create FHS
echo "Creating File System Hierarchy"

mkdir -pv ${MLFS_ROOT}/{bin,boot,dev,etc,opt,home,lib,lib64,mnt,proc,media,srv,sys,var}

mkdir -p ${MLFS_ROOT}/boot/grub
mkdir -p ${MLFS_ROOT}/lib/{firmware,modules}
mkdir -p ${MLFS_ROOT}/media/{floppy,cdrom}
mkdir -p ${MLFS_ROOT}/var/{lock,log,mail,run,spool}
mkdir -p ${MLFS_ROOT}/var/{opt,cache,lib/{misc,locate},local}
mkdir -p ${MLFS_ROOT}/usr/local/{bin,include,lib,sbin,src}
mkdir -p ${MLFS_ROOT}/usr/local/share/{doc,info,locale,man,misc,terminfo,zoneinfo}
mkdir -p ${MLFS_ROOT}/usr/local/share/man/man/{1,2,3,4,5,6,7,8}

for dir in ${MLFS_ROOT}/usr/local; do
	ln -sv ${MLFS_ROOT}/share/{man,doc,info} ${dir}
done

echo "Setting directory attributes"
install -dv -m 0750 ${MLFS_ROOT}/root
install -dv -m 1777 ${MLFS_ROOT}/var/tmp
install -dv ${MLFS_ROOT}/etc/init.d/
install -dv ${MLFS_ROOT}/xtools{,/bin}

echo "Done"
