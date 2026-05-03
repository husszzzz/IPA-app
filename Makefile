TARGET := iphone:clang:latest:14.0
ARCHS = arm64
DEBUG = 0
FINALPACKAGE = 1

include $(THEOS)/makefiles/common.mk

APPLICATION_NAME = HassanyApp
HassanyApp_FILES = main.m
HassanyApp_FRAMEWORKS = UIKit CoreGraphics
HassanyApp_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/application.mk
