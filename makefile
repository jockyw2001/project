.PHONY: release image
include configs/current.configs

kbuild/$(KERNEL_VERSION)/.config:
	ln -sf $(CURDIR)/kbuild/$(KERNEL_VERSION)/configs/$(PRODUCT)/$(CHIP)/$(BOARD)/$(KERNEL_CONFIG)/include/* $(CURDIR)/kbuild/$(KERNEL_VERSION)/include
	ln -sf $(CURDIR)/kbuild/$(KERNEL_VERSION)/configs/$(PRODUCT)/$(CHIP)/$(BOARD)/$(KERNEL_CONFIG)/Module.symvers $(CURDIR)/kbuild/$(KERNEL_VERSION)
	ln -sf $(CURDIR)/kbuild/$(KERNEL_VERSION)/configs/$(PRODUCT)/$(CHIP)/$(BOARD)/$(KERNEL_CONFIG)/.config $(CURDIR)/kbuild/$(KERNEL_VERSION)

-include $(SOURCE_MK)

release: $(SOURCE_RELEASE)
	@echo $(SOURCE_RELEASE)

image: release
	$(MAKE) -C image all
	@$(MAKE) warning_message

image-fast:
	$(MAKE) -C image all
	@$(MAKE) warning_message

warning_message:
	@git status -s release/include | awk -F' ' '{a = a "\033[7;34;42m"$$2"\033[0m\n"} END {if(a){ print "\033[5;31;43mWARNING!!!!NEED MI OWNER TO RESUBMIT THE FOLLOWING INCONSISTENT HEAD FILES\033[0m";print a;}}'

image_clean:
	$(MAKE) -C image clean

clean: $(SOURCE_CLEAN)
	$(MAKE) image_clean

build_verify: $(SOURCE_RELEASE_DEPEND)
	$(MAKE) clean
	$(MAKE) -C image all
