# This Makefile works on Aarch64 based environments.

ATF_DIR = imx-atf
ATF_MAKE_FLAGS = SPD=none PLAT=imx8mq
atf:
	cd "$(ATF_DIR)" && \
	make $(ATF_MAKE_FLAGS)
 
UBOOT_DIR = u-boot-tn-imx
UBOOT_MAKE_FLAGS =
uboot:
	cp -f uboot-extra.config $(UBOOT_DIR)/
	cd "$(UBOOT_DIR)" && \
		[[ -f ".config" ]] || make pico-imx8mq_defconfig && \
		./scripts/kconfig/merge_config.sh ".config" "uboot-extra.config" && \
		make $(UBOOT_MAKE_FLAGS)

.PHONY: uboot atf firmware_pkg flash linux

FW_PCKG_DIR = imx-mkimage/iMX8M
FW_DIR = firmware-imx-8.22/firmware
MKIMAGE_COPY_FILES = \
	$(FW_DIR)/ddr/synopsys/lpddr4_pmu_train_1d_dmem.bin \
	$(FW_DIR)/ddr/synopsys/lpddr4_pmu_train_1d_imem.bin \
	$(FW_DIR)/ddr/synopsys/lpddr4_pmu_train_2d_dmem.bin \
	$(FW_DIR)/ddr/synopsys/lpddr4_pmu_train_2d_imem.bin \
	$(FW_DIR)/hdmi/cadence/signed_hdmi_imx8m.bin \
	$(ATF_DIR)/build/imx8mq/release/bl31.bin \
	$(UBOOT_DIR)/spl/u-boot-spl.bin \
	$(UBOOT_DIR)/u-boot-nodtb.bin \
	$(UBOOT_DIR)/arch/arm/dts/imx8mq-pico-pi.dtb
firmware_pkg:
	cp -f "$(UBOOT_DIR)/tools/mkimage" "$(FW_PCKG_DIR)/mkimage_uboot" && \
	cp -f $(MKIMAGE_COPY_FILES) "$(FW_PCKG_DIR)/" && \
	cd "imx-mkimage" && \
	make SOC=iMX8M dtbs=imx8mq-pico-pi.dtb flash_evk

UUU_DIR = mfgtools/build/uuu
flash_prep: atf uboot firmware_pkg
	cd mfgtools && \
	mkdir build && cd build && cmake .. && cmake --build .

flash: flash_prep
	cd "$(UUU_DIR)" && \
	sudo ./uuu -b spl ../../../imx-mkimage/iMX8M/flash.bin

linux:
	cd linux && \
	make ARCH=arm64 defconfig && \
	make ARCH=arm64 -j4

buildroot:
	cp -f buildroot-extra.config "buildroot/"
	cd "buildroot""&& \
		[[ -f ".config" ]] || make imx8mqevk_defconfig && \
		./support/kconfig/merge_config.sh ".config" "buildroot-extra.config" && \
		make

fit:
	cd "staging" && \
		mkimage -f linux.its linux.itb

clean:
	rm -rf \
	$(ATF_DIR)/build/imx8mq/release/bl31.bin \
	$(UBOOT_DIR)/spl/u-boot-spl.bin \
	$(UBOOT_DIR)/u-boot-nodtb.bin \
	$(UBOOT_DIR)/arch/arm/dts/imx8mq-pico-pi.dtb \
	"$(FW_PCKG_DIR)/mkimage_uboot" \
	"$(FW_PCKG_DIR)/flash.bin" \
	"mfgtools/build"
