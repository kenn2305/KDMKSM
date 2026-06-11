#!/bin/bash
# OverImage Tweak - Project Structure and File Reference

cat << 'EOF'

╔══════════════════════════════════════════════════════════════════════╗
║          OverImage Tweak - iOS 18 Image Overlay System              ║
║                       Project Complete                               ║
╚══════════════════════════════════════════════════════════════════════╝

📁 PROJECT STRUCTURE:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

OverImageTweak/
│
├── 📄 Core Source Files
│   ├── Tweak.xm                 → Main tweak hooks (Logos syntax)
│   ├── OverImageOverlayView.mm   → Custom UIView with gestures
│   ├── OverImageOverlayView.h    → Header declarations
│   ├── OverImageManager.mm       → Overlay lifecycle manager
│   ├── OverImageManager.h        → Manager interface
│   └── OverImage.h               → Main include header
│
├── 🔧 Build Configuration
│   ├── Makefile                  → Primary build config (use this)
│   ├── Makefile.advanced         → Advanced options
│   ├── build.sh                  → Automated build script
│   └── deploy.sh                 → Device deployment script
│
├── 📚 Documentation
│   ├── README.md                 → English documentation
│   ├── GUIDE.md                  → Vietnamese complete guide
│   ├── QUICKSTART.md             → Quick reference guide
│   ├── EXAMPLES.h                → Usage code examples
│   ├── PROJECT_INFO.sh           → This file
│   └── structure.txt             → Project structure (this output)
│
├── 📦 Package Configuration
│   └── layout/DEBIAN/
│       ├── control               → Package metadata
│       ├── control.extended      → Extended info
│       ├── postinst              → Post-install script
│       └── preinst               → Pre-install script
│
└── 🎯 Generated (after build)
    ├── .theos/                   → Build directory
    ├── packages/                 → Built .deb files
    └── OverImageTweak.dylib      → Compiled tweak binary


📋 FILE DESCRIPTIONS:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🔴 TWEAK.XM
   - Main entry point for the tweak
   - Uses Logos syntax for method hooking
   - Hooks SpringBoard, UIApplication, and other system classes
   - Provides global functions: AddImageOverlay(), RemoveImageOverlay(), etc.
   - Lines: ~60

🔴 OVERIMAGEOVERLAYVIEW.MM/H
   - Custom UIView for displaying and controlling images
   - Implements gesture recognizers:
     • UIPanGestureRecognizer - Drag to move
     • UIPinchGestureRecognizer - Pinch to zoom
     • UITapGestureRecognizer - Tap to toggle visibility
   - Constraints overlay within screen bounds
   - Animates visibility toggle
   - Lines: ~200 combined

🔴 OVERIMAGEMANAGER.MM/H
   - Singleton manager for overlay lifecycle
   - Creates and manages overlay window (UIWindow)
   - Implements image picker delegate
   - Handles overlay creation/removal
   - Lines: ~100 combined

🔴 MAKEFILE
   - Theos build configuration
   - Specifies source files, frameworks, and compiler flags
   - ARC enabled, optimization level O3
   - Target: iOS 18 arm64/arm64e
   - USE THIS FILE FOR BUILDING

🔴 BUILD.SH
   - Convenience script for building
   - Cleans previous builds, creates directories
   - Runs make package

🔴 DEPLOY.SH
   - Automated deployment to iOS device via SSH
   - Takes device IP, port, username, password as arguments
   - Builds, copies, installs, and restarts SpringBoard
   - Usage: bash deploy.sh 192.168.1.100 22 root alpine


🎯 KEY FEATURES IMPLEMENTED:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✓ Floating Image Overlay
  - Displays on top of all apps
  - Global window with high Z-order
  - Survives app switching

✓ Gesture Controls
  - Drag/Pan: Move overlay anywhere on screen
  - Pinch: Zoom 0.5x to 3.0x
  - Tap outside: Toggle visibility (show/hide)

✓ Image Handling
  - Original resolution preserved
  - Maintains aspect ratio
  - Supports PNG, JPG, and other iOS formats
  - Smooth scaling without artifacts

✓ Boundary Management
  - Overlay constrained within screen bounds
  - Prevents going off-screen
  - Respects safe areas

✓ Clean Presentation
  - No shadows applied
  - No borders or decorations
  - Transparent background
  - Minimal UI footprint

✓ Global Availability
  - Works in all apps simultaneously
  - Can be accessed from anywhere
  - Persistent across reboots (after install)


🚀 QUICK START COMMANDS:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Build Package:
  $ cd OverImageTweak
  $ make package

Install to Device (requires SSH):
  $ make package install
  or
  $ bash deploy.sh 192.168.1.100 22 root alpine

View Build Artifacts:
  $ find . -name "*.deb"

Restart SpringBoard (apply changes):
  $ ssh root@192.168.1.100 killall -9 SpringBoard

Clean Build:
  $ make clean
  $ make package


📖 USAGE EXAMPLES:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Add Image:
  #import "OverImage.h"
  UIImage *img = [UIImage imageNamed:@"test"];
  [[OverImageManager sharedManager] addImageOverlayWithImage:img];

