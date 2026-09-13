#
# Copyright (C) 2026 The Android Open Source Project
# Copyright (C) 2026 SebaUbuntu's TWRP device tree generator
#
# SPDX-License-Identifier: Apache-2.0
#

# Configure base.mk
$(call inherit-product, $(SRC_TARGET_DIR)/product/base.mk)

# Configure core_64_bit_only.mk
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit_only.mk)

# Configure virtual_ab compression.mk
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota/compression_with_xor.mk)

# Configure emulated_storage.mk
$(call inherit-product, $(SRC_TARGET_DIR)/product/emulated_storage.mk)

# Configure twrp common.mk
$(call inherit-product, vendor/twrp/config/common.mk)

# A/B
AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_system=true \
    POSTINSTALL_PATH_system=system/bin/otapreopt_script \
    FILESYSTEM_TYPE_system=ext4 \
    POSTINSTALL_OPTIONAL_system=true

# Shipping API level
BOARD_SHIPPING_API_LEVEL    := 33
PRODUCT_SHIPPING_API_LEVEL  := 33
PRODUCT_TARGET_VNDK_VERSION := 33

# Boot control HAL
PRODUCT_PACKAGES += \
    android.hardware.boot@1.0-impl \
    android.hardware.boot@1.0-service

PRODUCT_PACKAGES += \
    bootctrl.kalama

PRODUCT_PACKAGES += \
    libgptutils \
    libz \
    libcutils

PRODUCT_PACKAGES += \
    otapreopt_script \
    cppreopts.sh \
    update_engine \
    update_verifier \
    update_engine_sideload

PRODUCT_SOONG_NAMESPACES += $(DEVICE_PATH)

# OTA certs
PRODUCT_EXTRA_RECOVERY_KEYS += \
	$(DEVICE_PATH)/security/local_OTA

PRODUCT_OTA_ENFORCE_VINTF_KERNEL_REQUIREMENTS   := false
PRODUCT_ENABLE_UFFD_GC                          := true

# Copy prebuilt vendor recovery binaries
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/recovery/root/vendor/bin/hw/vendor.qti.hardware.vibrator.service:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/bin/hw/vendor.qti.hardware.vibrator.service \
    $(LOCAL_PATH)/recovery/root/vendor/etc/init/vendor.qti.hardware.vibrator.service.rc:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/etc/init/vendor.qti.hardware.vibrator.service.rc

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/recovery/root/vendor/lib64/vendor.qti.hardware.qseecom@1.0.so:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/lib64/vendor.qti.hardware.qseecom@1.0.so