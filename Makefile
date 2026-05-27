TARGET := iphone:clang:latest:14.0
ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

APPLICATION_NAME = HassanyGame
HassanyGame_FILES = main.m
HassanyGame_FRAMEWORKS = UIKit AVFoundation CoreGraphics

include $(THEOS_MAKE_PATH)/application.mk
