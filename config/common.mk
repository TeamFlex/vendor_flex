PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

ifeq ($(PRODUCT_GMS_CLIENTID_BASE),)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=android-google
else
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=$(PRODUCT_GMS_CLIENTID_BASE)
endif

PRODUCT_PROPERTY_OVERRIDES += \
    keyguard.no_require_sim=true \
    ro.url.legal=http://www.google.com/intl/%s/mobile/android/basic/phone-legal.html \
    ro.url.legal.android_privacy=http://www.google.com/intl/%s/mobile/android/basic/privacy.html \
    ro.com.android.wifi-watchlist=GoogleGuest \
    ro.setupwizard.enterprise_mode=1 \
    ro.com.android.dateformat=MM-dd-yyyy \
    ro.com.android.dataroaming=false

PRODUCT_PROPERTY_OVERRIDES += \
    ro.build.selinux=1

# Disable excessive dalvik debug messages
PRODUCT_PROPERTY_OVERRIDES += \
    dalvik.vm.debug.alloc=0

# Backup Tool
PRODUCT_COPY_FILES += \
    vendor/flex/prebuilt/common/bin/backuptool.sh:install/bin/backuptool.sh \
    vendor/flex/prebuilt/common/bin/backuptool.functions:install/bin/backuptool.functions \
    vendor/flex/prebuilt/common/bin/50-flex.sh:system/addon.d/50-flex.sh

# Signature compatibility validation
PRODUCT_COPY_FILES += \
    vendor/flex/prebuilt/common/bin/otasigcheck.sh:install/bin/otasigcheck.sh

# flex-specific init file
PRODUCT_COPY_FILES += \
    vendor/flex/prebuilt/common/etc/init.local.rc:root/init.flex.rc

# Copy latinime for gesture typing
PRODUCT_COPY_FILES += \
    vendor/flex/prebuilt/common/lib/libjni_latinimegoogle.so:system/lib/libjni_latinimegoogle.so

# SELinux filesystem labels
PRODUCT_COPY_FILES += \
    vendor/flex/prebuilt/common/etc/init.d/50selinuxrelabel:system/etc/init.d/50selinuxrelabel

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml

# Don't export PS1 in /system/etc/mkshrc.
PRODUCT_COPY_FILES += \
    vendor/flex/prebuilt/common/etc/mkshrc:system/etc/mkshrc \
    vendor/flex/prebuilt/common/etc/sysctl.conf:system/etc/sysctl.conf

PRODUCT_COPY_FILES += \
    vendor/flex/prebuilt/common/etc/init.d/00banner:system/etc/init.d/00banner \
    vendor/flex/prebuilt/common/etc/init.d/90userinit:system/etc/init.d/90userinit \
    vendor/flex/prebuilt/common/bin/sysinit:system/bin/sysinit

# Required packages
PRODUCT_PACKAGES += \
    Development \
    SpareParts \
    su

# Optional packages
PRODUCT_PACKAGES += \
    Basic \
    LiveWallpapersPicker \
    PhaseBeam

# Extra Optional packages
PRODUCT_PACKAGES += \
    SlimLauncher \
    LatinIME \
    BluetoothExt

# Some daily-usage applications
PRODUCT_PACKAGES += \
    Eleven \
    messaging 
    
# Extra tools
PRODUCT_PACKAGES += \
    openvpn \
    e2fsck \
    mke2fs \
    tune2fs \
    mkfs.ntfs \
    fsck.ntfs \
    mount.ntfs

WITH_EXFAT ?= true
ifeq ($(WITH_EXFAT),true)
TARGET_USES_EXFAT := true
PRODUCT_PACKAGES += \
    mount.exfat \
    fsck.exfat \
    mkfs.exfat
endif

# Stagefright FFMPEG plugin
PRODUCT_PACKAGES += \
    libffmpeg_extractor \
    libffmpeg_omx \
    media_codecs_ffmpeg.xml

