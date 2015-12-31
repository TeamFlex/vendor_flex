# Inherit common stuff
$(call inherit-product, vendor/flex/config/common.mk)
$(call inherit-product, vendor/flex/config/common_apn.mk)

# SIM Toolkit
PRODUCT_PACKAGES += \
    Stk
