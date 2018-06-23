.PHONY: rootfs

rootfs:
	cd rootfs; tar xf rootfs.tar.gz -C $(OUTPUTDIR)
	tar xf busybox/$(BUSYBOX).tar.gz -C $(OUTPUTDIR)/rootfs
	if [ "$(TOOLCHAIN_VERSION)"x = "4.8.3"x  ]; then \
		tar xf $(PROJ_ROOT)/release/$(PRODUCT)/$(CHIP)/$(BOARD)/$(TOOLCHAIN)/$(TOOLCHAIN_VERSION)/lib/package/$(LIBC).tar.gz -C $(OUTPUTDIR)/rootfs/lib/; \
	else \
		tar xf $(PROJ_ROOT)/release/$(PRODUCT)/$(CHIP)/$(BOARD)/$(TOOLCHAIN)/$(TOOLCHAIN_VERSION)/lib/package/$(LIBC).tar.gz -C $(OUTPUTDIR)/rootfs; \
	fi;
	cp $(PROJ_ROOT)/release/$(PRODUCT)/$(CHIP)/$(BOARD)/$(TOOLCHAIN)/$(TOOLCHAIN_VERSION)/lib/dynamic/* $(OUTPUTDIR)/rootfs/lib/

	mkdir -p $(OUTPUTDIR)/tvconfig/config
	cp -rf $(PROJ_ROOT)/board/ini/* $(OUTPUTDIR)/tvconfig/config
	cp -rf $(PROJ_ROOT)/board/$(CHIP)/$(BOARD_NAME)/config/* $(OUTPUTDIR)/tvconfig/config
	ln -sf $(FB_CONFIG) $(OUTPUTDIR)/tvconfig/config/fbdev.ini
	cp -vf $(PROJ_ROOT)/board/$(CHIP)/mmap/$(MMAP) $(OUTPUTDIR)/tvconfig/config/mmap.ini
	cp -rvf $(PROJ_ROOT)/release/$(PRODUCT)/$(CHIP)/$(BOARD)/$(TOOLCHAIN)/$(TOOLCHAIN_VERSION)/bin/config_tool/* $(OUTPUTDIR)/tvconfig/config
	cd $(OUTPUTDIR)/tvconfig/config; chmod +x config_tool; ln -sf config_tool dump_config; ln -sf config_tool dump_mmap
	cp -rf $(PROJ_ROOT)/board/$(CHIP)/pq $(OUTPUTDIR)/tvconfig/config/
	find  $(OUTPUTDIR)/tvconfig/config/pq/ -type f ! -name "Main.bin" -type f ! -name "Main_Ex.bin" -type f ! -name "Bandwidth_RegTable.bin"| xargs rm -rf

	mkdir -p $(OUTPUTDIR)/rootfs/config
	cp -rf etc/* $(OUTPUTDIR)/rootfs/etc
	if [ "$(FLASH_TYPE)"x = "nand"x  ]; then \
		cp $(PROJ_ROOT)/tools/$(TOOLCHAIN)/iperf $(OUTPUTDIR)/tvconfig/config ; \
		echo mount -t ubifs ubi:nvrservice /config >> $(OUTPUTDIR)/rootfs/etc/profile ; \
		echo mount -t ubifs ubi:vendor /vendor >> $(OUTPUTDIR)/rootfs/etc/profile ; \
		echo mount -t ubifs ubi:customer /customer >> $(OUTPUTDIR)/rootfs/etc/profile ; \
	else \
		echo mount -t "$(nvrservice$(FSTYPE))" /dev/mtdblock3 /config >> $(OUTPUTDIR)/rootfs/etc/profile ;\
	fi;
	cp -rf $(PROJ_ROOT)/release/$(PRODUCT)/$(CHIP)/$(BOARD)/$(TOOLCHAIN)/$(TOOLCHAIN_VERSION)/bin/verify/* $(OUTPUTDIR)/rootfs/bin
	mkdir -p $(OUTPUTDIR)/rootfs/lib/modules/$(KERNEL_VERSION)
	find $(PROJ_ROOT)/release/$(PRODUCT)/$(CHIP)/$(BOARD)/$(TOOLCHAIN)/$(TOOLCHAIN_VERSION)/lib/modules/$(KERNEL_VERSION) -name "*.ko" -exec cp {} $(OUTPUTDIR)/rootfs/lib/modules/$(KERNEL_VERSION) \;

	cp -rf $(OUTPUTDIR)/rootfs/lib/modules  $(OUTPUTDIR)/tvconfig/config
	rm -rf $(OUTPUTDIR)/rootfs/lib/modules
	find $(OUTPUTDIR)/tvconfig/config/modules/$(KERNEL_VERSION) -type f | xargs $(TOOLCHAIN_REL)strip  --strip-unneeded
	echo insmod /config/modules/$(KERNEL_VERSION)/utpa2k.ko >> $(OUTPUTDIR)/rootfs/etc/profile
	echo insmod /config/modules/$(KERNEL_VERSION)/mhal.ko >> $(OUTPUTDIR)/rootfs/etc/profile
	cat $(PROJ_ROOT)/release/$(PRODUCT)/$(CHIP)/$(BOARD)/$(TOOLCHAIN)/$(TOOLCHAIN_VERSION)/lib/modules/$(KERNEL_VERSION)/.mods_depend | sed 's#\(.*\)#insmod /config/modules/$(KERNEL_VERSION)/\1.ko#' >> $(OUTPUTDIR)/rootfs/etc/profile
	echo insmod /config/modules/$(KERNEL_VERSION)/mstar_fbdev.ko >> $(OUTPUTDIR)/rootfs/etc/profile
	$(PERF)
	$(STAP)
	mkdir -p $(OUTPUTDIR)/vendor
	mkdir -p $(OUTPUTDIR)/customer
	mkdir -p $(OUTPUTDIR)/rootfs/vendor
	mkdir -p $(OUTPUTDIR)/rootfs/customer
	mkdir -p $(OUTPUTDIR)/rootfs/lib/modules/$(KERNEL_VERSION)
