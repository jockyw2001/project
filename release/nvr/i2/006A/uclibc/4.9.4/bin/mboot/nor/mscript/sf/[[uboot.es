# <- this is for comment / total file size must be less than 4KB

mxp r.info UBOOT
sf probe 0
sf erase $(sf_part_start) $(sf_part_size)
tftp 0x21000000 u-boot.xz.img.bin
sf write 0x21000000 $(sf_part_start) $(filesize)

% <- this is end of file symbol
