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

function kernel_header() {
	# Kernel Headers
	echo "Installing kernel headers..."

	echo "Extracting linux source, please wait"
	tar -xf sources/linux-4.16.3.tar.xz
	echo "Done"

	cd linux-4.16.3
	make ARCH=${T_ARCH} headers_check && make ARCH=${T_ARCH} INSTALL_HDR_PATH=dest headers_install
	cp -r dest/include/* ${TLFS_ROOT}/usr/include
	# End of Kernel headers

	cd ..
}

function binutils() {
	# Binutils
	echo "Compiling binutils"

	echo "Extracting binutils, please wait..."
	tar -xf sources/binutils-2.30.tar.xz

	mkdir binutils-build
	cd binutils-build

	../binutils-2.30/configure --prefix=${TLFS_ROOT}/xtools --target=${T_TARGET} --with-sysroot=${TLFS_ROOT} --disable-nls --enable-shared --disable-multilib
	make configure-host && make
	ln -sv lib ${TLFS_ROOT}/xtools/lib64
	make install
	cp -v ../binutils-2.30/include/libiberty.h ${TLFS_ROOT}/usr/include

	echo "Done"
	# End of binutils

	cd ..
}

function gcc_static() {
	# GCC Static
	echo "Compiling GCC (statc)"

	echo "Extracting GCC, please wait..."
	tar -xf sources/gcc-7.3.0.tar.xz
	tar -xf sources/gmp-6.1.2.tar.bz2
	tar -xf sources/mpfr-4.0.1.tar.xz
	tar -xf sources/mpc-1.1.0.tar.gz
	mv gmp-6.1.2 gcc-7.3.0/gmp
	mv mpfr-4.0.1 gcc-7.3.0/mpfr 
	mv mpc-1.1.0 gcc-7.3.0/mpc 

	mkdir gcc-static
	cd gcc-static

	AR=ar LDFLAGS="-Wl,-rpath,${TLFS_ROOT}/xtools/lib" \
	../gcc-7.3.0/configure --prefix=${TLFS_ROOT}/xtools \
	--build=${T_HOST} --host=${T_HOST} \
	--target=${T_TARGET} \
	--with-sysroot=${TLFS_ROOT}/target --disable-nls \
	--disable-shared \
	--with-mpfr-include=$(pwd)/../gcc-7.3.0/mpfr/src \
	--with-mpfr-lib=$(pwd)/mpfr/src/.libs \
	--without-headers --with-newlib --disable-decimal-float \
	--disable-libgomp --disable-libmudflap --disable-libssp \
	--disable-threads --enable-languages=c,c++ \
	--disable-multilib --with-arch=${T_CPU}
	make all-gcc all-target-libgcc && make install-gcc install-target-libgcc
	ln -vs libgcc.a `${T_TARGET}-gcc -print-libgcc-file-name | sed 's/libgcc/&_eh/'`

	# End of Gcc static

	cd ..
}

function glibc() {
	# Glibc
	echo "Compiling Glibc"
	echo "Extracting glib, please wait..."

	tar -xf sources/glibc-2.27.tar.xz

	mkdir glibc-build
	cd glibc-build

	echo "libc_cv_forced_unwind=yes" > config.cache
	echo "libc_cv_c_cleanup=yes" >> config.cache
	echo "libc_cv_ssp=no" >> config.cache
	echo "libc_cv_ssp_strong=no" >> config.cache

	BUILD_CC="gcc" CC="${T_TARGET}-gcc" AR="${T_TARGET}-ar" \
	RANLIB="${T_TARGET}-ranlib" CFLAGS="-O2" ../glibc-2.27/configure --prefix=/usr --host=${T_TARGET} --build=${T_HOST} --disable-profile --enable-add-ons --with-tls --enable-kernel=2.6.32 --with-__thread --with-binutils=${TLFS_ROOT}/xtools/bin --with-headers=${TLFS_ROOT}/usr/include --cache-file=config.cache

	make && make install_root=${TLFS_ROOT}/ install

	# End of Glibc

	cd ..
}

function gcc_final() {
	# GCC (Final)
	mkdir gcc-build
	cd gcc-build

	AR=ar LDFLAGS="-Wl,-rpath,${TLFS_ROOT}/xtools/lib" \
	../gcc-7.3.0/configure --prefix=${TLFS_ROOT}/xtools \
	--build=${T_HOST} --target=${T_TARGET} \
	--host=${T_HOST} --with-sysroot=${TLFS_ROOT} \
	--disable-nls --enable-shared \
	--enable-languages=c,c++ --enable-c99 \
	--enable-long-long \
	--with-mpfr-include=$(pwd)/../gcc-7.3.0/mpfr/src \
	--with-mpfr-lib=$(pwd)/mpfr/src/.libs \
	--disable-multilib --with-arch=${T_CPU}
	make && make install
	cp -v ${TLFS_ROOT}/xtools/${T_TARGET}/lib64/libgcc_s.so.1 ${TLFS_ROOT}/lib64
}

kernel_header
binutils
gcc_static
glibc
gcc_final

echo "Setting up cross compiler"

export CC="${T_TARGET}-gcc"
export CXX="${T_TARGET}-g++"
export CPP="${T_TARGET}-gcc -E"
export AR="${T_TARGET}-ar"
export AS="${T_TARGET}-as"
export LD="${T_TARGET}-ld"
export RANLIB="${T_TARGET}-ranlib"
export READELF="${T_TARGET}-readelf"
export STRIP="${T_TARGET}-strip" 

echo "Removing unnecessary files"

cd ..
rm -rf gcc-7.3.0
rm -rf gcc-static
rm -rf gcc-final
rm -rf glibc-2.27
rm -rf binutils-2.30