PRODUCT_PROPERTY_OVERRIDES += \
    media.sf.omx-plugin=libffmpeg_omx.so \
    media.sf.extractor-plugin=libffmpeg_extractor.so

# Layers Manager
PRODUCT_COPY_FILES += \
vendor/flex/prebuilt/common/app/LayersManager/layersmanager.apk:system/app/LayersManager/layersmanager.apk

# SuperSU
PRODUCT_COPY_FILES += \
   vendor/flex/prebuilt/common/etc/UPDATE-SuperSU.zip:system/addon.d/UPDATE-SuperSU.zip \
   vendor/flex/prebuilt/common/etc/init.d/99SuperSUDaemon:system/etc/init.d/99SuperSUDaemon

PRODUCT_PACKAGE_OVERLAYS += vendor/flex/overlay/common

# Include LatinIME dictionaries
PRODUCT_PACKAGE_OVERLAYS += vendor/flex/overlay/dictionaries

#Bootanimation

# Boot animation include
ifneq ($(TARGET_SCREEN_WIDTH) $(TARGET_SCREEN_HEIGHT),$(space))

# determine the smaller dimension
TARGET_BOOTANIMATION_SIZE := $(shell \
  if [ $(TARGET_SCREEN_WIDTH) -lt $(TARGET_SCREEN_HEIGHT) ]; then \
    echo $(TARGET_SCREEN_WIDTH); \
  else \
    echo $(TARGET_SCREEN_HEIGHT); \
  fi )

# get a sorted list of the sizes
bootanimation_sizes := $(subst .zip,, $(shell ls vendor/flex/prebuilt/common/bootanimation))
bootanimation_sizes := $(shell echo -e $(subst $(space),'\n',$(bootanimation_sizes)) | sort -rn)

# find the appropriate size and set
define check_and_set_bootanimation
$(eval TARGET_BOOTANIMATION_NAME := $(shell \
  if [ -z "$(TARGET_BOOTANIMATION_NAME)" ]; then
    if [ $(1) -le $(TARGET_BOOTANIMATION_SIZE) ]; then \
      echo $(1); \
      exit 0; \
    fi;
  fi;
  echo $(TARGET_BOOTANIMATION_NAME); ))
endef
$(foreach size,$(bootanimation_sizes), $(call check_and_set_bootanimation,$(size)))

ifeq ($(TARGET_BOOTANIMATION_HALF_RES),true)
    PRODUCT_COPY_FILES += \
        vendor/flex/prebuilt/common/bootanimation/halfres/$(TARGET_BOOTANIMATION_NAME).zip:system/media/bootanimation.zip
else
    PRODUCT_COPY_FILES += \
        vendor/flex/prebuilt/common/bootanimation/$(TARGET_BOOTANIMATION_NAME).zip:system/media/bootanimation.zip
endif
endif

# Versioning System
# FlayrOS first version.
PRODUCT_VERSION_MAJOR = 1
PRODUCT_VERSION_MINOR = 0
PRODUCT_VERSION_MAINTENANCE = 1.0
FLEX_BUILD_TYPE ?= UNOFFICIAL

PLATFORM_VERSION_CODENAME := $(FLEX_BUILD_TYPE)

# Set all versions
FLEX_VERSION := FlayrOS-M-$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(FLEX_BUILD)-$(FLEX_BUILD_TYPE)-$(shell date +%Y%M%d)
FLEX_MOD_VERSION := $(FLEX_VERSION)

PRODUCT_PROPERTY_OVERRIDES += \
    BUILD_DISPLAY_ID=$(BUILD_ID) \
    flex.ota.version=$(shell date +%Y%m%d) \
    ro.flex.version=$(FLEX_VERSION) \
    ro.modversion=$(FLEX_MOD_VERSION) \
    ro.flex.buildtype=$(FLEX_BUILD_TYPE)


