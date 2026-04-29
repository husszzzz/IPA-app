TARGET := iphone:clang:latest:14.0
INSTALL_TARGET_PROCESSES = MoonManager

include $(THEOS)/makefiles/common.mk

APPLICATION_NAME = MoonManager
MoonManager_FILES = main.m MoonAppDelegate.m MoonRootViewController.m
MoonManager_FRAMEWORKS = UIKit CoreGraphics
MoonManager_CFLAGS = -fobjc-arc

include $(THEOS)/makefiles/application.mk
