TARGET := iphone:clang:latest:14.0
ARCHS = arm64
DEBUG = 0
FINALPACKAGE = 1

include $(THEOS)/makefiles/common.mk

APPLICATION_NAME = HassanyBoost
HassanyBoost_FILES = main.m
HassanyBoost_FRAMEWORKS = UIKit AVFoundation AudioToolbox
HassanyBoost_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/application.mk
