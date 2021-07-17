#!/bin/bash

# Set MLFS root
echo "[Configuration Files]"

echo "Input MLFS Root: " 
	read MLFS_ROOT
echo "Setting up MLFS Root"

echo "Creating /etc/passwd..."
cat > ${MLFS_ROOT}/etc/passwd << "EOF"
root::0:0:root:/root:/bin/ash
EOF
echo "Creating /etc/group..."
cat > ${MLFS_ROOT}/etc/group << "EOF"
root:x:0:
bin:x:1:
sys:x:2:
kmem:x:3:
tty:x:4:
daemon:x:6:
disk:x:8:
dialout:x:10:
video:x:12:
utmp:x:13:
usb:x:14:
EOF
echo "Creating /etc/passwd..."
cat > ${MLFS_ROOT}/etc/fstab << "EOF"
# file system  mount-point  type   options          dump  fsck
#                                                         order

rootfs          /               auto    defaults        1      1
proc            /proc           proc    defaults        0      0
sysfs           /sys            sysfs   defaults        0      0
devpts          /dev/pts        devpts  gid=4,mode=620  0      0
tmpfs           /dev/shm        tmpfs   defaults        0      0
EOF
echo "Creatin /etc/profile..."
cat > ${MLFS_PROFILE}/etc/profile << "EOF"
export PATH=/bin:/usr/bin

if [ `id -u` -eq 0 ] ; then
        PATH=/bin:/sbin:/usr/bin:/usr/sbin
        unset HISTFILE
fi


# Set up some environment variables.
export USER=`id -un`
export LOGNAME=$USER
export HOSTNAME=`/bin/hostname`
export HISTSIZE=1000
export HISTFILESIZE=1000
export PAGER='/bin/more '
export EDITOR='/bin/vi'
EOF
echo "Enter username for MLFS"
read username
echo "Creating /etc/HOSTNAME..."
echo $username > ${MLFS_ROOT}/etc/HOSTNAME 
echo "Creating /etc/issue.."
cat > ${MLFS_ROOT}/etc/issue<< "EOF"
Minimal Linux From Scratch (Linux \r)

EOF
echo "Creating /etc/inittab"
cat > ${MLFS_ROOT}/etc/inittab<< "EOF"
::sysinit:/etc/rc.d/startup

tty1::respawn:/sbin/getty 38400 tty1
tty2::respawn:/sbin/getty 38400 tty2
tty3::respawn:/sbin/getty 38400 tty3
tty4::respawn:/sbin/getty 38400 tty4
tty5::respawn:/sbin/getty 38400 tty5
tty6::respawn:/sbin/getty 38400 tty6

::shutdown:/etc/rc.d/shutdown
::ctrlaltdel:/sbin/reboot
EOF

