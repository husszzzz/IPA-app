# إعدادات الجهاز المستهدف
TARGET := iphone:clang:latest:14.0
ARCHS = arm64
DEBUG = 0
FINALPACKAGE = 1

include $(THEOS)/makefiles/common.mk

# اسم التطبيق والملفات التابعة
APPLICATION_NAME = MoonManager
MoonManager_FILES = main.m
MoonManager_FRAMEWORKS = UIKit CoreGraphics
MoonManager_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/application.mk
