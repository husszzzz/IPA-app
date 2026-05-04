TARGET := iphone:clang:latest:14.0
ARCHS = arm64

include $(THEOS)/makefiles/common.mk

APPLICATION_NAME = MoonHearBoost
MoonHearBoost_FILES = main.m
# أضفنا AVFoundation هنا
MoonHearBoost_FRAMEWORKS = UIKit AVFoundation 
MoonHearBoost_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/application.mk
