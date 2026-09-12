#
# Copyright (C) 2026 The Android Open Source Project
# Copyright (C) 2026 SebaUbuntu's TWRP device tree generator
#
# SPDX-License-Identifier: Apache-2.0
#

DEVICE_PATH := device/oplus/ossi

# -----------------------------------------------------------------------------
# 0. Build compatibility
# -----------------------------------------------------------------------------
ALLOW_MISSING_DEPENDENCIES := true
BUILD_BROKEN_DUP_RULES := true
BUILD_BROKEN_ELF_PREBUILT_PRODUCT_COPY_FILES := true
BUILD_BROKEN_NINJA_USES_ENV_VARS += RTIC_MPGEN
BUILD_BROKEN_PLUGIN_VALIDATION := \
    soong-libaosprecovery_defaults \
    soong-libguitwrp_defaults \
    soong-libminuitwrp_defaults \
    soong-vold_defaults

# -----------------------------------------------------------------------------
# 1. Architecture
# SM8550 (Kalama) — Kryo cores, arm64-v8a
# -----------------------------------------------------------------------------
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := generic
TARGET_CPU_VARIANT_RUNTIME := kryo300

ENABLE_CPUSETS := true
ENABLE_SCHEDBOOST := true

# Build against Android 13 (API 33) — device ships with Android 13.
BOARD_SHIPPING_API_LEVEL := 33

# -----------------------------------------------------------------------------
# 2. Platform identity
# ro.board.platform=kalama
# ro.vendor.qti.soc_model=SM8550
# -----------------------------------------------------------------------------
PRODUCT_PLATFORM := kalama
TARGET_BOOTLOADER_BOARD_NAME := kalama
TARGET_BOARD_PLATFORM := kalama

TARGET_NO_BOOTLOADER := true
TARGET_USES_UEFI := true
QCOM_BOARD_PLATFORMS += kalama

# -----------------------------------------------------------------------------
# 3. Kernel / boot image / recovery image
# boot header v4, dedicated recovery partition (ramdisk-only),
# kernel loaded from boot_a/boot_b, DTB from vendor_boot.
# TARGET_PREBUILT_KERNEL is a build-system placeholder.
# -----------------------------------------------------------------------------
TARGET_KERNEL_ARCH := arm64
TARGET_KERNEL_HEADER_ARCH := arm64
BOARD_KERNEL_IMAGE_NAME := Image
BOARD_BOOT_HEADER_VERSION := 4
BOARD_KERNEL_PAGESIZE := 4096

TARGET_PREBUILT_KERNEL := $(DEVICE_PATH)/prebuilt/kernel

BOARD_MKBOOTIMG_ARGS += --header_version $(BOARD_BOOT_HEADER_VERSION)
BOARD_MKBOOTIMG_ARGS += --pagesize $(BOARD_KERNEL_PAGESIZE)

PRODUCT_OTA_ENFORCE_VINTF_KERNEL_REQUIREMENTS   := false
PRODUCT_ENABLE_UFFD_GC                          := true

# BOARD_EXCLUDE_KERNEL_FROM_RECOVERY_IMAGE := true
BOARD_RAMDISK_USE_LZ4 := true
BOARD_USES_RECOVERY_AS_BOOT := false

# Real cmdline/bootconfig comes from boot/vendor_boot.
# Keep empty to avoid injecting guessed parameters into ramdisk-only recovery.
BOARD_KERNEL_CMDLINE :=

# -----------------------------------------------------------------------------
# 4. A/B / Virtual A/B
# Dedicated recovery_a / recovery_b partitions exist.
# -----------------------------------------------------------------------------
AB_OTA_UPDATER := true
AB_OTA_PARTITIONS += \
    boot \
    init_boot \
    vendor_boot \
    recovery \
    dtbo \
    vbmeta \
    vbmeta_system \
    vbmeta_vendor \
    system \
    system_ext \
    system_dlkm \
    product \
    vendor \
    vendor_dlkm \
    odm

# AB partitions for oplus
AB_OTA_PARTITIONS += \
    my_bigball \
    my_carrier \
    my_company \
    my_engineering \
    my_heytap \
    my_manifest \
    my_preload \
    my_product \
    my_region \
    my_stock

BOARD_RECOVERY_NEEDS_BOOTLOADER_CONTROL := true

# -----------------------------------------------------------------------------
# 5. AVB
# -----------------------------------------------------------------------------
BOARD_AVB_ENABLE := true

# -----------------------------------------------------------------------------
# 6. Physical partition sizes
# -----------------------------------------------------------------------------
BOARD_BOOTIMAGE_PARTITION_SIZE := 104857600
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 104857600

# -----------------------------------------------------------------------------
# 7. Dynamic partitions / super
# -----------------------------------------------------------------------------
BOARD_PROPERTY_OVERRIDES_SPLIT_ENABLED := true
BOARD_SUPER_PARTITION_SIZE := 15569256448
BOARD_SUPER_PARTITION_GROUPS := oplus_dynamic_partitions

BOARD_OPLUS_DYNAMIC_PARTITIONS_SIZE := 15565062144
BOARD_OPLUS_DYNAMIC_PARTITIONS_PARTITION_LIST := \
    system \
    system_ext \
    system_dlkm \
    product \
    vendor \
    vendor_dlkm \
    odm

