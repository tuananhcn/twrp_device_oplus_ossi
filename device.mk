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

# Configure emulated_storage.mk
$(call inherit-product, $(SRC_TARGET_DIR)/product/emulated_storage.mk)

# Installs gsi keys into ramdisk, to boot a GSI with verified boot.
$(call inherit-product, $(SRC_TARGET_DIR)/product/gsi_keys.mk)

# Virtual A/B
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota.mk)
# A/B
# AB_OTA_POSTINSTALL_CONFIG += \
#     RUN_POSTINSTALL_system=true \
#     POSTINSTALL_PATH_system=system/bin/otapreopt_script \
#     FILESYSTEM_TYPE_system=ext4 \
#     POSTINSTALL_OPTIONAL_system=true

# Shipping API level
BOARD_SHIPPING_API_LEVEL := 31
BOARD_API_LEVEL := 31
SHIPPING_API_LEVEL := 31
PRODUCT_SHIPPING_API_LEVEL := 31

# Boot control HAL
PRODUCT_PACKAGES += \
    android.hardware.boot@1.2-impl \
    android.hardware.boot@1.2-impl.recovery \
    android.hardware.boot@1.2-service

PRODUCT_PACKAGES += \
    bootctrl.kalama

# fastbootd
PRODUCT_PACKAGES += \
    android.hardware.fastboot@1.1-impl-mock \
    fastbootd

# Health
PRODUCT_PACKAGES += \
    android.hardware.health@2.1-impl \
    android.hardware.health@2.1-service

# Kernel
PRODUCT_ENABLE_UFFD_GC := true

# Overlays
PRODUCT_ENFORCE_RRO_TARGETS := *

# Partitions
PRODUCT_USE_DYNAMIC_PARTITIONS := true

# Product characteristics
PRODUCT_CHARACTERISTICS := nosdcard

PRODUCT_PACKAGES += \
    libgptutils \
    libz \
    libcutils

# PRODUCT_PACKAGES += \
#     otapreopt_script \
#     cppreopts.sh \
#     update_engine \
#     update_verifier \
#     update_engine_sideload

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

# qcom decryption
PRODUCT_PACKAGES += \
    qcom_decrypt \
    qcom_decrypt_fbe