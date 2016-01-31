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
    CellBroadcastReceiver \
    Development \
    SpareParts \
    su

# Optional packages
PRODUCT_PACKAGES += \
    Basic \
    LiveWallpapersPicker \
    PhaseBeam

# AudioFX
PRODUCT_PACKAGES += \
    AudioFX

# Extra Optional packages
PRODUCT_PACKAGES += \
    Launcher3 \
    LatinIME \
    BluetoothExt \
    DashClock

# Some daily-usage applications
PRODUCT_PACKAGES += \
    Apollo \
    messaging 
    
# Extra tools
PRODUCT_PACKAGES += \
    openvpn \
    e2fsck \
    mke2fs \
    tune2fs \
    mount.exfat \
    fsck.exfat \
    mkfs.exfat \
    ntfsfix \
    ntfs-3g

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

# easy way to extend to add more packages
-include vendor/extra/product.mk

PRODUCT_PACKAGE_OVERLAYS += vendor/flex/overlay/common

#Bootanimation
 $(LOCAL_PATH)/media/bootanimation.zip:system/media/bootanimation.zip


# Versioning System
# FlexOS first version.
PRODUCT_VERSION_MAJOR = 6.0.1
PRODUCT_VERSION_MINOR = initial
PRODUCT_VERSION_MAINTENANCE = 1.0
ifdef FLEX_BUILD_EXTRA
    FLEX_POSTFIX := -$(FLEX_BUILD_EXTRA)
endif
ifndef FLEX_BUILD_TYPE
    FLEX_BUILD_TYPE := UNOFFICIAL
    PLATFORM_VERSION_CODENAME := UNOFFICIAL
endif

ifeq ($(FLEX_BUILD_TYPE),DM)
    FLEX_POSTFIX := -$(shell date +"%Y%m%d")
endif

ifndef FLEX_POSTFIX
    FLEX_POSTFIX := -$(shell date +"%Y%m%d")
endif

PLATFORM_VERSION_CODENAME := $(FLEX_BUILD_TYPE)

# Set all versions
FLEX_VERSION := FlayrOS-$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(PRODUCT_VERSION_MAINTENANCE)-$(FLEX_BUILD_TYPE)$(FLEX_POSTFIX)
FLEX_MOD_VERSION := FlayrOS-$(FLEX_BUILD)-$(PRODUCT_VERSION_MAINTENANCE)-$(FLEX_BUILD_TYPE)$(FLEX_POSTFIX)

PRODUCT_PROPERTY_OVERRIDES += \
    BUILD_DISPLAY_ID=$(BUILD_ID) \
    flex.ota.version=$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(PRODUCT_VERSION_MAINTENANCE) \
    ro.flex.version=$(FLEX_VERSION) \
    ro.modversion=$(FLEX_MOD_VERSION) \
    ro.flex.buildtype=$(FLEX_BUILD_TYPE)

EXTENDED_POST_PROCESS_PROPS := vendor/flex/tools/flex_process_props.py

