#
# Copyright (C) 2026 The Android Open Source Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Building with minimal manifest
ALLOW_MISSING_DEPENDENCIES := true

# Rules
BUILD_BROKEN_DUP_RULES := true
BUILD_BROKEN_ELF_PREBUILT_PRODUCT_COPY_FILES := true

# Architecture
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := generic
# TARGET_CPU_VARIANT_RUNTIME := kryo300

# Bootloader
PRODUCT_PLATFORM := kalama
TARGET_BOOTLOADER_BOARD_NAME := $(PRODUCT_PLATFORM)
TARGET_NO_BOOTLOADER := true

# Platform
TARGET_BOARD_PLATFORM := sm8550
TARGET_BOARD_PLATFORM_GPU := qcom-adreno740
QCOM_BOARD_PLATFORMS += sm8550

# TARGET_USES_UEFI := true

# Kernel
BOARD_KERNEL_IMAGE_NAME := Image
BOARD_BOOT_HEADER_VERSION := 4
BOARD_KERNEL_PAGESIZE := 4096
TARGET_KERNEL_CLANG_COMPILE   := true
TARGET_PREBUILT_KERNEL := $(DEVICE_PATH)/prebuilt/kernel
BOARD_MKBOOTIMG_ARGS          += --header_version $(BOARD_BOOT_HEADER_VERSION)
BOARD_MKBOOTIMG_ARGS          += --pagesize $(BOARD_KERNEL_PAGESIZE)
# TARGET_KERNEL_ARCH := arm64
# TARGET_KERNEL_HEADER_ARCH := arm64
# BOARD_KERNEL_BASE := 0x00000000

# Ramdisk use lz4
BOARD_RAMDISK_USE_LZ4 := true

# PRODUCT_OTA_ENFORCE_VINTF_KERNEL_REQUIREMENTS   := false
# PRODUCT_ENABLE_UFFD_GC                          := true

BOARD_EXCLUDE_KERNEL_FROM_RECOVERY_IMAGE := true

BOARD_USES_RECOVERY_AS_BOOT := false

# Real cmdline/bootconfig comes from boot/vendor_boot.
# Keep empty to avoid injecting guessed parameters into ramdisk-only recovery.
BOARD_KERNEL_CMDLINE := video=vfb:640x400,bpp=32,memsize=3072000 nosoftlockup bootconfig buildvariant=user

# -----------------------------------------------------------------------------
# 4. A/B / Virtual A/B
# Dedicated recovery_a / recovery_b partitions exist.
# -----------------------------------------------------------------------------
AB_OTA_UPDATER := true
# AB_OTA_PARTITIONS += \
#     boot \
#     dtbo \
#     init_boot \
#     odm \
#     product \
#     recovery \
#     system \
#     system_dlkm \
#     system_ext \
#     vbmeta \
#     vbmeta_system \
#     vbmeta_vendor \
#     vendor \
#     vendor_boot \
#     vendor_dlkm
AB_OTA_PARTITIONS += \
    boot \
    init_boot \
    vendor_boot \
    dtbo \
    vbmeta \
    vbmeta_system \
    odm \
    product \
    system \
    system_ext \
    system_dlkm \
    vendor \
    vendor_dlkm

# AB partitions for oplus
# AB_OTA_PARTITIONS += \
#     my_bigball \
#     my_carrier \
#     my_company \
#     my_engineering \
#     my_heytap \
#     my_manifest \
#     my_preload \
#     my_product \
#     my_region \
#     my_stock

BOARD_RECOVERY_NEEDS_BOOTLOADER_CONTROL := true

# Verified Boot
BOARD_AVB_ENABLE := true
# BOARD_AVB_MAKE_VBMETA_IMAGE_ARGS += --flags 3
# BOARD_AVB_RECOVERY_KEY_PATH := external/avb/test/data/testkey_rsa4096.pem
# BOARD_AVB_RECOVERY_ALGORITHM := SHA256_RSA4096
# BOARD_AVB_RECOVERY_ROLLBACK_INDEX := 1
# BOARD_AVB_RECOVERY_ROLLBACK_INDEX_LOCATION := 1
# BOARD_AVB_VENDOR_BOOT_KEY_PATH := external/avb/test/data/testkey_rsa4096.pem
# BOARD_AVB_VENDOR_BOOT_ALGORITHM := SHA256_RSA4096
# BOARD_AVB_VENDOR_BOOT_ROLLBACK_INDEX := 1
# BOARD_AVB_VENDOR_BOOT_ROLLBACK_INDEX_LOCATION := 1

# -----------------------------------------------------------------------------
# 6. Physical partition sizes
# -----------------------------------------------------------------------------
# BOARD_FLASH_BLOCK_SIZE := 262144 # (BOARD_KERNEL_PAGESIZE * 64)
# BOARD_BOOTIMAGE_PARTITION_SIZE := 201326592
BOARD_DTBOIMG_PARTITION_SIZE := 25165824
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 104857600
# BOARD_INIT_BOOT_IMAGE_PARTITION_SIZE := 8388608
BOARD_VENDOR_BOOTIMAGE_PARTITION_SIZE := 201326592

