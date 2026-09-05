#
# Copyright (C) 2026 The Android Open Source Project
# Copyright (C) 2026 SebaUbuntu's TWRP device tree generator
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from ossi device
$(call inherit-product, $(DEVICE_PATH)/device.mk)

PRODUCT_DEVICE := ossi
PRODUCT_NAME := twrp_ossi
PRODUCT_BRAND := oplus
PRODUCT_MODEL := ossi
PRODUCT_MANUFACTURER := oplus

PRODUCT_GMS_CLIENTID_BASE := android-oplus

PRODUCT_BUILD_PROP_OVERRIDES += \
    PRIVATE_BUILD_DESC="kalama-user 13 TP1A.220905.001 1778380079394 release-keys"

BUILD_FINGERPRINT := oplus/ossi/ossi:13/TP1A.220905.001/1778380079394:user/release-keys
