TARGET := iphone:clang:latest:14.0
ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = IPA-app
IPA-app_FILES = main.m
IPA-app_FRAMEWORKS = UIKit AVFoundation CoreGraphics

include $(THEOS_MAKE_PATH)/tweak.mk
