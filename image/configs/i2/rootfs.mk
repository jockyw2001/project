.PHONY: rootfs

rootfs:
	cd rootfs; tar xf rootfs.tar.gz -C $(OUTPUTDIR)
	tar xf busybox/$(BUSYBOX).tar.gz -C $(OUTPUTDIR)/rootfs
	tar xf $(PROJ_ROOT)/release/$(PRODUCT)/$(CHIP)/$(BOARD)/$(TOOLCHAIN)/$(TOOLCHAIN_VERSION)/lib/package/$(LIBC).tar.gz -C $(OUTPUTDIR)/rootfs/lib
	cp $(PROJ_ROOT)/release/$(PRODUCT)/$(CHIP)/$(BOARD)/$(TOOLCHAIN)/$(TOOLCHAIN_VERSION)/lib/dynamic/* $(OUTPUTDIR)/rootfs/lib/

	if [ "$(BENCH)" = "yes" ]; then \
		cp $(PROJ_ROOT)/release/$(PRODUCT)/$(CHIP)/$(BOARD)/$(TOOLCHAIN)/$(TOOLCHAIN_VERSION)/lib/dynamic/libgcc_s.so.1 $(OUTPUTDIR)/rootfs/lib/ ; \
	fi;

	mkdir -p $(OUTPUTDIR)/tvconfig/config
	cp -rf $(PROJ_ROOT)/board/ini/* $(OUTPUTDIR)/tvconfig/config
	cp -rf $(PROJ_ROOT)/board/$(CHIP)/$(BOARD_NAME)/config/* $(OUTPUTDIR)/tvconfig/config
	cp -vf $(PROJ_ROOT)/board/$(CHIP)/mmap/$(MMAP) $(OUTPUTDIR)/tvconfig/config/mmap.ini
	cp -rvf $(PROJ_ROOT)/release/$(PRODUCT)/$(CHIP)/$(BOARD)/$(TOOLCHAIN)/$(TOOLCHAIN_VERSION)/bin/config_tool/* $(OUTPUTDIR)/tvconfig/config
	cd $(OUTPUTDIR)/tvconfig/config; chmod +x config_tool; ln -sf config_tool dump_config; ln -sf config_tool dump_mmap
	cp -rf $(PROJ_ROOT)/board/$(CHIP)/pq $(OUTPUTDIR)/tvconfig/config/
	find  $(OUTPUTDIR)/tvconfig/config/pq/ -type f ! -name "Main.bin" -type f ! -name "Main_Ex.bin" -type f ! -name "Bandwidth_RegTable.bin"| xargs rm -rf
	cp -rvf $(PROJ_ROOT)/release/$(PRODUCT)/$(CHIP)/$(BOARD)/$(TOOLCHAIN)/$(TOOLCHAIN_VERSION)/bin/AHDInit/* $(OUTPUTDIR)/tvconfig/config

	mkdir -p $(OUTPUTDIR)/rootfs/config
#	cp -rf $(OUTPUTDIR)/tvconfig/config/* $(OUTPUTDIR)/rootfs/config
	cp -rf etc/* $(OUTPUTDIR)/rootfs/etc

	if [ $(BENCH) = "yes" ]; then \
		cp -rf /home/edie.chen/bench $(OUTPUTDIR)/tvconfig/config ; \
		cp $(OUTPUTDIR)/tvconfig/config/bench/demo.bash $(OUTPUTDIR)/tvconfig/config/bench.sh ; \
		chmod 755 $(OUTPUTDIR)/tvconfig/config/bench.sh ; \
	fi;

	if [ "$(PHY_TEST)" = "yes" ]; then \
		mkdir $(OUTPUTDIR)/tvconfig/config/sata_phy ; \
		cp $(PROJ_ROOT)/release/$(PRODUCT)/$(CHIP)/$(BOARD)/$(TOOLCHAIN)/$(TOOLCHAIN_VERSION)/bin/sata_phy/* $(OUTPUTDIR)/tvconfig/config/sata_phy ; \
	fi;

#	cp -rf $(PROJ_ROOT)/release/$(PRODUCT)/$(CHIP)/$(BOARD)/$(TOOLCHAIN)/$(TOOLCHAIN_VERSION)/bin/verify/* $(OUTPUTDIR)/rootfs/bin
	mkdir -p $(OUTPUTDIR)/rootfs/lib/modules/
	mkdir -p $(OUTPUTDIR)/tvconfig/config/modules/$(KERNEL_VERSION)

	touch ${OUTPUTDIR}/rootfs/etc/mdev.conf
	echo mice 0:0 0660 =input/ >> ${OUTPUTDIR}/rootfs/etc/mdev.conf
	echo mouse.* 0:0 0660 =input/ >> ${OUTPUTDIR}/rootfs/etc/mdev.conf
	echo event.* 0:0 0660 =input/ >> ${OUTPUTDIR}/rootfs/etc/mdev.conf

	echo export PATH=\$$PATH:/config >> ${OUTPUTDIR}/rootfs/etc/profile
	sed -i '/^mount.*/d' $(OUTPUTDIR)/rootfs/etc/profile
	echo mkdir -p /dev/pts >> ${OUTPUTDIR}/rootfs/etc/profile
	echo mount -t sysfs none /sys >> $(OUTPUTDIR)/rootfs/etc/profile
	echo mount -t tmpfs mdev /dev >> $(OUTPUTDIR)/rootfs/etc/profile
	echo mount -t debugfs none /sys/kernel/debug/ >>  $(OUTPUTDIR)/rootfs/etc/profile

	if [ "$(FLASH_TYPE)"x = "spinand"x  ]; then \
		cp $(PROJ_ROOT)/tools/$(TOOLCHAIN)/iperf $(OUTPUTDIR)/tvconfig/config ; \
		echo mount -t ubifs ubi0:nvrservice /config >> $(OUTPUTDIR)/rootfs/etc/profile ; \
		echo mount -t ubifs ubi0:customer /customer >> $(OUTPUTDIR)/rootfs/etc/profile ; \
	else \
		echo mount -t jffs2 mtd:nvrservice /config >> $(OUTPUTDIR)/rootfs/etc/profile ; \
	fi;

	chmod 755 $(PROJ_ROOT)/release/$(PRODUCT)/$(CHIP)/$(BOARD)/$(TOOLCHAIN)/$(TOOLCHAIN_VERSION)/bin/debug/*
	cp -rf $(PROJ_ROOT)/release/$(PRODUCT)/$(CHIP)/$(BOARD)/$(TOOLCHAIN)/$(TOOLCHAIN_VERSION)/bin/debug/* $(OUTPUTDIR)/tvconfig/config
	touch $(OUTPUTDIR)/tvconfig/config/demo.sh
	chmod 755 $(OUTPUTDIR)/tvconfig/config/demo.sh


	# creat insmod ko scrpit
	if [ -f "$(PROJ_ROOT)/release/$(PRODUCT)/$(CHIP)/$(BOARD)/$(TOOLCHAIN)/$(TOOLCHAIN_VERSION)/lib/modules/$(KERNEL_VERSION)/misc_mod_list" ]; then \
		cat $(PROJ_ROOT)/release/$(PRODUCT)/$(CHIP)/$(BOARD)/$(TOOLCHAIN)/$(TOOLCHAIN_VERSION)/lib/modules/$(KERNEL_VERSION)/misc_mod_list | sed 's#\(.*\).ko#insmod /config/modules/$(KERNEL_VERSION)/\1.ko#' > $(OUTPUTDIR)/tvconfig/config/demo.sh; \
		cat $(PROJ_ROOT)/release/$(PRODUCT)/$(CHIP)/$(BOARD)/$(TOOLCHAIN)/$(TOOLCHAIN_VERSION)/lib/modules/$(KERNEL_VERSION)/misc_mod_list | sed 's#\(.*\).ko\(.*\)#$(PROJ_ROOT)/release/$(PRODUCT)/$(CHIP)/$(BOARD)/$(TOOLCHAIN)/$(TOOLCHAIN_VERSION)/lib/modules/$(KERNEL_VERSION)/\1.ko#' | xargs -i cp -rvf {} $(OUTPUTDIR)/tvconfig/config/modules/$(KERNEL_VERSION); \
		echo mdev -s >> $(OUTPUTDIR)/tvconfig/config/demo.sh; \
	fi;

	if [ -f "$(PROJ_ROOT)/release/$(PRODUCT)/$(CHIP)/$(BOARD)/$(TOOLCHAIN)/$(TOOLCHAIN_VERSION)/lib/modules/$(KERNEL_VERSION)/.mods_depend" ]; then \
		cat $(PROJ_ROOT)/release/$(PRODUCT)/$(CHIP)/$(BOARD)/$(TOOLCHAIN)/$(TOOLCHAIN_VERSION)/lib/modules/$(KERNEL_VERSION)/.mods_depend | sed 's#\(.*\)#insmod /config/modules/$(KERNEL_VERSION)/\1.ko#' >> $(OUTPUTDIR)/tvconfig/config/demo.sh; \
		cat $(PROJ_ROOT)/release/$(PRODUCT)/$(CHIP)/$(BOARD)/$(TOOLCHAIN)/$(TOOLCHAIN_VERSION)/lib/modules/$(KERNEL_VERSION)/.mods_depend | sed 's#\(.*\)#$(PROJ_ROOT)/release/$(PRODUCT)/$(CHIP)/$(BOARD)/$(TOOLCHAIN)/$(TOOLCHAIN_VERSION)/lib/modules/$(KERNEL_VERSION)/\1.ko#' | xargs -i cp -rvf {} $(OUTPUTDIR)/tvconfig/config/modules/$(KERNEL_VERSION); \
		echo mdev -s >> $(OUTPUTDIR)/tvconfig/config/demo.sh; \
	fi;

	if [ -f "$(PROJ_ROOT)/release/$(PRODUCT)/$(CHIP)/$(BOARD)/$(TOOLCHAIN)/$(TOOLCHAIN_VERSION)/lib/modules/$(KERNEL_VERSION)/misc_mod_list_late" ]; then \
		cat $(PROJ_ROOT)/release/$(PRODUCT)/$(CHIP)/$(BOARD)/$(TOOLCHAIN)/$(TOOLCHAIN_VERSION)/lib/modules/$(KERNEL_VERSION)/misc_mod_list_late | sed 's#\(.*\).ko#insmod /config/modules/$(KERNEL_VERSION)/\1.ko#' >> $(OUTPUTDIR)/tvconfig/config/demo.sh; \
		cat $(PROJ_ROOT)/release/$(PRODUCT)/$(CHIP)/$(BOARD)/$(TOOLCHAIN)/$(TOOLCHAIN_VERSION)/lib/modules/$(KERNEL_VERSION)/misc_mod_list_late | sed 's#\(.*\).ko\(.*\)#$(PROJ_ROOT)/release/$(PRODUCT)/$(CHIP)/$(BOARD)/$(TOOLCHAIN)/$(TOOLCHAIN_VERSION)/lib/modules/$(KERNEL_VERSION)/\1.ko#' | xargs -i cp -rvf {} $(OUTPUTDIR)/tvconfig/config/modules/$(KERNEL_VERSION); \
		echo mdev -s >> $(OUTPUTDIR)/tvconfig/config/demo.sh; \
	fi;

	if [ $(PRODUCT) = "usb_cam" ]; then \
		sed -i 's/mi_vpe.ko/mi_vpe.ko PortNum=3/g' $(OUTPUTDIR)/tvconfig/config/demo.sh; \
	else \
		sed -i 's/mi_vpe.ko/mi_vpe.ko PortNum=4/g' $(OUTPUTDIR)/tvconfig/config/demo.sh; \
	fi;

	if [ $(PHY_TEST) = "yes" ]; then \
		echo -e "\033[41;33;5m !!! Replace "mdrv-sata-host.ko" with "sata_bench_test.ko" !!!\033[0m" ; \
		sed '/mdrv-sata-host/d' $(OUTPUTDIR)/tvconfig/config/demo.sh > $(OUTPUTDIR)/tvconfig/config/demotemp.sh ; \
		echo insmod /config/sata_phy/sata_bench_test.ko >> $(OUTPUTDIR)/tvconfig/config/demotemp.sh ; \
		cp $(OUTPUTDIR)/tvconfig/config/demotemp.sh $(OUTPUTDIR)/tvconfig/config/demo.sh ; \
		rm $(OUTPUTDIR)/tvconfig/config/demotemp.sh ; \
	fi;

	# Enable MIU protect on CMDQ buffer as default (While List: CPU)
	echo 'echo set_miu_block3_status 0 3 0x70 0 0x100000 1 > /proc/mi_modules/mi_sys_mma/miu_protect' >> $(OUTPUTDIR)/tvconfig/config/demo.sh

#	echo mount -t jffs2 /dev/mtdblock3 /config >> $(OUTPUTDIR)/rootfs/etc/profile
	ln -fs /config/modules/$(KERNEL_VERSION) $(OUTPUTDIR)/rootfs/lib/modules/
	find $(OUTPUTDIR)/tvconfig/config/modules/$(KERNEL_VERSION) -name "*.ko" | xargs $(TOOLCHAIN_REL)strip  --strip-unneeded;
	echo mdev -s >> $(OUTPUTDIR)/rootfs/etc/profile
	echo mkdir -p /dev/pts >> $(OUTPUTDIR)/rootfs/etc/profile
	echo mount -t devpts devpts /dev/pts >> $(OUTPUTDIR)/rootfs/etc/profile
	echo "busybox telnetd&" >> $(OUTPUTDIR)/rootfs/etc/profile
	echo "if [ -e /config/demo.sh ]; then" >> ${OUTPUTDIR}/rootfs/etc/profile
	echo "    /config/demo.sh" >> ${OUTPUTDIR}/rootfs/etc/profile
	echo "fi;" >> ${OUTPUTDIR}/rootfs/etc/profile

	if [ $(BENCH) = "yes" ]; then \
		echo ./config/bench.sh >> $(OUTPUTDIR)/tvconfig/config/demo.sh ; \
	fi;



	mkdir -p $(OUTPUTDIR)/vendor
	mkdir -p $(OUTPUTDIR)/customer
	mkdir -p $(OUTPUTDIR)/rootfs/vendor
	mkdir -p $(OUTPUTDIR)/rootfs/customer
