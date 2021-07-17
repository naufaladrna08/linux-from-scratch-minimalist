#!/bin/bash

TLFS_ROOT=`cat root`

# Konfirmasi
echo "| Cross Compiler adalah compiler yang mampu menciptakan kode   |"
echo "| yang eksekusi untuk platform lain dari yang di mana compiler |"
echo "| berjalan. Contohnya anda mengkompilasi program dengan cross  |"
echo "| compiler di Linux untuk Windows."

echo "Pastikan anda sudah menjalankan packages.sh"

# Unset C Flags
echo "Unsetting C Flags"
unset CXXFLAGS
unset CFLAGS

# Define host and target variables
export T_HOST=$(echo ${MACHTYPE} | sed "s/-[^-]*/-cross/") 
export T_TARGET=x86_64-unkown-linux-gnu
export T_CPU=k8 
export T_ARCH=$(echo ${T_TARGET} | sed -e 's/-.*//' -e 's/i.86/i386/')
export T_ENDIAN=little

# Kernel Headers
echo "Installing kernel headers..."

echo "Extracting linux source, please wait"
tar -xf sources/linux-4.16.3.tar.xz
echo "Done"

cd linux-4.16.3
make ARCH=${T_ARCH} headers_check && make ARCH=${T_ARCH} INSTALL_HDR_PATH=dest headers_install
cp -r dest/include/* ${TLFS_ROOT}/usr/include

