ATF_DIR = imx-atf
ATF_MAKE_FLAGS = SPD=none PLAT=imx8mq
atf:
	cd "$(ATF_DIR)" && \
	make $(ATF_MAKE_FLAGS)
 
UBOOT_DIR = u-boot-tn-imx
UBOOT_MAKE_FLAGS =
uboot:
	cd "$(UBOOT_DIR)" && \
	make $(UBOOT_MAKE_FLAGS)
 
.PHONY: uboot atf

FW_PCKG_DIR = imx-mkimage/iMX8M
FW_DIR = firmware-imx-8.22/firmware
firmware_pkg:
	cp "$(UBOOT_DIR)/tools/mkimage" "$(FW_PCKG_DIR)/mkimage_uboot" && \
	cp "$(UBOOT_DIR)/spl/u-boot-spl.bin" "$(FW_PCKG_DIR)/u-boot-spl.bin" && \
	cp "$(UBOOT_DIR)/u-boot-nodtb.bin" "$(FW_PCKG_DIR)/u-boot-nodtb.bin" && \
	cp "$(UBOOT_DIR)/arch/arm/dts/imx8mq-pico-pi.dtb" "$(FW_PCKG_DIR)/imx8mq-pico-pi.dtb" && \
	cp "$(FW_DIR)/ddr/synopsys/lpddr4_pmu_train_1d_imem.bin" "$(FW_PCKG_DIR)/lpddr4_pmu_train_1d_imem.bin" && \
	cp "$(FW_DIR)/ddr/synopsys/lpddr4_pmu_train_1d_dmem.bin" "$(FW_PCKG_DIR)/lpddr4_pmu_train_1d_dmem.bin" && \
	cp "$(FW_DIR)/ddr/synopsys/lpddr4_pmu_train_2d_imem.bin" "$(FW_PCKG_DIR)/lpddr4_pmu_train_2d_imem.bin" && \
	cp "$(FW_DIR)/ddr/synopsys/lpddr4_pmu_train_2d_dmem.bin" "$(FW_PCKG_DIR)/lpddr4_pmu_train_2d_dmem.bin" && \
	cp "$(FW_DIR)/hdmi/cadence/signed_hdmi_imx8m.bin" "$(FW_PCKG_DIR)/signed_hdmi_imx8m.bin" && \
	cp "$(ATF_DIR)/build/imx8mq/release/bl31.bin" "$(FW_PCKG_DIR)/bl31.bin" && \
	cd "imx-mkimage" && \
	make SOC=iMX8M dtbs=imx8mq-pico-pi.dtb flash_evk
