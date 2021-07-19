#!/bin/bash

echo "[Configuration Files]"

# Getting TLFS Root Directory from File
TLFS_ROOT=`cat root`

# Create /etc/passwd
function passwd() {
  echo "Creating /etc/passwd..."

  echo "root::0:0:root:/root:/bin/ash" > ${TLFS_ROOT}/etc/passwd
}

function group() {
  echo "Creating /etc/group..."

  echo "root:x:0:" > ${TLFS_ROOT}/etc/group
  echo "bin:x:1:" > ${TLFS_ROOT}/etc/group
  echo "sys:x:2:" > ${TLFS_ROOT}/etc/group
  echo "kmem:x:3:" > ${TLFS_ROOT}/etc/group
  echo "tty:x:4:" > ${TLFS_ROOT}/etc/group
  echo "daemon:x:6:" > ${TLFS_ROOT}/etc/group
  echo "disk:x:8:" > ${TLFS_ROOT}/etc/group
  echo "dialout:x:10:" > ${TLFS_ROOT}/etc/group
  echo "video:x:12:" > ${TLFS_ROOT}/etc/group
  echo "utmp:x:13:" > ${TLFS_ROOT}/etc/group
  echo "usb:x:14:" > ${TLFS_ROOT}/etc/group
}

function fstab() {
  echo "Creating /etc/fstab..."

  echo "# file system  mount-point  type   options          dump  fsck "  >> ${TLFS_ROOT}/etc/fstab
  echo "#                                                         order"  >> ${TLFS_ROOT}/etc/fstab
  echo ""                                                                 >> ${TLFS_ROOT}/etc/fstab
  echo "rootfs          /               auto    defaults        1      1" >> ${TLFS_ROOT}/etc/fstab
  echo "proc            /proc           proc    defaults        0      0" >> ${TLFS_ROOT}/etc/fstab
  echo "sysfs           /sys            sysfs   defaults        0      0" >> ${TLFS_ROOT}/etc/fstab
  echo "devpts          /dev/pts        devpts  gid=4,mode=620  0      0" >> ${TLFS_ROOT}/etc/fstab
  echo "tmpfs           /dev/shm        tmpfs   defaults        0      0" >> ${TLFS_ROOT}/etc/fstab
}

function profile() {
  echo "Creatin /etc/profile..."
  
  echo "export PATH=/bin:/usr/bin"                  >> ${TLFS_ROOT}/etc/profile

  echo "if [ \`id -u\` -eq 0 ] ; then"              >> ${TLFS_ROOT}/etc/profile
  echo "        PATH=/bin:/sbin:/usr/bin:/usr/sbin" >> ${TLFS_ROOT}/etc/profile
  echo "        unset HISTFILE"                     >> ${TLFS_ROOT}/etc/profile
  echo "fi"                                         >> ${TLFS_ROOT}/etc/profile
  echo ""                                           >> ${TLFS_ROOT}/etc/profile 
  echo "# Set up some environment variables."       >> ${TLFS_ROOT}/etc/profile
  echo "export USER=\`id -un\`"                     >> ${TLFS_ROOT}/etc/profile
  echo "export LOGNAME=\$USER"                      >> ${TLFS_ROOT}/etc/profile
  echo "export HOSTNAME=\`/bin/hostname\`"          >> ${TLFS_ROOT}/etc/profile
  echo "export HISTSIZE=1000"                       >> ${TLFS_ROOT}/etc/profile
  echo "export HISTFILESIZE=1000"                   >> ${TLFS_ROOT}/etc/profile
  echo "export PAGER='/bin/more '"                  >> ${TLFS_ROOT}/etc/profile
  echo "export EDITOR='/bin/vi'"                    >> ${TLFS_ROOT}/etc/profile
}

function hostname() {
  echo "Enter username for TLFS"

  read username
  echo "Creating /etc/HOSTNAME..."
  echo $username > ${TLFS_ROOT}/etc/HOSTNAME 
}

function issue() {
  echo "Creating /etc/issue.."
  
  echo "Tiny Linux From Scratch (Linux \r)" >> ${TLFS_ROOT}/etc/issue
}

