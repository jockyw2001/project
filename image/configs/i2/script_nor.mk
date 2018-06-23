TFTPDOWNLOADADDR:=0x21000000
KERNELBOOTADDR:=0x22000000

TARGET_SCRIPT:=$(foreach n,$(IMAGE_LIST),$(n)_$(PAT_TABLE)_$(FLASH_TYPE)_$($(n)$(FSTYPE))_script) $(PAT_TABLE)_$(FLASH_TYPE)_partition_script $(PAT_TABLE)_$(FLASH_TYPE)_config_script

TARGET_FS:=$(filter-out $(patsubst %_fs__,%,$(filter %_fs__, $(foreach n,$(IMAGE_LIST),$(n)_fs_$($(n)$(FSTYPE))_))), $(IMAGE_LIST))

SCRIPTDIR:=$(IMAGEDIR)/scripts

scripts:
	mkdir -p $(SCRIPTDIR) 
	$(MAKE) $(TARGET_SCRIPT)
	@echo estar scripts/set_partition > $(IMAGEDIR)/auto_update.txt
	@echo -e $(foreach n,$(IMAGE_LIST),estar scripts/[[$(n)\\n) >> $(IMAGEDIR)/auto_update.txt
	@echo estar scripts/set_config >> $(IMAGEDIR)/auto_update.txt
	@echo saveenv >> $(IMAGEDIR)/auto_update.txt
	@echo printenv >> $(IMAGEDIR)/auto_update.txt
	@echo reset >> $(IMAGEDIR)/auto_update.txt

#for spi nor flash kernel.
kernel_spi_nor__script:
	@echo "# <- this is for comment / total file size must be less than 4KB" > $(SCRIPTDIR)/[[$(patsubst %_spi_nor__script,%,$@)
	@echo mxp r.info KERNEL >> $(SCRIPTDIR)/[[$(patsubst %_spi_nor__script,%,$@)
	@echo sf probe 0 >> $(SCRIPTDIR)/[[$(patsubst %_spi_nor__script,%,$@)
	@echo sf erase \$${sf_part_start} \$${sf_part_size} >> $(SCRIPTDIR)/[[$(patsubst %_spi_nor__script,%,$@)
	@echo tftp $(TFTPDOWNLOADADDR) $(patsubst %_spi_nor__script,%,$@) >> $(SCRIPTDIR)/[[$(patsubst %_spi_nor__script,%,$@)
	@echo sf write $(TFTPDOWNLOADADDR) \$${sf_part_start} \$${filesize} >> $(SCRIPTDIR)/[[$(patsubst %_spi_nor__script,%,$@)
	@echo setenv sf_kernel_start \$${sf_part_start} >> $(SCRIPTDIR)/[[$(patsubst %_spi_nor__script,%,$@)
	@echo setenv sf_kernel_size \$${sf_part_size} >> $(SCRIPTDIR)/[[$(patsubst %_spi_nor__script,%,$@)
	@echo setenv bootcmd \' sf probe 0\;sf read $(KERNELBOOTADDR) \$${sf_kernel_start} \$${sf_kernel_size}\;bootm $(KERNELBOOTADDR) >> $(SCRIPTDIR)/[[$(patsubst %_spi_nor__script,%,$@)
	@echo "% <- this is end of file symbol" >> $(SCRIPTDIR)/[[$(patsubst %_spi_nor__script,%,$@)

uboot_spi_nor__script:
	@echo "# <- this is for comment / total file size must be less than 4KB" > $(SCRIPTDIR)/[[uboot
	@echo mxp r.info UBOOT >> $(SCRIPTDIR)/[[uboot
	@echo sf probe 0 >> $(SCRIPTDIR)/[[uboot
	@echo sf erase \$${sf_part_start} \$${sf_part_size} >> $(SCRIPTDIR)/[[uboot
	@echo tftp $(TFTPDOWNLOADADDR) u-boot.xz.img.bin >> $(SCRIPTDIR)/[[uboot
	@echo sf write $(TFTPDOWNLOADADDR) \$${sf_part_start} \$${filesize} >> $(SCRIPTDIR)/[[uboot
	@echo "% <- this is end of file symbol" >> $(SCRIPTDIR)/[[uboot

ipl_spi_nor__script:
	@echo "# <- this is for comment / total file size must be less than 4KB" > $(SCRIPTDIR)/[[$(patsubst %_spi_nor__script,%,$@)
	@echo mxp r.info IPL >> $(SCRIPTDIR)/[[$(patsubst %_spi_nor__script,%,$@)
	@echo sf probe 0 >> $(SCRIPTDIR)/[[$(patsubst %_spi_nor__script,%,$@)
	@echo sf erase \$${sf_part_start} \$${sf_part_size} >> $(SCRIPTDIR)/[[$(patsubst %_spi_nor__script,%,$@)
	@echo tftp $(TFTPDOWNLOADADDR) IPL.bin >> $(SCRIPTDIR)/[[$(patsubst %_spi_nor__script,%,$@)
	@echo sf write $(TFTPDOWNLOADADDR) \$${sf_part_start} \$${filesize} >> $(SCRIPTDIR)/[[$(patsubst %_spi_nor__script,%,$@)
	@echo  "% <- this is end of file symbol" >> $(SCRIPTDIR)/[[$(patsubst %_spi_nor__script,%,$@)

%_spi_nor_squashfs_script:
	@echo "# <- this is for comment / total file size must be less than 4KB" > $(SCRIPTDIR)/[[$(patsubst %_spi_nor_squashfs_script,%,$@)
	@echo mxp r.info $(patsubst %_spi_nor_squashfs_script,%,$@) >> $(SCRIPTDIR)/[[$(patsubst %_spi_nor_squashfs_script,%,$@)
	@echo sf probe 0 >> $(SCRIPTDIR)/[[$(patsubst %_spi_nor_squashfs_script,%,$@)
	@echo sf erase \$${sf_part_start} \$${sf_part_size} >> $(SCRIPTDIR)/[[$(patsubst %_spi_nor_squashfs_script,%,$@)
	@echo tftp $(TFTPDOWNLOADADDR) $(patsubst %_spi_nor_squashfs_script,%,$@).sqfs >> $(SCRIPTDIR)/[[$(patsubst %_spi_nor_squashfs_script,%,$@)
	@echo sf write $(TFTPDOWNLOADADDR) \$${sf_part_start} \$${filesize} >> $(SCRIPTDIR)/[[$(patsubst %_spi_nor_squashfs_script,%,$@)
	@echo  "% <- this is end of file symbol" >> $(SCRIPTDIR)/[[$(patsubst %_spi_nor_squashfs_script,%,$@)

%_spi_nor_jffs2_script:
	@echo "# <- this is for comment / total file size must be less than 4KB" > $(SCRIPTDIR)/[[$(patsubst %_spi_nor_jffs2_script,%,$@)
	@echo mxp r.info $(patsubst %_spi_nor_jffs2_script,%,$@) >> $(SCRIPTDIR)/[[$(patsubst %_spi_nor_jffs2_script,%,$@)
	@echo sf probe 0 >> $(SCRIPTDIR)/[[$(patsubst %_spi_nor_jffs2_script,%,$@)
	@echo sf erase \$${sf_part_start} \$${sf_part_size} >> $(SCRIPTDIR)/[[$(patsubst %_spi_nor_jffs2_script,%,$@)
	@echo tftp $(TFTPDOWNLOADADDR) $(patsubst %_spi_nor_jffs2_script,%,$@).jffs2 >> $(SCRIPTDIR)/[[$(patsubst %_spi_nor_jffs2_script,%,$@)
	@echo sf write $(TFTPDOWNLOADADDR) \$${sf_part_start} \$${filesize} >> $(SCRIPTDIR)/[[$(patsubst %_spi_nor_jffs2_script,%,$@)
	@echo  "% <- this is end of file symbol" >> $(SCRIPTDIR)/[[$(patsubst %_spi_nor_jffs2_script,%,$@)

spi_nor_partition_script:
	@echo "# <- this is for comment / total file size must be less than 4KB" > $(SCRIPTDIR)/set_partition
	@echo mxp t.init >> $(SCRIPTDIR)/set_partition
	@echo tftp $(TFTPDOWNLOADADDR) MXP_SF.bin >> $(SCRIPTDIR)/set_partition
	@echo mxp t.update $(TFTPDOWNLOADADDR) >> $(SCRIPTDIR)/set_partition
	@echo mxp t.load >> $(SCRIPTDIR)/set_partition
	@echo sf probe 0 >> $(SCRIPTDIR)/set_partition
	@echo sf erase 0xC000 0x1000 >> $(SCRIPTDIR)/set_partition
	@echo sf write $(TFTPDOWNLOADADDR) 0xC000 0x1000 >> $(SCRIPTDIR)/set_partition
	@echo  "% <- this is end of file symbol" >> $(SCRIPTDIR)/set_partition

spi_nor_config_script:
	@echo "# <- this is for comment / total file size must be less than 4KB" > $(SCRIPTDIR)/set_config
	@echo setenv bootargs console=ttyS0,115200 $(rootfs$(BOOTENV)) $(kernel$(BOOTENV)) $(EXBOOTARGS) >> $(SCRIPTDIR)/set_config
	@echo saveenv >> $(SCRIPTDIR)/set_config
	@echo reset >> $(SCRIPTDIR)/set_config
	@echo  "% <- this is end of file symbol" >> $(SCRIPTDIR)/set_config
