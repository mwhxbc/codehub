#flash_sdcard.sh is used to flash spl.bin and uboot.bin to sdcard.
#But you should check which /dev/sdX sdcard creat by "sudo fdisk -l".
#example:
#    ./flash_sdcard.sh uboot  ==========>it will flash uboot-spl and uboot to sdcard
#	 ./flash_sdcard.sh kernel  ===========>it will flash kernel and dtb to sdcard
#    ./flash_sdcard.sh rootfs   ===========>it will flash rootfs to sdcard
#    ./flash_sdcard.sh fit_image   ===========>it will flash fit_image to sdcard

BUILD_DIR=../../../build
OUT_UBOOT_DIR=$BUILD_DIR/out/u-boot
OUT_KERNEL_DIR=$BUILD_DIR/out/linux
OUT_ROOTFS_DIR=$BUILD_DIR/out/rootfs


SEC_UBOOT_SPL_START=1
SEC_UBOOT_SPL_LEN=48 #uboot-spl.bin 29KB
let SEC_UBOOT_START=SEC_UBOOT_SPL_START+SEC_UBOOT_SPL_LEN
SEC_UBOOT_LEN=1024   #uboot.bin 512KB
let SEC_UIMAGE_START=SEC_UBOOT_START+SEC_UBOOT_LEN
SEC_UIMAGE_LEN=4096  #uImage 2MB
let SEC_DTB_START=SEC_UIMAGE_START+SEC_UIMAGE_LEN
SEC_DTB_LEN=128		 #dtb 64KB
let SEC_ROOTFS_START=SEC_DTB_START+SEC_DTB_LEN
SEC_ROOTFS_LEN=8192  #rootfs 4MB
let SEC_FIT_IMAGE_START=SEC_ROOTFS_START+SEC_ROOTFS_LEN
SEC_FIT_IMAGE_LEN=40960 #fit_image 20MB

echo SEC_UBOOT_SPL_START=$SEC_UBOOT_SPL_START
echo SEC_UBOOT_START=$SEC_UBOOT_START
echo SEC_UIMAGE_START=$SEC_UIMAGE_START
echo SEC_DTB_START=$SEC_DTB_START
echo SEC_ROOTFS_START=$SEC_ROOTFS_START

#In there, sdcard creat /dev/sdb, so dd bin file to /dev/sdb
if [ "$1" = "uboot" ];then
sudo dd iflag=dsync oflag=dsync if=$OUT_UBOOT_DIR/spl/tiny210-spl.bin of=/dev/sdb seek=$SEC_UBOOT_SPL_START
sudo dd iflag=dsync oflag=dsync if=$OUT_UBOOT_DIR/u-boot.bin of=/dev/sdb  seek=$SEC_UBOOT_START
fi

if [ "$1" = "kernel" ];then
sudo dd iflag=dsync oflag=dsync if=$OUT_KERNEL_DIR/arch/arm/boot/uImage of=/dev/sdb  seek=$SEC_UIMAGE_START
sudo dd iflag=dsync oflag=dsync if=$OUT_KERNEL_DIR/arch/arm/boot/dts/s5pv210-tiny210.dtb of=/dev/sdb  seek=$SEC_DTB_START
fi

if [ "$1" = "rootfs" ];then
sudo dd iflag=dsync oflag=dsync if=$OUT_ROOTFS_DIR/ramdisk.img of=/dev/sdb  seek=$SEC_ROOTFS_START
fi

if [ "$1" = "fit_image" ];then
sudo dd iflag=dsync oflag=dsync if=$BUILD_DIR/out/xprj_uImage_tiny210.itb of=/dev/sdb  seek=$SEC_FIT_IMAGE_START
fi
