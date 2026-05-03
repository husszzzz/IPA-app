TARGET := iphone:clang:latest:14.0
ARCHS = arm64

include $(THEOS)/makefiles/common.mk

APPLICATION_NAME = MoonManager
MoonManager_FILES = main.m
MoonManager_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/application.mk
