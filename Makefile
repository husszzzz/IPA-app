TARGET := iphone:clang:latest:14.0
ARCHS = arm64
DEBUG = 0
FINALPACKAGE = 1

include $(THEOS)/makefiles/common.mk

APPLICATION_NAME = MoonHearBoost
MoonHearBoost_FILES = main.m
MoonHearBoost_FRAMEWORKS = UIKit AVFoundation
MoonHearBoost_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/application.mk
