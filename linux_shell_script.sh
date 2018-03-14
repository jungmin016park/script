/*
*/


#!/bin/sh

TOP=${PWD}
TBD_PLATFORM_VER="t186ref"

echo "TOP : ${TOP}"
echo "TBD_PLATFORM_VER : ${TBD_PLATFORM_VER}"

echo "Check directory....."

if [ ! -d ./hardware/ ];
then
	echo "Error : hardware directory is not exist!!!"
	exit
fi

if [ ! -d ./toolchains/ ];
then
	echo "Error : toolchains directory is not exist!!!"
	exit
fi

if [ ! -d ./drive-oss-src/ ];
then
	echo "Error : drive-oss-src directory is not exist!!!"
	exit
fi

if [ ! -d ./drive-t186ref-foundation/ ];
then
	echo "Error : drive-t186ref-foundation directory is not exist!!!"
	exit
fi

if [ ! -d ./drive-t186ref-foundation_src/ ];
then
	echo "Error : drive-t186ref-foundation_src directory is not exist!!!"
	exit
fi

if [ ! -d ./drive-t186ref-linux/ ];
then
	echo "Error : drive-t186ref-linux directory is not exist!!!"
	exit
fi

if [ ! -d ./drive-t186ref-linux_src/ ];
then
	echo "Error : drive-t186ref-linux_src directory is not exist!!!"
	exit
fi

echo "pass check directory"
echo
echo

echo "Start build platform"
echo "   1. All compile"

echo "   2. Compiling the kernel"

echo "   3. Compiling the ebp kernel"

echo "   4. Compiling the Flashing kernel"

echo "   5. Compiling BPMP FW"

echo "   6. Compiling PCT"



replace_cfg()
{
    export PDK_TOP=~/work/pdk

        sed -i -e 's/<PDK_TOP>/\/home\/jm\/work\/pdk/g' drive-t186ref-foundation/pct/mpi6g02/linux-ebp-ohara-gfx/global_storage.cfg
        sed -i -e 's/<PDK_TOP>/\/home\/jm\/work\/pdk/g' drive-t186ref-foundation/pct/mpi6g02/linux-ebp-ohara-gfx/linux1_efs_storage.cfg
        sed -i -e 's/<PDK_TOP>/\/home\/jm\/work\/pdk/g' drive-t186ref-foundation/pct/mpi6g02/linux-ebp-ohara-gfx/linux1_storage.cfg
        sed -i -e 's/<PDK_TOP>/\/home\/jm\/work\/pdk/g' drive-t186ref-foundation/pct/mpi6g02/linux-ebp-ohara-gfx/linux2_storage.cfg
        sed -i -e 's/<PDK_TOP>/\/home\/jm\/work\/pdk/g' drive-t186ref-foundation/utils/flash/t18x/quickboot_flashing.cfg

        ln -s $PDK_TOP $PDK_TOP/drive-t186ref-linux_src/yocto/pdk
}


setup_environment()
{
	echo "Setup environment variable....."

	echo "export ARCH=arm64"

	export ARCH=arm64

	echo "export CROSS_COMPILE=${TOP}/toolchains/tegra-4.9-nv/usr/bin/aarch64-gnu-linux/aarch64-gnu-linux-"

	export CROSS_COMPILE=${TOP}/toolchains/tegra-4.9-nv/usr/bin/aarch64-gnu-linux/aarch64-gnu-linux-

	echo "export CROSS32CC=${TOP}/toolchains/gcc-arm-none-eabi-4_8-2014q3/bin/arm-none-eabi-gcc"

	export CROSS32CC=${TOP}/toolchains/gcc-arm-none-eabi-4_8-2014q3/bin/arm-none-eabi-gcc

	echo 'export LOCALVERSION="-tegra"'

	export LOCALVERSION="-tegra"

	#replace_cfg
}

echo -n "Choose number:"

read build_type

if [ -z "$build_type" ];
then
	echo "You should select number!!"
	exit
else
	if [ "$build_type" -le 0 ] || [ "$build_type" -gt 6 ];
	then
		echo "You should enter number correctly!!!"
		exit
	else
		setup_environment
	fi
fi

