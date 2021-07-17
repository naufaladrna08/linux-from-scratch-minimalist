#!/bin/bash

# Creating source folder
echo "Creating source folder"
mkdir -v sources
# Binutils 2.30
echo "Downloading Binutils"
wget https://ftp.gnu.org/gnu/binutils/binutils-2.30.tar.xz -P sources

# Busybox 1.28.3
echo "Downloading Busybox"
wget https://www.busybox.net/downloads/busybox-1.28.3.tar.bz2 -P sources

# CLFS Embedded Bootscript
echo "Downloading CLFS Embedded Bootscript"
wget http://ftp.osuosl.org/pub/clfs/conglomeration/clfs-embedded-bootscripts/clfs-embedded-bootscripts-1.0-pre5.tar.bz2 -P sources

# GCC 7.3.0
echo "Downloading GCC"
wget https://ftp.gnu.org/gnu/gcc/gcc-7.3.0/gcc-7.3.0.tar.xz -P sources

# GlibC 2.27, MPFR, MPC, GMP
echo "Downloading C Library"
wget https://ftp.gnu.org/gnu/glibc/glibc-2.27.tar.xz -P sources
wget https://ftp.gnu.org/gnu/gmp/gmp-6.1.2.tar.bz2 -P sources
wget https://ftp.gnu.org/gnu/mpc/mpc-1.1.0.tar.gz -P sources
wget https://ftp.gnu.org/gnu/mpfr/mpfr-4.0.1.tar.xz -P sources

# Linux Source 4.16.3
echo "Downloading Linux Source"
wget https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-4.16.3.tar.xz -P sources

# Zlib 
echo "Downloading Zlib"
wget https://zlib.net/fossils/zlib-1.2.11.tar.gz -P sources

echo "Done"
