# OverImage Tweak - iOS 18 Image Overlay System

## Tính Năng (Features)

- **Hiển thị ảnh lên màn hình** - Display images as floating overlay on top of all apps
- **Phóng to/Thu nhỏ** - Zoom in/out using pinch gesture (0.5x to 3x)
- **Di chuyển tự do** - Drag overlay to any position on screen
- **Bấm bên ngoài để ẩn/hiện** - Tap outside the image to toggle visibility
- **Độ phân giải gốc** - Original image resolution preserved
- **Không đổ bóng/viền** - No shadows or borders, clean display
- **Hoạt động trên tất cả ứng dụng** - Works globally across all apps

## Installation

### Requirements
- iOS 18+
- Jailbroken device
- Theos installed on development machine
- ARM64 device support

### Build & Install

```bash
cd OverImageTweak
make package
make package install
```

## Usage

### Add Image Overlay
```objc
#import "OverImageManager.h"

UIImage *image = [UIImage imageNamed:@"myImage"];
[[OverImageManager sharedManager] addImageOverlayWithImage:image];
```

### Global Functions Available

```objc
// Add image to overlay
void AddImageOverlay(UIImage *image);

// Add image from clipboard
void AddImageFromPasteboard();

// Remove overlay
void RemoveImageOverlay();

// Toggle visibility
void ToggleImageVisibility();
```

## Gesture Controls

| Gesture | Action |
|---------|--------|
| **Drag** | Move overlay to different position |
| **Pinch** | Zoom in/out (0.5x - 3x) |
| **Tap Outside** | Toggle visibility (show/hide) |

## Architecture

### Files

1. **Tweak.xm** - Main tweak hooks for global functionality
2. **OverImageOverlayView.mm** - Custom UIView for image overlay with gestures
3. **OverImageManager.mm** - Manager for overlay creation and control
4. **Makefile** - Build configuration
5. **control** - Package control file

### Key Components

- `OverImageOverlayView` - Custom UIView handling:
  - Image display at original resolution
  - Pan gesture for movement
  - Pinch gesture for zooming
  - Tap detection for visibility toggle
  - Boundary constraints

- `OverImageManager` - Singleton managing:
  - Overlay window creation
  - Image picker integration
  - Overlay lifecycle

## Configuration

Modify these values in `OverImageOverlayView.mm`:

```objc
CGFloat maxWidth = 300;      // Maximum initial width
CGFloat maxHeight = 400;     // Maximum initial height
CGFloat minScale = 0.5;      // Minimum zoom level
CGFloat maxScale = 3.0;      // Maximum zoom level
```

## Notes

- No shadows or borders applied (clean look)
- Images maintain original aspect ratio
- Overlay persists across app switches
- All interactions are gesture-based
- Window level set to `UIWindowLevelAlert + 1` for top display

## Development

To modify behavior:
1. Edit gesture handlers in `OverImageOverlayView.mm`
2. Modify window setup in `OverImageManager.mm`
3. Add new hooks in `Tweak.xm`
4. Rebuild with `make package`

## License

Private/Jailbreak Tweak
