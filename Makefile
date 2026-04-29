TARGET := iphone:clang:latest:14.0
INSTALL_TARGET_PROCESSES = MoonManager

include $(THEOS)/makefiles/common.mk

APPLICATION_NAME = MoonManager
MoonManager_FILES = main.m
MoonManager_FRAMEWORKS = UIKit CoreGraphics
MoonManager_CFLAGS = -fobjc-arc
# هذا السطر يضمن بناء هيكلية المجلدات بشكل صحيح
MoonManager_INSTALL_PATH = /Applications

include $(THEOS_MAKE_PATH)/application.mk
