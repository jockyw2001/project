TFTPDOWNLOADADDR:=0x20400000
KERNELBOOTADDR:=0x205FFFC0

TARGET_SCRIPT:=$(foreach n,$(IMAGE_LIST),$(n)_$(PAT_TABLE)_$($(n)$(FSTYPE))_script) $(PAT_TABLE)_partition_script $(PAT_TABLE)_config_script

TARGET_FS:=$(filter-out $(patsubst %_fs__,%,$(filter %_fs__, $(foreach n,$(IMAGE_LIST),$(n)_fs_$($(n)$(FSTYPE))_))), $(IMAGE_LIST))

SCRIPTDIR:=$(IMAGEDIR)/scripts

scripts:
	mkdir -p $(SCRIPTDIR) 
	$(MAKE) $(TARGET_SCRIPT)
	@echo mstar mboot/[[mboot > $(IMAGEDIR)/auto_update.txt
	@echo mstar scripts/set_partition >> $(IMAGEDIR)/auto_update.txt
	@echo -e $(foreach n,$(IMAGE_LIST),\\n#$(n)\\nmstar scripts/[[$(n)\\n) >> $(IMAGEDIR)/auto_update.txt
	@echo mstar scripts/set_config >> $(IMAGEDIR)/auto_update.txt
	@echo saveenv >> $(IMAGEDIR)/auto_update.txt
	@echo printenv >> $(IMAGEDIR)/auto_update.txt
	@echo reset >> $(IMAGEDIR)/auto_update.txt

%_ubi_ubifs_script:
	@echo ubi part UBI > $(SCRIPTDIR)/[[$(patsubst %_ubi_ubifs_script,%,$@)
	@echo tftp $(TFTPDOWNLOADADDR) $(patsubst %_ubi_ubifs_script,%,$@).ubifs >> $(SCRIPTDIR)/[[$(patsubst %_ubi_ubifs_script,%,$@)
	@echo ubi write $(TFTPDOWNLOADADDR) $(patsubst %_ubi_ubifs_script,%,$@) \$${filesize} >> $(SCRIPTDIR)/[[$(patsubst %_ubi_ubifs_script,%,$@)
	@echo setenv $(patsubst %_ubi_ubifs_script,%,$@)$(BOOTENV) $($(patsubst %_ubi_ubifs_script,%,$@)$(BOOTENV)) >> $(SCRIPTDIR)/[[$(patsubst %_ubi_ubifs_script,%,$@)

%_ubi__script:
	@echo tftp $(TFTPDOWNLOADADDR) $(patsubst %_ubi__script,%,$@) > $(SCRIPTDIR)/[[$(patsubst %_ubi__script,%,$@)
	@echo nand erase $(patsubst %_ubi__script,%,$@) >> $(SCRIPTDIR)/[[$(patsubst %_ubi__script,%,$@)
	@echo nand write.e $(TFTPDOWNLOADADDR) $(patsubst %_ubi__script,%,$@) \$${filesize} >> $(SCRIPTDIR)/[[$(patsubst %_ubi__script,%,$@)
	@echo setenv $(patsubst %_ubi__script,%,$@)$(BOOTENV) $($(patsubst %_ubi__script,%,$@)$(BOOTENV)) >> $(SCRIPTDIR)/[[$(patsubst %_ubi__script,%,$@)

%_spi_squashfs_script:

%_mmc_ext4_script:

kernel_spi__script:
	@echo tftp $(TFTPDOWNLOADADDR) kernel > $(SCRIPTDIR)/[[kernel
	@echo nand erase kernel >> $(SCRIPTDIR)/[[kernel
	@echo nand write.e $(TFTPDOWNLOADADDR) kernel \$${filesize} >> $(SCRIPTDIR)/[[kernel
	@echo setenv kernel_bootenv $(kernel$(BOOTENV)) >> $(SCRIPTDIR)/[[kernel
	@echo saveenv >> $(SCRIPTDIR)/[[kernel

rootfs_spi_squashfs_script:
	@echo tftp $(TFTPDOWNLOADADDR) rootfs.sqfs > $(SCRIPTDIR)/[[rootfs
	@echo nand erase rootfs >> $(SCRIPTDIR)/[[rootfs
	@echo nand write.e $(TFTPDOWNLOADADDR) rootfs \$${filesize} >> $(SCRIPTDIR)/[[rootfs
	@echo setenv rootfs_bootenv $(rootfs$(BOOTENV)) >> $(SCRIPTDIR)/[[rootfs
	@echo saveenv >> $(SCRIPTDIR)/[[rootfs

nvrservice_spi_squashfs_script:
	@echo tftp $(TFTPDOWNLOADADDR) nvrservice.sqfs > $(SCRIPTDIR)/[[nvrservice
	@echo nand erase nvrservice >> $(SCRIPTDIR)/[[nvrservice
	@echo nand write.e $(TFTPDOWNLOADADDR) nvrservice \$${filesize} >> $(SCRIPTDIR)/[[nvrservice
	@echo saveenv >> $(SCRIPTDIR)/[[nvrservice

nvrservice_spi_ubifs_script:
	@echo ubi part UBI > $(SCRIPTDIR)/[[nvrservice
	@echo tftp $(TFTPDOWNLOADADDR) nvrservice.ubifs >> $(SCRIPTDIR)/[[nvrservice
	@echo ubi write $(TFTPDOWNLOADADDR) nvrservice \$${filesize} >> $(SCRIPTDIR)/[[nvrservice
	@echo saveenv >> $(SCRIPTDIR)/[[nvrservice

vendor_spi_ubifs_script:
	@echo ubi part UBI > $(SCRIPTDIR)/[[vendor
	@echo tftp $(TFTPDOWNLOADADDR) vendor.ubifs >> $(SCRIPTDIR)/[[vendor
	@echo ubi write $(TFTPDOWNLOADADDR) vendor \$${filesize} >> $(SCRIPTDIR)/[[vendor
	@echo saveenv >> $(SCRIPTDIR)/[[vendor

customer_spi_ubifs_script:
	@echo ubi part UBI > $(SCRIPTDIR)/[[customer
	@echo tftp $(TFTPDOWNLOADADDR) customer.ubifs >> $(SCRIPTDIR)/[[customer
	@echo ubi write $(TFTPDOWNLOADADDR) customer \$${filesize} >> $(SCRIPTDIR)/[[customer
	@echo saveenv >> $(SCRIPTDIR)/[[customer


ubi_partition_script:
	@echo nand erase.chip > $(SCRIPTDIR)/set_partition
	@echo "dynpart edb64M-nand:$(kernel$(PATSIZE))(kernel),-(UBI)" >> $(SCRIPTDIR)/set_partition
	@echo ubi part UBI >> $(SCRIPTDIR)/set_partition
	@echo saveenv >> $(SCRIPTDIR)/set_partition
	@echo -e $(foreach n,$(TARGET_FS),\\n#$(n)\\nubi create $(n) $($(n)$(PATSIZE))\\n) >> $(SCRIPTDIR)/set_partition

ubi_config_script:
	@echo -e setenv bootcmd nand read.e $(KERNELBOOTADDR) kernel $(kernel$(PATSIZE))\\\; bootm $(KERNELBOOTADDR) > $(SCRIPTDIR)/set_config
	@echo setenv LOAD_KERNEL nand read.e $(KERNELBOOTADDR) kernel $(kernel$(PATSIZE))\\\; >> $(SCRIPTDIR)/set_config
	@echo -e setenv BOOT_KERNEL bootm $(KERNELBOOTADDR)\\\; >> $(SCRIPTDIR)/set_config
	@echo -e setenv bootargs console=ttyS0,115200 \$${mtdparts} $(foreach n,$(IMAGE_LIST),\$${$(n)$(BOOTENV)}) CORE_DUMP_PATH=/var/core_dump.%%e.%%p.gz $(EXBOOTARGS)  >> $(SCRIPTDIR)/set_config
	@echo setenv str_crc 1 >> $(SCRIPTDIR)/set_config
	@echo setenv sync_mmap 1 >> $(SCRIPTDIR)/set_config
	@echo setenv verify y >> $(SCRIPTDIR)/set_config
	@echo setenv customer_ini_path /config/model/Customer_1.ini >> $(SCRIPTDIR)/set_config
ifneq ($(KERNEL_MEMLEN2),)
	@echo setenv MIU0_GROUP_PRIORITY 1:0:2:3 >> $(SCRIPTDIR)/set_config
	@echo setenv MIU0_GROUP_SELMIU 0440:0000:0040:0000:0EF5:000F >> $(SCRIPTDIR)/set_config
	@echo setenv MIU1_GROUP_PRIORITY 1:0:2:3 >> $(SCRIPTDIR)/set_config
	@echo setenv MIU1_GROUP_SELMIU 73FE:677F:3A9F:00AC:4182:FFF0 >> $(SCRIPTDIR)/set_config
	@echo setenv MIU2_GROUP_PRIORITY 0:0:0:0 >> $(SCRIPTDIR)/set_config
	@echo setenv MIU2_GROUP_SELMIU 0000:0000:0000:0000:0000:0000 >> $(SCRIPTDIR)/set_config
else
	@echo setenv MIU0_GROUP_PRIORITY >> $(SCRIPTDIR)/set_config
	@echo setenv MIU0_GROUP_SELMIU >> $(SCRIPTDIR)/set_config
	@echo setenv MIU1_GROUP_PRIORITY >> $(SCRIPTDIR)/set_config
	@echo setenv MIU1_GROUP_SELMIU >> $(SCRIPTDIR)/set_config
	@echo setenv MIU2_GROUP_PRIORITY >> $(SCRIPTDIR)/set_config
	@echo setenv MIU2_GROUP_SELMIU >> $(SCRIPTDIR)/set_config
endif
	@echo setenv E_LX_MEM_ADR $(KERNEL_MEMADR) >> $(SCRIPTDIR)/set_config
	@echo setenv E_LX_MEM_LEN $(KERNEL_MENLEN) >> $(SCRIPTDIR)/set_config
	@echo setenv E_LX_MEM2_ADR $(KERNEL_MEMADR2) >> $(SCRIPTDIR)/set_config
	@echo setenv E_LX_MEM2_LEN $(KERNEL_MEMLEN2) >> $(SCRIPTDIR)/set_config
	@echo saveenv >> $(SCRIPTDIR)/set_config

spi_partition_script:
	@echo nand erase.chip > $(SCRIPTDIR)/set_partition
	@echo "dynpart edb64M-nand:$(kernel$(PATSIZE))(kernel),$(rootfs$(PATSIZE))(rootfs),-(UBI)" >> $(SCRIPTDIR)/set_partition
	@echo ubi part UBI >> $(SCRIPTDIR)/set_partition
	@echo saveenv >> $(SCRIPTDIR)/set_partition
	@echo ubi create nvrservice $(nvrservice$(PATSIZE)) >> $(SCRIPTDIR)/set_partition
	@echo ubi create vendor $(vendor$(PATSIZE)) >> $(SCRIPTDIR)/set_partition
	@echo ubi create customer $(customer$(PATSIZE)) >> $(SCRIPTDIR)/set_partition
	@echo saveenv >> $(SCRIPTDIR)/set_partition

spi_config_script:
	@echo -e setenv bootcmd nand read.e $(KERNELBOOTADDR) kernel $(kernel$(PATSIZE))\\\; bootm $(KERNELBOOTADDR) > $(SCRIPTDIR)/set_config
	@echo setenv LOAD_KERNEL nand read.e $(KERNELBOOTADDR) kernel $(kernel$(PATSIZE))\\\; >> $(SCRIPTDIR)/set_config
	@echo -e setenv BOOT_KERNEL bootm $(KERNELBOOTADDR)\\\; >> $(SCRIPTDIR)/set_config
	@echo -e setenv bootargs console=ttyS0,115200 \$${mtdparts} $(foreach n,$(IMAGE_LIST),\$${$(n)$(BOOTENV)}) CORE_DUMP_PATH=/var/core_dump.%%e.%%p.gz $(EXBOOTARGS)  >> $(SCRIPTDIR)/set_config
	@echo setenv str_crc 1 >> $(SCRIPTDIR)/set_config
	@echo setenv sync_mmap 1 >> $(SCRIPTDIR)/set_config
	@echo setenv verify y >> $(SCRIPTDIR)/set_config
	@echo setenv customer_ini_path /config/model/Customer_1.ini >> $(SCRIPTDIR)/set_config
ifneq ($(KERNEL_MEMLEN2),)
	@echo setenv MIU0_GROUP_PRIORITY 1:0:2:3 >> $(SCRIPTDIR)/set_config
	@echo setenv MIU0_GROUP_SELMIU 0440:0000:0040:0000:0EF5:000F >> $(SCRIPTDIR)/set_config
	@echo setenv MIU1_GROUP_PRIORITY 1:0:2:3 >> $(SCRIPTDIR)/set_config
	@echo setenv MIU1_GROUP_SELMIU 73FE:667F:2A9F:00AC:4182:FFF0 >> $(SCRIPTDIR)/set_config
	@echo setenv MIU2_GROUP_PRIORITY 0:0:0:0 >> $(SCRIPTDIR)/set_config
	@echo setenv MIU2_GROUP_SELMIU 0000:0000:0000:0000:0000:0000 >> $(SCRIPTDIR)/set_config
else
	@echo setenv MIU0_GROUP_PRIORITY >> $(SCRIPTDIR)/set_config
	@echo setenv MIU0_GROUP_SELMIU >> $(SCRIPTDIR)/set_config
	@echo setenv MIU1_GROUP_PRIORITY >> $(SCRIPTDIR)/set_config
	@echo setenv MIU1_GROUP_SELMIU >> $(SCRIPTDIR)/set_config
	@echo setenv MIU2_GROUP_PRIORITY >> $(SCRIPTDIR)/set_config
	@echo setenv MIU2_GROUP_SELMIU >> $(SCRIPTDIR)/set_config
endif
	@echo setenv E_LX_MEM_ADR $(KERNEL_MEMADR) >> $(SCRIPTDIR)/set_config
	@echo setenv E_LX_MEM_LEN $(KERNEL_MENLEN) >> $(SCRIPTDIR)/set_config
	@echo setenv E_LX_MEM2_ADR $(KERNEL_MEMADR2) >> $(SCRIPTDIR)/set_config
	@echo setenv E_LX_MEM2_LEN $(KERNEL_MEMLEN2) >> $(SCRIPTDIR)/set_config
	@echo saveenv >> $(SCRIPTDIR)/set_config

mmc_partition_script:

mmc_config_script:
