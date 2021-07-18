#!/bin/bash

TLFS_ROOT=`cat root`

echo "[ Target Image ]"
echo "Pastikan ini dijalankan setelah memiliki cross compiler"

# Setting up variables
echo "Setting up variables"
export T_HOST=$(echo ${MACHTYPE} | sed "s/-[^-]*/-cross/") 
export T_TARGET=x86_64-unkown-linux-gnu
export T_CPU=k8 
export T_ARCH=$(echo ${T_TARGET} | sed -e 's/-.*//' -e 's/i.86/i386/')
export T_ENDIAN=little

# BusyBox

echo "-> BusyBox"

echo "Extracting BusyBox, please wait..."
tar -xf sources/busybox-1.28.3.tar.bz2

echo "Compiling BusyBox. please wait"
cd busybox-1.28.3
make CROSS_COMPILE="${T_TARGET}-" defconfig
make CROSS_COMPILE="${T_TARGET}-"
make CROSS_COMPILE="${T_TARGET}-" CONFIG_PREFIX="${TLFS_ROOT}" install

cp -v examples/depmod.pl ${TLFS_ROOT}/xtools/bin
chmod 755 ${TLFS_ROOT}/xtools/bin/depmod.pl

# End of BusyBox

cd ..

# Linux Kernel

echo "-> Linux"

echo "Entering Linux directory, please wait..."
cd linux-4.16.3

echo "Compiling Linux with default config, please wait..."

make ARCH=${T_ARCH} CROSS_COMPILE=${T_TARGET}- x86_64_defconfig
make ARCH=${T_ARCH} CROSS_COMPILE=${T_TARGET}-
make ARCH=${T_ARCH} CROSS_COMPILE=${T_TARGET}- INSTALL_MOD_PATH=${TLFS_ROOT} modules_install

echo "Copying necessary files"

cp -v arch/x86/boot/bzImage ${TLFS_ROOT}/boot/vmlinuz-4.16.3
cp -v System.map ${TLFS_ROOT}/boot/System.map-4.16.3
cp -v .config ${TLFS_ROOT}/boot/config-4.16.3

${TLFS_ROOT}/xtools/bin/depmod.pl -F ${TLFS_ROOT}/boot/System.map-4.16.3 -b ${TLFS_ROOT}/lib/modules/4.16.3
