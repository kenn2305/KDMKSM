# Quick Reference - OverImage Tweak

## 🚀 Quick Start

### Build
```bash
cd OverImageTweak
make package
```

### Install to Device
```bash
# Option 1: Direct Theos install
make package install

# Option 2: Using deploy script
bash deploy.sh [IP] [PORT] [USER] [PASS]
# Example: bash deploy.sh 192.168.1.100 22 root alpine

# Option 3: Manual SCP + SSH
scp -P 22 *.deb root@192.168.1.100:/var/mobile/Media/
ssh -p 22 root@192.168.1.100
dpkg -i /var/mobile/Media/*.deb
killall -9 SpringBoard
```

## 📱 Usage

```objc
#import "OverImage.h"

// Add image
[[OverImageManager sharedManager] addImageOverlayWithImage:image];

// Remove
[[OverImageManager sharedManager] removeImageOverlay];

// Get current overlay
OverImageOverlayView *overlay = [[OverImageManager sharedManager] currentOverlayView];

// Toggle visibility
[overlay toggleVisibility];
```

## 🎮 Gestures

| Gesture | Action |
|---------|--------|
| Drag | Move overlay |
| Pinch | Zoom (0.5x - 3.0x) |
| Tap Outside | Toggle show/hide |

## 🛠️ Customization

### Zoom Range (OverImageOverlayView.mm)
```objc
scale = MAX(0.5, MIN(scale, 3.0));  // Change limits
```

### Initial Size (OverImageOverlayView.mm)
```objc
CGFloat maxWidth = 300;
CGFloat maxHeight = 400;
```

### Initial Position (OverImageManager.mm)
```objc
CGRect initialFrame = CGRectMake(50, 100, 300, 400);
```

## 📋 Requirements

- iOS 18+ jailbroken
- Theos installed
- arm64/arm64e device
- SSH access enabled

## 🔄 Rebuild & Reinstall

```bash
# Clean and rebuild
make clean
make package
make package install

# Restart SpringBoard to reload
ssh -p 22 root@192.168.1.100 "killall -9 SpringBoard"
```

## 📂 Project Files

| File | Purpose |
|------|---------|
| Tweak.xm | Main hooks |
| OverImageOverlayView.mm | Overlay UIView |
| OverImageManager.mm | Manager |
| Makefile | Build config |
| build.sh | Build script |
| deploy.sh | Deploy script |

## ⚙️ Environment Variables

```bash
export THEOS_DEVICE_IP=192.168.x.x
export THEOS_DEVICE_PORT=22
export THEOS=~/theos
export PATH=$THEOS/bin:$PATH
```

## 🐛 Common Issues

**Tweak not working:**
- Check: `/Library/MobileSubstrate/DynamicLibraries/OverImageTweak.dylib`
- Restart: `killall -9 SpringBoard`

**Image not showing:**
- Verify image is not nil
- Check image format (PNG/JPG)

**Gesture not working:**
- Ensure `userInteractionEnabled = YES`
- Check gesture recognizers are added

## 📞 Logs

Enable logs by changing DEBUG in Makefile:
```makefile
DEBUG = 1
```

View device logs:
```bash
ssh -p 22 root@192.168.1.100 "tail -f /var/log/system.log"
```

---

**Version:** 1.0.0  
**iOS:** 18.0+  
**Architecture:** arm64/arm64e
