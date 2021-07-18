#!/bin/bash

TLFS_ROOT=""

function get_root_dir() {
	# Set TLFS root
	echo "Input TLFS Root: " 
		read TLFS_ROOT
		echo $TLFS_ROOT > root
	echo "Setting up TLFS Root"	
}

# Create FHS
function create_fhs() {
	echo "Creating File System Hierarchy"

	mkdir -pv ${TLFS_ROOT}/{bin,boot,dev,etc,opt,home,lib,lib64,mnt,proc,media,srv,sys,var}

	mkdir -p ${TLFS_ROOT}/boot/grub
	mkdir -p ${TLFS_ROOT}/lib/{firmware,modules}
	mkdir -p ${TLFS_ROOT}/media/{floppy,cdrom}
	mkdir -p ${TLFS_ROOT}/var/{lock,log,mail,run,spool}
	mkdir -p ${TLFS_ROOT}/var/{opt,cache,lib/{misc,locate},local}
	mkdir -p ${TLFS_ROOT}/usr/{bin,include,lib,sbin,src}
	mkdir -p ${TLFS_ROOT}/usr/share/{doc,info,locale,man,misc,terminfo,zoneinfo}
	mkdir -p ${TLFS_ROOT}/usr/share/man/man/{1,2,3,4,5,6,7,8}
	mkdir -p ${TLFS_ROOT}/usr/local/{bin,include,lib,sbin,src}
	mkdir -p ${TLFS_ROOT}/usr/local/share/{doc,info,locale,man,misc,terminfo,zoneinfo}
	mkdir -p ${TLFS_ROOT}/usr/local/share/man/man/{1,2,3,4,5,6,7,8}

	for dir in ${TLFS_ROOT}/usr/local; do
		ln -sv ${TLFS_ROOT}/share/{man,doc,info} ${dir}
	done

	echo "Setting directory attributes"
	install -dv -m 0750 ${TLFS_ROOT}/root
	install -dv -m 1777 ${TLFS_ROOT}/var/tmp
	install -dv ${TLFS_ROOT}/etc/init.d/
	install -dv ${TLFS_ROOT}/xtools{,/bin}

	echo "Done"
}

# Main script 
get_root_dir
create_fhs