Remove Overlay:
  [[OverImageManager sharedManager] removeImageOverlay];

Get Current Overlay:
  OverImageOverlayView *current = 
    [[OverImageManager sharedManager] currentOverlayView];

Toggle Visibility:
  [current toggleVisibility];

See EXAMPLES.h for more detailed examples.


⚙️ CUSTOMIZATION:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Zoom Range:
  File: OverImageOverlayView.mm, ~line 120
  scale = MAX(0.5, MIN(scale, 3.0));

Initial Size:
  File: OverImageOverlayView.mm, ~line 50
  CGFloat maxWidth = 300;
  CGFloat maxHeight = 400;

Initial Position:
  File: OverImageManager.mm, ~line 35
  CGRect initialFrame = CGRectMake(50, 100, 300, 400);

Animation Duration:
  File: OverImageOverlayView.mm, ~line 155
  [UIView animateWithDuration:0.2 animations:^{...}];


📋 REQUIREMENTS:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Device:
  - iOS 18.0 or later
  - Jailbroken (must have MobileSubstrate)
  - arm64 or arm64e architecture

Development:
  - Theos framework
  - Clang compiler
  - SSH access to device
  - Knowledge of Objective-C/Logos

Frameworks:
  - UIKit
  - CoreGraphics
  - AVFoundation
  - Photos
  - GraphicsServices


🔐 INSTALLATION:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Option 1: Using Theos (Recommended)
  $ make package install

Option 2: Using Deploy Script
  $ bash deploy.sh [IP] [PORT] [USER] [PASS]

Option 3: Manual Installation
  1. Build: make package
  2. Copy: scp *.deb root@device:/var/mobile/
  3. Install: ssh root@device dpkg -i /var/mobile/*.deb
  4. Reload: ssh root@device killall -9 SpringBoard

Option 4: Using Sileo/Cydia
  1. Copy .deb to device
  2. Open Sileo/Cydia
  3. Select "Install from file"


🎮 GESTURES & CONTROLS:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Drag (Pan):
  - Tap and hold on image
  - Drag to new position
  - Constrained to screen bounds

Zoom (Pinch):
  - Place two fingers on image
  - Pinch in: Zoom out (minimum 0.5x)
  - Pinch out: Zoom in (maximum 3.0x)

Toggle Visibility:
  - Tap anywhere outside the image bounds
  - Image fades out (hidden)
  - Tap outside again to show
  - Smooth 0.2s animation


🐛 TROUBLESHOOTING:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Issue: Tweak not loading
Fix:
  1. Verify: /Library/MobileSubstrate/DynamicLibraries/OverImageTweak.dylib
  2. Restart: killall -9 SpringBoard
  3. Check: dpkg -l | grep OverImageTweak

Issue: Image not showing
Fix:
  1. Ensure image is not nil
  2. Verify image format (PNG/JPG)
  3. Check frame size > 0

Issue: Gestures not responding
Fix:
  1. Verify userInteractionEnabled = YES
  2. Check gesture recognizers added
  3. Verify overlay is visible

Issue: Overlay disappears when app opens
Fix:
  - This is normal - window system behavior
  - Tap to show overlay again
  - Or modify window level for persistent display


📚 DOCUMENTATION FILES:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

README.md
  - English documentation
  - Features overview
  - Basic installation

GUIDE.md
  - Vietnamese complete guide
  - Detailed setup instructions
  - API reference
  - Customization examples
  - Troubleshooting

QUICKSTART.md
  - Quick reference
  - Common commands
  - Short examples
  - Troubleshooting quick fixes

EXAMPLES.h
  - Usage code examples
  - Integration patterns
  - Advanced techniques

PROJECT_INFO.sh
  - This file
  - Project overview
  - File reference


🔧 BUILD SYSTEM:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Makefile Variables:
  TWEAK_NAME = OverImageTweak
  TARGET = iOS 18.0+
  ARCHS = arm64 arm64e
  CFLAGS = -fobjc-arc -O3
  FRAMEWORKS = UIKit, CoreGraphics, AVFoundation, Photos, GraphicsServices

Build Targets:
  make                    → Builds dylib
  make package            → Creates .deb package
  make clean              → Removes build artifacts
  make package install    → Builds and installs to device
  make after-package      → Runs after package creation

Output Files:
  .theos/obj/debug/ → Object files
  .theos/deb/ → Package staging
  packages/*.deb → Installable package


⚖️ LICENSE & NOTES:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Type: Private/Jailbreak Tweak
Version: 1.0.0
iOS Support: 18.0+
Arch: arm64/arm64e only

Notes:
  - Requires jailbroken device
  - Use responsibly
  - Not intended for App Store distribution
  - Modify source as needed for your use case


📞 SUPPORT:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

For issues:
  1. Check GUIDE.md troubleshooting section
  2. Review EXAMPLES.h for integration patterns
  3. Modify source files as needed
  4. Rebuild and test

For new features:
  1. Edit source files
  2. Rebuild: make clean && make package
  3. Reinstall and test


════════════════════════════════════════════════════════════════════════

Generated: 2026-06-11
Project Status: ✅ Complete and Ready for Use

════════════════════════════════════════════════════════════════════════

EOF