build_kernel()
{
	echo "build kernel....."

	echo "cd ${TOP}/drive-oss-src"

	cd ${TOP}/drive-oss-src

	echo "mkdir out-${TBD_PLATFORM_VER}-linux"

	mkdir out-${TBD_PLATFORM_VER}-linux

if [ "$1" = "clean" ]
then
	echo "make -C kernel O=${PWD}/out-${TBD_PLATFORM_VER}-linux clean"
	make -C kernel O=${PWD}/out-${TBD_PLATFORM_VER}-linux clean
fi

	echo "make -C kernel O=${PWD}/out-${TBD_PLATFORM_VER}-linux tegra_${TBD_PLATFORM_VER}_gnu_linux_defconfig"

	make -C kernel O=${PWD}/out-${TBD_PLATFORM_VER}-linux tegra_${TBD_PLATFORM_VER}_gnu_linux_defconfig

	echo "make -j3 -C kernel O=${PWD}/out-${TBD_PLATFORM_VER}-linux"

	make -j3 -C kernel O=${PWD}/out-${TBD_PLATFORM_VER}-linux

	echo "cp ${PWD}/out-${TBD_PLATFORM_VER}-linux/arch/arm64/boot/zImage ${TOP}/drive-${TBD_PLATFORM_VER}-linux/kernel"

	cp ${PWD}/out-${TBD_PLATFORM_VER}-linux/arch/arm64/boot/zImage ${TOP}/drive-${TBD_PLATFORM_VER}-linux/kernel

	echo "cp ${PWD}/out-${TBD_PLATFORM_VER}-linux/arch/arm64/boot/Image ${TOP}/drive-${TBD_PLATFORM_VER}-linux/kernel"

	cp ${PWD}/out-${TBD_PLATFORM_VER}-linux/arch/arm64/boot/Image ${TOP}/drive-${TBD_PLATFORM_VER}-linux/kernel

	echo "export INSTALL_MOD_PATH=${PWD}/out-${TBD_PLATFORM_VER}-linux"

	export INSTALL_MOD_PATH=${PWD}/out-${TBD_PLATFORM_VER}-linux

	echo "make -C kernel O=${PWD}/out-<TBD_platform_ver>-linux modules_install"

	make -C kernel O=${PWD}/out-${TBD_PLATFORM_VER}-linux modules_install

	echo "sudo cp -a ${PWD}/out-${TBD_PLATFORM_VER}-linux/lib/modules/* ${TOP}/drive-${TBD_PLATFORM_VER}-linux/targetfs/lib/modules"

	sudo cp -a ${PWD}/out-${TBD_PLATFORM_VER}-linux/lib/modules/* ${TOP}/drive-${TBD_PLATFORM_VER}-linux/targetfs/lib/modules 

	echo "cp ${TOP}/drive-oss-src/out-${TBD_PLATFORM_VER}-linux/arch/arm64/boot/dts/*mpi6g01*.* ${TOP}/drive-${TBD_PLATFORM_VER}-linux/kernel"

	cp ${TOP}/drive-oss-src/out-${TBD_PLATFORM_VER}-linux/arch/arm64/boot/dts/*mpi6g01*.* ${TOP}/drive-${TBD_PLATFORM_VER}-linux/kernel
	
	echo "cp ${TOP}/drive-oss-src/out-${TBD_PLATFORM_VER}-linux/arch/arm64/boot/dts/*mpi6g02*.* ${TOP}/drive-${TBD_PLATFORM_VER}-linux/kernel"
	
	cp ${TOP}/drive-oss-src/out-${TBD_PLATFORM_VER}-linux/arch/arm64/boot/dts/*mpi6g02*.* ${TOP}/drive-${TBD_PLATFORM_VER}-linux/kernel

	cd -
}

build_ebp_kernel()
{

	echo "build ebp kernel....."

        echo "cd ${TOP}/drive-oss-src"

        cd ${TOP}/drive-oss-src

        echo "mkdir out-${TBD_PLATFORM_VER}-linuxi-ebp"

        mkdir out-${TBD_PLATFORM_VER}-linux-ebp

if [ "$1" = "clean" ]
then
        echo "make -C kernel O=${PWD}/out-${TBD_PLATFORM_VER}-linux-ebp clean"

        make -C kernel O=${PWD}/out-${TBD_PLATFORM_VER}-linux-ebp clean
fi

        echo "make -C kernel O=${PWD}/out-${TBD_PLATFORM_VER}-linux-ebp tegra_${TBD_PLATFORM_VER}_gnu_linux_early_boot_defconfig"

        make -C kernel O=${PWD}/out-${TBD_PLATFORM_VER}-linux-ebp tegra_${TBD_PLATFORM_VER}_gnu_linux_early_boot_defconfig

        echo "make -j3 -C kernel O=${PWD}/out-${TBD_PLATFORM_VER}-linux-ebp"

        make -j3 -C kernel O=${PWD}/out-${TBD_PLATFORM_VER}-linux-ebp

        echo "cp ${PWD}/out-${TBD_PLATFORM_VER}-linux-ebp/arch/arm64/boot/Image ${TOP}/drive-${TBD_PLATFORM_VER}-linux/kernel/Image.ebp"

        cp ${PWD}/out-${TBD_PLATFORM_VER}-linux-ebp/arch/arm64/boot/Image ${TOP}/drive-${TBD_PLATFORM_VER}-linux/kernel/Image.ebp

        echo "cp ${TOP}/drive-oss-src/out-${TBD_PLATFORM_VER}-linux-ebp/arch/arm64/boot/dts/*mpi6g01*.* ${TOP}/drive-${TBD_PLATFORM_VER}-linux/kernel"

        cp ${TOP}/drive-oss-src/out-${TBD_PLATFORM_VER}-linux-ebp/arch/arm64/boot/dts/*mpi6g01*.* ${TOP}/drive-${TBD_PLATFORM_VER}-linux/kernel

        echo "cp ${TOP}/drive-oss-src/out-${TBD_PLATFORM_VER}-linux-ebp/arch/arm64/boot/dts/*mpi6g02*.* ${TOP}/drive-${TBD_PLATFORM_VER}-linux/kernel"
        
	cp ${TOP}/drive-oss-src/out-${TBD_PLATFORM_VER}-linux-ebp/arch/arm64/boot/dts/*mpi6g02*.* ${TOP}/drive-${TBD_PLATFORM_VER}-linux/kernel

	cd -
}


build_flashing_kernel()
{
	echo "build flashing kernel....."

	echo "cd ${TOP}/drive-${TBD_PLATFORM_VER}-foundation_src/kernel"

	cd ${TOP}/drive-${TBD_PLATFORM_VER}-foundation_src/kernel

	if [ ! -d ./drive-oss-t186-flashing_kernel-src/ ];
	then
		tar xvf drive-oss-t186-flashing_kernel-src.tar.bz2
	fi

	echo "cd drive-oss-t186-flashing_kernel-src/drive-oss-src"

	cd drive-oss-t186-flashing_kernel-src/drive-oss-src

	echo "mkdir -p out-t186-linux/out"

	mkdir -p out-t186-linux/out

if [ "$1" = "clean" ]
then
	echo "make -C kernel O=${PWD}/out-t186-linux/out clean"

	make -C kernel O=${PWD}/out-t186-linux/out clean
fi

	echo "make -C kernel O=${PWD}/out-t186-linux/out tegra_t186ref_gnu_linux_defconfig"

	make -C kernel O=${PWD}/out-t186-linux/out tegra_t186ref_gnu_linux_defconfig

	echo "make -C kernel O=${PWD}/out-t186-linux/out -j4"

	make -C kernel O=${PWD}/out-t186-linux/out -j4

	echo "cp ${PWD}/out-t186-linux/out/arch/arm64/boot/Image ${TOP}/drive-${TBD_PLATFORM_VER}-foundation/utils/flash/t18x/rcmkernel"

	cp ${PWD}/out-t186-linux/out/arch/arm64/boot/Image ${TOP}/drive-${TBD_PLATFORM_VER}-foundation/utils/flash/t18x/rcmkernel

	echo "cp ${PWD}/out-t186-linux/out/arch/arm64/boot/dts/tegra186-vcm31-p2382-flashing-base.dtb ${TOP}/drive-${TBD_PLATFORM_VER}-foundation/utils/flash/t18x/rcmkernel"

	cp ${PWD}/out-t186-linux/out/arch/arm64/boot/dts/tegra186-vcm31-p2382-flashing-base.dtb ${TOP}/drive-${TBD_PLATFORM_VER}-foundation/utils/flash/t18x/rcmkernel
	cp ${PWD}/out-t186-linux/out/arch/arm64/boot/dts/tegra186-vcm31-p2382-flashing-base-mpi6g01.dtb ${TOP}/drive-${TBD_PLATFORM_VER}-foundation/utils/flash/t18x/rcmkernel
}

build_bpmp()
{
	echo "build bpmp fw....."

	echo "cd ${TOP}/drive-${TBD_PLATFORM_VER}-foundation/platform-support/bpmp_dtsi/"

	cd ${TOP}/drive-${TBD_PLATFORM_VER}-foundation/platform-support/bpmp_dtsi/

	echo "make"

	make
}

build_pct()
{
        echo "build bpmp fw....."

        echo "cd ${TOP}/drive-${TBD_PLATFORM_VER}-foundation"

        cd ${TOP}/drive-${TBD_PLATFORM_VER}-foundation

if [ "$1" = "clean" ]
then
    echo "make -f Makefile.bind PCT=linux-ebp-ohara-gfx clean"
	make -f Makefile.bind BOARD=mpi6g01 PCT=linux-ebp-ohara-gfx clean
	make -f Makefile.bind BOARD=mpi6g02 PCT=linux-ebp-ohara-gfx clean
fi
    echo "make -f Makefile.bind BOARD=mpi6g01 PCT=linux-ebp-ohara-gfx"
	make -f Makefile.bind BOARD=mpi6g01 PCT=linux-ebp-ohara-gfx
        
	echo "make -f Makefile.bind BOARD=mpi6g02 PCT=linux-ebp-ohara-gfx"
	
	make -f Makefile.bind BOARD=mpi6g02 PCT=linux-ebp-ohara-gfx

	cd -
}


if [ "$build_type" -eq 1 ] || [ "$build_type" -eq 2 ];
then
	build_kernel $@
fi

if [ "$build_type" -eq 1 ] || [ "$build_type" -eq 3 ];
then
    build_ebp_kernel $@
fi

if [ "$build_type" -eq 1 ] || [ "$build_type" -eq 4 ];
then
	build_flashing_kernel $@
fi

if [ "$build_type" -eq 1 ] || [ "$build_type" -eq 5 ];
then
	build_bpmp $@
fi

if [ "$build_type" -eq 6 ];
then
        build_pct $@
fi

