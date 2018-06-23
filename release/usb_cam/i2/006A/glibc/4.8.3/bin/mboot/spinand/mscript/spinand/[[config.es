# <- this is for comment / total file size must be less than 4KB
setenv bootcmd ' nand read.e 0x22000000 KERNEL 500000; bootm 0x22000000;nand read.e 0x22000000 RECOVERY 500000; bootm 0x22000000
setenv bootargs ' ubi.mtd=9,2048 root=ubi:SYSTEM rw rootfstype=ubifs init=/linuxrc rootwait=1 reserve_mem=36M LX_MEM=0x3C400000 EMAC_MEM=0x100000 mma_heap=mma_heap_name0,miu=0,sz=0xD200000
#setenv console=ttyS0,115200n8r androidboot.console=ttyS0 root=/dev/ram rootwait
saveenv

#setenv MS_RFS ubi.mtd=UBI root=ubi:RFS rootfstype=ubifs rw
#setenv bootargs console=ttyS0,115200 androidboot.console=ttyS0 init=/init $(MS_RFS) $(mtdparts) devcfg
#setenv bootargs console=ttyS0,115200n8r androidboot.console=ttyS0 init=/init
#setenv bootcmd ' nand read.e 0x21000000 KERNEL 300000; bootm 0x21000000;nand read.e 0x21000000 RECOVERY 300000; bootm 0x21000000
#setenv verify n
#saveenv

% <- this is end of file symbol
