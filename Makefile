THEOS_DEVICE_IP=localhost
THEOS_DEVICE_PORT=2222
DEBUG = 0
FINALPACKAGE = 1
MINIMUM_OS_VERSION = 15.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = OverImageTweak
OverImageTweak_FILES = Tweak.xm OverImageOverlayView.mm OverImageManager.mm
OverImageTweak_CFLAGS = -fobjc-arc
OverImageTweak_FRAMEWORKS = UIKit CoreGraphics AVFoundation Photos
OverImageTweak_PRIVATE_FRAMEWORKS = GraphicsServices

include $(THEOS_MAKE_PATH)/tweak.mk
