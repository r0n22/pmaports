if test ${mmc_bootdev} -eq 0 ; then
	echo "Booting from SD";
	setenv bootdev 0;
else
	echo "Booting from eMMC";
	setenv bootdev 2;
fi;


setenv bootargs init=/init.sh rw console=tty0 console=ttyS0,115200 no_console_suspend earlycon=uart,mmio32,0x01c28000 panic=10 consoleblank=0 loglevel=1 cma=256M fbcon=rotate:1 PMOS_NO_OUTPUT_REDIRECT pmos_boot=/dev/mmcblk${bootdev}p1 pmos_root=/dev/mmcblk${bootdev}p2


printenv

echo Loading DTB
load mmc ${mmc_bootdev}:1 ${fdt_addr_r} ${pinetabfdt}

echo Loading Initramfs
load mmc ${mmc_bootdev}:1 ${ramdisk_addr_r} uInitrd-postmarketos-allwinner

echo Loading Kernel
load mmc ${mmc_bootdev}:1 ${kernel_addr_r} vmlinuz-postmarketos-allwinner

echo Resizing FDT
fdt addr ${fdt_addr_r}
fdt resize

echo Booting kernel
booti ${kernel_addr_r} ${ramdisk_addr_r} ${fdt_addr_r}