function inittab() {
  echo "Creating /etc/inittab"
  
  echo "::sysinit:/etc/rc.d/startup"          >> ${TLFS_ROOT}/etc/inittab
  echo ""                                     >> ${TLFS_ROOT}/etc/inittab
  echo "tty1::respawn:/sbin/getty 38400 tty1" >> ${TLFS_ROOT}/etc/inittab 
  echo "tty2::respawn:/sbin/getty 38400 tty2" >> ${TLFS_ROOT}/etc/inittab
  echo "tty3::respawn:/sbin/getty 38400 tty3" >> ${TLFS_ROOT}/etc/inittab
  echo "tty4::respawn:/sbin/getty 38400 tty4" >> ${TLFS_ROOT}/etc/inittab
  echo "tty5::respawn:/sbin/getty 38400 tty5" >> ${TLFS_ROOT}/etc/inittab
  echo "tty6::respawn:/sbin/getty 38400 tty6" >> ${TLFS_ROOT}/etc/inittab
  echo ""                                     >> ${TLFS_ROOT}/etc/inittab
  echo "::shutdown:/etc/rc.d/shutdown"        >> ${TLFS_ROOT}/etc/inittab
  echo "::ctrlaltdel:/sbin/reboot"            >> ${TLFS_ROOT}/etc/inittab
}

function mdev() {
  echo "Creating /etc/mdev.conf..."

  echo "# Devices:" >> ${TLFS_ROOT}/etc/mdev.conf
  echo "# Syntax: %s %d:%d %s" >> ${TLFS_ROOT}/etc/mdev.conf
  echo "# devices user:group mode" >> ${TLFS_ROOT}/etc/mdev.conf
  echo "" >> ${TLFS_ROOT}/etc/mdev.conf
  echo "# null does already exist; therefore ownership has to" >> ${TLFS_ROOT}/etc/mdev.conf
  echo "# be changed with command" >> ${TLFS_ROOT}/etc/mdev.conf
  echo "null    root:root 0666  @chmod 666 \$MDEV" >> ${TLFS_ROOT}/etc/mdev.conf
  echo "zero    root:root 0666" >> ${TLFS_ROOT}/etc/mdev.conf
  echo "grsec   root:root 0660" >> ${TLFS_ROOT}/etc/mdev.conf
  echo "full    root:root 0666" >> ${TLFS_ROOT}/etc/mdev.conf
  echo "" >> ${TLFS_ROOT}/etc/mdev.conf
  echo "random  root:root 0666" >> ${TLFS_ROOT}/etc/mdev.conf
  echo "urandom root:root 0444" >> ${TLFS_ROOT}/etc/mdev.conf
  echo "hwrandom root:root 0660" >> ${TLFS_ROOT}/etc/mdev.conf
  echo "" >> ${TLFS_ROOT}/etc/mdev.conf
  echo "# console does already exist; therefore ownership has to" >> ${TLFS_ROOT}/etc/mdev.conf
  echo "# be changed with command" >> ${TLFS_ROOT}/etc/mdev.conf
  echo "console root:tty 0600 @mkdir -pm 755 fd && cd fd && for x in 0 1 2 3 ; do ln -sf /proc/self/fd/$x $x; done" >> ${TLFS_ROOT}/etc/mdev.conf
  echo "" >> ${TLFS_ROOT}/etc/mdev.conf
  echo "kmem    root:root 0640" >> ${TLFS_ROOT}/etc/mdev.conf
  echo "mem     root:root 0640" >> ${TLFS_ROOT}/etc/mdev.conf
  echo "port    root:root 0640" >> ${TLFS_ROOT}/etc/mdev.conf
  echo "ptmx    root:tty 0666" >> ${TLFS_ROOT}/etc/mdev.conf
  echo "" >> ${TLFS_ROOT}/etc/mdev.conf
  echo "# ram.*" >> ${TLFS_ROOT}/etc/mdev.conf
  echo "ram([0-9]*)     root:disk 0660 >rd/%1" >> ${TLFS_ROOT}/etc/mdev.conf
  echo "loop([0-9]+)    root:disk 0660 >loop/%1" >> ${TLFS_ROOT}/etc/mdev.conf
  echo "sd[a-z].*       root:disk 0660 */lib/mdev/usbdisk_link" >> ${TLFS_ROOT}/etc/mdev.conf
  echo "hd[a-z][0-9]*   root:disk 0660 */lib/mdev/ide_links" >> ${TLFS_ROOT}/etc/mdev.conf
  echo "" >> ${TLFS_ROOT}/etc/mdev.conf
  echo "tty             root:tty 0666" >> ${TLFS_ROOT}/etc/mdev.conf
  echo "tty[0-9]        root:root 0600" >> ${TLFS_ROOT}/etc/mdev.conf
  echo "tty[0-9][0-9]   root:tty 0660" >> ${TLFS_ROOT}/etc/mdev.conf
  echo "ttyO[0-9]*      root:tty 0660" >> ${TLFS_ROOT}/etc/mdev.conf >> ${TLFS_ROOT}/etc/mdev.conf
  echo "pty.*           root:tty 0660" >> ${TLFS_ROOT}/etc/mdev.conf
  echo "vcs[0-9]*       root:tty 0660" >> ${TLFS_ROOT}/etc/mdev.conf
  echo "vcsa[0-9]*      root:tty 0660" >> ${TLFS_ROOT}/etc/mdev.conf
  echo "" >> ${TLFS_ROOT}/etc/mdev.conf
  echo "ttyLTM[0-9]     root:dialout 0660 @ln -sf \$MDEV modem" >> ${TLFS_ROOT}/etc/mdev.conf
  echo "ttySHSF[0-9]    root:dialout 0660 @ln -sf \$MDEV modem" >> ${TLFS_ROOT}/etc/mdev.conf
  echo "slamr           root:dialout 0660 @ln -sf \$MDEV slamr0" >> ${TLFS_ROOT}/etc/mdev.conf
  echo "slusb           root:dialout 0660 @ln -sf \$MDEV slusb0" >> ${TLFS_ROOT}/etc/mdev.conf
  echo "fuse            root:root  0666" >> ${TLFS_ROOT}/etc/mdev.conf
  echo "" >> ${TLFS_ROOT}/etc/mdev.conf
  echo "# misc stuff" >> ${TLFS_ROOT}/etc/mdev.conf
  echo "agpgart         root:root 0660  >misc/" >> ${TLFS_ROOT}/etc/mdev.conf
  echo "psaux           root:root 0660  >misc/" >> ${TLFS_ROOT}/etc/mdev.conf
  echo "rtc             root:root 0664  >misc/" >> ${TLFS_ROOT}/etc/mdev.conf
  echo "" >> ${TLFS_ROOT}/etc/mdev.conf
  echo "# input stuff" >> ${TLFS_ROOT}/etc/mdev.conf
  echo "event[0-9]+     root:root 0640 =input/" >> ${TLFS_ROOT}/etc/mdev.conf
  echo "ts[0-9]         root:root 0600 =input/" >> ${TLFS_ROOT}/etc/mdev.conf
  echo "" >> ${TLFS_ROOT}/etc/mdev.conf
  echo "# v4l stuff" >> ${TLFS_ROOT}/etc/mdev.conf
  echo "vbi[0-9]        root:video 0660 >v4l/" >> ${TLFS_ROOT}/etc/mdev.conf
  echo "video[0-9]      root:video 0660 >v4l/" >> ${TLFS_ROOT}/etc/mdev.conf
  echo "" >> ${TLFS_ROOT}/etc/mdev.conf
  echo "# load drivers for usb devices" >> ${TLFS_ROOT}/etc/mdev.conf
  echo "usbdev[0-9].[0-9]       root:root 0660 */lib/mdev/usbdev" >> ${TLFS_ROOT}/etc/mdev.conf
  echo "usbdev[0-9].[0-9]_.*    root:root 0660" >> ${TLFS_ROOT}/etc/mdev.conf
}

