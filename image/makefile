OUTPUTDIR:=$(CURDIR)/output
IMAGEDIR:=$(CURDIR)/output/images
RESOUCE:=_resource
FSTYPE:=_fstype
PATSIZE:=_patsize
MOUNTDIR:=_mountdir
OPTIONS:=_options
BOOTENV:=_bootenv
MTDPART:=_mtdpart

include ../configs/current.configs
include configs/$(CHIP)/$(IMAGE_CONFIG)
PERF:=$(patsubst %,tar xf build/%.tar.gz -C $(OUTPUTDIR)/rootfs,$(PERF_NAME))
STAP:=$(patsubst %,tar xf build/%.tar.gz -C $(OUTPUTDIR)/rootfs,$(STAP_NAME))

all:
	@mkdir -p $(OUTPUTDIR)
	@mkdir -p $(IMAGEDIR)
	$(MAKE) rootfs
	$(MAKE) images
	$(MAKE) scripts
ifeq ($(CHIP),i2)
	cp -rf $(PROJ_ROOT)/release/$(PRODUCT)/$(CHIP)/$(BOARD)/$(TOOLCHAIN)/$(TOOLCHAIN_VERSION)/bin/mboot/$(FLASH_TYPE)/* $(IMAGEDIR)/
else
	mkdir -p $(IMAGEDIR)/mboot
	cp -rf $(PROJ_ROOT)/release/$(PRODUCT)/$(CHIP)/$(BOARD)/$(TOOLCHAIN)/$(TOOLCHAIN_VERSION)/bin/mboot/$(FLASH_TYPE)/* $(IMAGEDIR)/mboot
endif
clean:
	rm -rf $(OUTPUTDIR)

ifeq ($(FLASH_TYPE), nor)
include configs/$(CHIP)/script_nor.mk
else
include configs/$(CHIP)/script_nand.mk
endif
include configs/$(CHIP)/rootfs.mk
include image.mk