# -----------------------------------------------------------------------------
# 8. Filesystems / partition copy-out
# Verified from recovery.fstab: erofs and ext4 dual entries.
# Build system needs these declarations to set up output directories.
# -----------------------------------------------------------------------------
BOARD_SYSTEMIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_SYSTEM_EXTIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_SYSTEM_DLKMIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_PRODUCTIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_VENDOR_DLKMIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_ODMIMAGE_FILE_SYSTEM_TYPE := ext4

BOARD_USES_VENDOR_DLKMIMAGE := true

TARGET_COPY_OUT_SYSTEM := system
TARGET_COPY_OUT_SYSTEM_EXT := system_ext
TARGET_COPY_OUT_SYSTEM_DLKM := system_dlkm
TARGET_COPY_OUT_PRODUCT := product
TARGET_COPY_OUT_VENDOR := vendor
TARGET_COPY_OUT_VENDOR_DLKM := vendor_dlkm
TARGET_COPY_OUT_ODM := odm

BOARD_USERDATAIMAGE_FILE_SYSTEM_TYPE := f2fs
TARGET_USERIMAGES_USE_F2FS := true
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USES_MKE2FS := true
BOARD_HAS_LARGE_FILESYSTEM := true

# -----------------------------------------------------------------------------
# 9. Crypto / FBE
# Verified from fstab:
#   fileencryption=aes-256-xts:aes-256-cts:v2+inlinecrypt_optimized+wrappedkey_v0
#   metadata_encryption=aes-256-xts:wrappedkey_v0
# -----------------------------------------------------------------------------
BOARD_USES_METADATA_PARTITION := true
BOARD_USES_QCOM_FBE_DECRYPTION := true

TW_INCLUDE_CRYPTO := true
TW_INCLUDE_CRYPTO_FBE := true
TW_INCLUDE_FBE_METADATA_DECRYPT := true
TW_USE_FSCRYPT_POLICY := 2

# -----------------------------------------------------------------------------
# 10. Recovery-side security patch compatibility
# -----------------------------------------------------------------------------
PLATFORM_VERSION := 99.87.36
PLATFORM_VERSION_LAST_STABLE := $(PLATFORM_VERSION)
PLATFORM_SECURITY_PATCH := 2099-12-31
VENDOR_SECURITY_PATCH := $(PLATFORM_SECURITY_PATCH)
BOOT_SECURITY_PATCH := $(PLATFORM_SECURITY_PATCH)

# -----------------------------------------------------------------------------
# 11. Recovery base
# -----------------------------------------------------------------------------
TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/recovery.fstab
TARGET_RECOVERY_PIXEL_FORMAT := RGBX_8888
TARGET_RECOVERY_QCOM_RTC_FIX := true
TARGET_SYSTEM_PROP += $(DEVICE_PATH)/system.prop
RECOVERY_SDCARD_ON_DATA := true

# Init
TARGET_INIT_VENDOR_LIB := //$(DEVICE_PATH):libinit_oplus_ossi
TARGET_RECOVERY_DEVICE_MODULES := libinit_oplus_ossi

# -----------------------------------------------------------------------------
# 12. Display / theme
# -----------------------------------------------------------------------------
TW_THEME := portrait_hdpi
TW_NO_SCREEN_BLANK := true
TW_SCREEN_BLANK_ON_BOOT := true
TW_CUSTOM_CPU_TEMP_PATH := "/sys/class/thermal/thermal_zone45/temp"
TW_DEVICE_VERSION := OPLUS-OSSI

# -----------------------------------------------------------------------------
# 13. Input
# -----------------------------------------------------------------------------
TW_INPUT_BLACKLIST := "hbtp_vm"

# -----------------------------------------------------------------------------
# 14. Storage / tools
# -----------------------------------------------------------------------------
TW_ENABLE_FS_COMPRESSION := true
TW_INCLUDE_FUSE_EXFAT := true
TW_INCLUDE_FUSE_NTFS := true
TW_INCLUDE_NTFS_3G := true
TW_NO_EXFAT_FUSE := true

TW_INCLUDE_7ZA := true
TW_INCLUDE_REPACKTOOLS := true
TW_INCLUDE_RESETPROP := true
TW_INCLUDE_ZSTD := true
TW_USE_TOOLBOX := true
TW_ENABLE_ALL_PARTITION_TOOLS := true

# -----------------------------------------------------------------------------
# 15. Vendor modules
# -----------------------------------------------------------------------------
TW_LOAD_VENDOR_MODULES := "adsp_loader_dlkm.ko oplus_chg_v2.ko stm_st54se_gpio.ko nxp-nci.ko"
TW_LOAD_VENDOR_MODULES_EXCLUDE_GKI := true

# -----------------------------------------------------------------------------
# 16. Localization / device defaults
# -----------------------------------------------------------------------------
TW_EXTRA_LANGUAGES := true
# TW_EXCLUDE_DEFAULT_USB_INIT := true
TW_USE_SERIALNO_PROPERTY_FOR_DEVICE_ID := true
TW_NO_NETWORK := true
TW_INCLUDE_FASTBOOTD := true