function grub() {
  echo "Creating GRUB configuration"

  echo "set default=0"                                          >> ${TLFS_ROOT}/boot/grub/grub.cfg
  echo "set timeout=5"                                          >> ${TLFS_ROOT}/boot/grub/grub.cfg
  echo ""                                                       >> ${TLFS_ROOT}/boot/grub/grub.cfg
  echo "set root=(hd0,1)"                                       >> ${TLFS_ROOT}/boot/grub/grub.cfg
  echo ""                                                       >> ${TLFS_ROOT}/boot/grub/grub.cfg
  echo "menuentry \"TLFS\" {"                                   >> ${TLFS_ROOT}/boot/grub/grub.cfg
  echo "  linux   /boot/vmlinuz-4.16.3 root=/dev/sda1 ro quiet" >> ${TLFS_ROOT}/boot/grub/grub.cfg
  echo "}"                                                      >> ${TLFS_ROOT}/boot/grub/grub.cfg
}

# Creating Files
passwd
group
fstab
profile
hostname
issue
inittab
mdev
grub

echo "Give permissions"
touch ${TLFS_ROOT}/var/run/utmp ${TLFS_ROOT}/var/log/{btmp,lastlog,wtmp}
chmod -v 664 ${TLFS_ROOT}/var/run/utmp ${TLFS_ROOT}/var/log/lastlog

echo "Done"