# Partitions
BOARD_PROPERTY_OVERRIDES_SPLIT_ENABLED := true
BOARD_SUPER_PARTITION_SIZE := 16106127360
BOARD_SUPER_PARTITION_GROUPS := qti_dynamic_partitions

BOARD_QTI_DYNAMIC_PARTITIONS_SIZE := 16101933056
BOARD_QTI_DYNAMIC_PARTITIONS_PARTITION_LIST := \
    system \
    system_ext \
    system_dlkm \
    product \
    vendor \
    vendor_dlkm \
    odm

# System as root
BOARD_ROOT_EXTRA_FOLDERS := bluetooth dsp firmware persist soccp

# Workaround for error copying vendor files to recovery ramdisk
TARGET_COPY_OUT_VENDOR := vendor

TARGET_COPY_OUT_ODM := odm
BOARD_ODMIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_USES_VENDOR_DLKMIMAGE := true
TARGET_COPY_OUT_VENDOR_DLKM := vendor_dlkm
BOARD_VENDOR_DLKMIMAGE_FILE_SYSTEM_TYPE := ext4

# File systems
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true

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
TARGET_SYSTEM_PROP += $(DEVICE_PATH)/system.prop

# Init
# TARGET_INIT_VENDOR_LIB := //$(DEVICE_PATH):libinit_oplus_ossi
# TARGET_RECOVERY_DEVICE_MODULES := libinit_oplus_ossi

# Crypto
TW_INCLUDE_CRYPTO := true
TW_INCLUDE_CRYPTO_FBE := true
TW_INCLUDE_FBE_METADATA_DECRYPT := true
BOARD_USES_METADATA_PARTITION := true
TW_INCLUDE_OMAPI := true
TW_USE_FSCRYPT_POLICY := 2
PLATFORM_VERSION := 99.87.36
PLATFORM_VERSION_LAST_STABLE := $(PLATFORM_VERSION)
PLATFORM_SECURITY_PATCH := 2099-12-31
VENDOR_SECURITY_PATCH := $(PLATFORM_SECURITY_PATCH)
BOOT_SECURITY_PATCH := $(PLATFORM_SECURITY_PATCH)

# Tool
TW_INCLUDE_7ZA := true
TW_INCLUDE_ZSTD := true
TW_INCLUDE_REPACKTOOLS := true
TW_INCLUDE_RESETPROP := true
TW_INCLUDE_LIBRESETPROP := true
TW_ENABLE_ALL_PARTITION_TOOLS := true

# Debug
TARGET_USES_LOGD := true
TWRP_INCLUDE_LOGCAT := true
TARGET_RECOVERY_DEVICE_MODULES += debuggerd
RECOVERY_BINARY_SOURCE_FILES += $(TARGET_OUT_EXECUTABLES)/debuggerd
TARGET_RECOVERY_DEVICE_MODULES += strace
RECOVERY_BINARY_SOURCE_FILES += $(TARGET_OUT_EXECUTABLES)/strace
TARGET_RECOVERY_DEVICE_MODULES += prebuilt

# Fastbootd
TW_INCLUDE_FASTBOOTD := true

# Other TWRP Configurations
TW_THEME := portrait_hdpi
TW_FRAMERATE := 60
RECOVERY_SDCARD_ON_DATA := true
TARGET_RECOVERY_QCOM_RTC_FIX := true
TW_EXCLUDE_DEFAULT_USB_INIT := true
TW_INCLUDE_NTFS_3G := true
TW_USE_DMCTL := true
TW_USE_TOOLBOX := true
TARGET_USES_MKE2FS := true
TW_INPUT_BLACKLIST := "hbtp_vm"
TW_BRIGHTNESS_PATH := "/sys/class/backlight/panel0-backlight/brightness"
TW_MAX_BRIGHTNESS := 2047
TW_EXTRA_LANGUAGES := false
TW_DEFAULT_BRIGHTNESS := 250
TW_EXCLUDE_APEX := true
TW_STATUS_ICONS_ALIGN := center
TW_SUPPORT_INPUT_AIDL_HAPTICS := true
TW_SUPPORT_INPUT_AIDL_HAPTICS_FIX_OFF := true
TW_USE_SERIALNO_PROPERTY_FOR_DEVICE_ID := true
TW_LOAD_VENDOR_MODULES := "adsp_loader_dlkm.ko rproc_qcom_common.ko q6_dlkm.ko qcom_q6v5.ko qcom_q6v5_pas.ko qcom_sysmon.ko synaptics_tcm2.ko nt38773_touch.ko nxp-nci.ko stm_st54se_gpio.ko stm_nfc_i2c.ko qcom-hv-haptics.ko cs40l26-i2c.ko"
TW_LOAD_VENDOR_MODULES_EXCLUDE_GKI := true
TW_CUSTOM_CPU_TEMP_PATH := "/sys/class/thermal/thermal_zone25/temp" # CPU-0-0-0
TW_BACKUP_EXCLUSIONS := /data/fonts,/data/adb/ap,/data/adb/ksu
