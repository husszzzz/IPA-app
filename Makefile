TARGET := iphone:clang:latest:15.0
ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

APPLICATION_NAME = HassanyGame
HassanyGame_FILES = main.m AppDelegate.m RootViewController.m
HassanyGame_FRAMEWORKS = UIKit AVFoundation QuartzCore CoreGraphics AudioToolbox

include $(THEOS)/makefiles/application.mk
