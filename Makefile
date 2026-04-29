TARGET := iphone:clang:latest:14.0
INSTALL_TARGET_PROCESSES = MoonManager

include $(THEOS)/makefiles/common.mk

APPLICATION_NAME = MoonManager

# لاحظ هنا: استدعينا فقط ملف main.m لأن كل الكود صار داخله
MoonManager_FILES = main.m
MoonManager_FRAMEWORKS = UIKit CoreGraphics
MoonManager_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/application.mk
