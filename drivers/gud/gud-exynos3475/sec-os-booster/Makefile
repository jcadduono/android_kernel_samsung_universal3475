#
# Makefile for Secure OS booster API
#
obj-$(CONFIG_SECURE_OS_BOOSTER_API) += sec_os_booster.o

# MobiCore kernel driver path
GUD_ROOT_FOLDER := $(srctree)/drivers/gud/gud-exynos3475

MOBICORE_PLATFORM := EXYNOS_3475_STD

ccflags-y += -I$(GUD_ROOT_FOLDER)/MobiCoreDriver/platforms/$(MOBICORE_PLATFORM)

# Includes MobiCore kernel driver
ccflags-y += -I$(GUD_ROOT_FOLDER)/MobiCoreDriver
ccflags-y += -I$(GUD_ROOT_FOLDER)/MobiCoreDriver/public
