# OverImage Tweak - Hướng Dẫn Hoàn Chỉnh (Complete Guide)

## 📱 Giới Thiệu (Introduction)

OverImage là một Theos tweak cho iOS 18 cho phép hiển thị ảnh dưới dạng overlay nổi toàn cầu trên tất cả các ứng dụng. Có hỗ trợ phóng to/thu nhỏ, di chuyển tự do, và các tính năng tương tác.

## 🚀 Yêu Cầu Hệ Thống (Requirements)

- **Thiết bị:** iOS 18+ jailbroken (arm64/arm64e)
- **Công cụ phát triển:** Theos
- **Compiler:** Clang (Xcode hoặc Command Line Tools)
- **SSH Access:** Kết nối tới thiết bị iOS

## 📋 Cấu Trúc Dự Án (Project Structure)

```
OverImageTweak/
├── Tweak.xm                    # Main tweak hooks (Logos syntax)
├── OverImageOverlayView.mm     # Custom UIView for overlay
├── OverImageOverlayView.h      # Header file
├── OverImageManager.mm         # Overlay manager
├── OverImageManager.h          # Manager header
├── OverImage.h                 # Main header for imports
├── Makefile                    # Build configuration
├── Makefile.advanced           # Advanced build options
├── build.sh                    # Build script
├── deploy.sh                   # Deployment script
├── README.md                   # Documentation (English)
├── GUIDE.md                    # This file
├── EXAMPLES.h                  # Usage examples
├── layout/
│   └── DEBIAN/
│       ├── control             # Package control file
│       ├── control.extended    # Extended control info
│       ├── postinst            # Post-install script
│       └── preinst             # Pre-install script
```

## 🛠️ Cài Đặt & Xây Dựng (Installation & Building)

### Bước 1: Chuẩn Bị Môi Trường

```bash
# Cài đặt Theos (nếu chưa có)
git clone --recursive https://github.com/theos/theos.git ~/theos
export THEOS=~/theos
export PATH=$THEOS/bin:$PATH
```

### Bước 2: Xây Dựng Tweak

```bash
# Di chuyển tới thư mục tweak
cd OverImageTweak

# Xây dựng package
make package

# Hoặc sử dụng build script
bash build.sh
```

### Bước 3: Cài Đặt Lên Thiết Bị

#### Cách 1: Sử dụng Theos tích hợp
```bash
# Đặt địa chỉ IP thiết bị
export THEOS_DEVICE_IP=192.168.x.x
export THEOS_DEVICE_PORT=22

# Cài đặt
make package install
```

#### Cách 2: Sử dụng script deployment
```bash
bash deploy.sh 192.168.x.x 22 root alpine
```

#### Cách 3: Sử dụng Sileo/Cydia (sau khi build)
1. Copy file .deb lên thiết bị
2. Mở Sileo hoặc Cydia
3. Chọn Install từ file .deb

## 📖 Hướng Dẫn Sử Dụng (Usage Guide)

### Hiển Thị Ảnh Lên Overlay

#### Phương Pháp 1: Từ UIImage hiện tại
```objc
#import "OverImage.h"

UIImage *myImage = [UIImage imageNamed:@"myImage"];
[[OverImageManager sharedManager] addImageOverlayWithImage:myImage];
```

#### Phương Pháp 2: Từ Pasteboard (Clipboard)
```objc
void AddImageFromPasteboard() {
    UIPasteboard *pb = [UIPasteboard generalPasteboard];
    if (pb.image) {
        [[OverImageManager sharedManager] addImageOverlayWithImage:pb.image];
    }
}
```

#### Phương Pháp 3: Từ URL
```objc
NSURL *imageURL = [NSURL URLWithString:@"https://example.com/image.jpg"];
NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
UIImage *image = [UIImage imageWithData:imageData];
[[OverImageManager sharedManager] addImageOverlayWithImage:image];
```

### Các Thao Tác Trên Overlay

| Thao Tác | Mô Tả |
|---------|-------|
| **Kéo (Drag)** | Giữ và kéo ảnh để di chuyển vị trí |
| **Pinch (Zoom)** | Dùng 2 ngón tay pinch vào/ra để phóng to/thu nhỏ (0.5x - 3.0x) |
| **Tap ngoài** | Nhấn vào ngoài vùng ảnh để ẩn/hiện (toggle visibility) |

### Kiểm Soát Qua Code

```objc
// Ẩn/hiện overlay
OverImageOverlayView *overlay = [[OverImageManager sharedManager] currentOverlayView];
[overlay toggleVisibility];

// Xóa overlay
[[OverImageManager sharedManager] removeImageOverlay];

// Kiểm tra overlay hiện tại
OverImageOverlayView *current = [[OverImageManager sharedManager] currentOverlayView];
if (current && current.isVisible) {
    NSLog(@"Overlay visible with scale: %f", current.currentScale);
}
```

## 🎨 Tùy Chỉnh & Cấu Hình (Customization)

### Thay Đổi Giới Hạn Zoom

Mở file `OverImageOverlayView.mm`, tìm hàm `handlePinch:` và sửa:

```objc
// Limit zoom between 0.5x and 3x
scale = MAX(0.5, MIN(scale, 3.0));  // Thay 0.5 và 3.0

// Ví dụ: Cho phép zoom từ 0.3x đến 5x
scale = MAX(0.3, MIN(scale, 5.0));
```

### Thay Đổi Kích Thước Ban Đầu

Trong hàm `updateImageContent`:

```objc
CGFloat maxWidth = 300;      // Thay đổi chiều rộng tối đa
CGFloat maxHeight = 400;     // Thay đổi chiều cao tối đa
```

### Thay Đổi Vị Trí Ban Đầu

Trong `OverImageManager.mm`:

```objc
CGRect initialFrame = CGRectMake(50, 100, 300, 400);
// Thay đổi: (x, y, width, height)
```

## 🔧 API Reference

### OverImageManager

```objc
// Singleton
+ (instancetype)sharedManager;

// Thêm ảnh lên overlay
- (void)addImageOverlayWithImage:(UIImage *)image;

// Xóa overlay
- (void)removeImageOverlay;

// Lấy overlay hiện tại
- (OverImageOverlayView *)currentOverlayView;
```

### OverImageOverlayView

```objc
// Khởi tạo
- (instancetype)initWithImage:(UIImage *)image frame:(CGRect)frame;

// Setup gesture recognizers
- (void)setupGestureRecognizers;

// Toggle ẩn/hiện
- (void)toggleVisibility;

// Cập nhật nội dung ảnh
- (void)updateImageContent;

// Properties
@property (nonatomic, strong) UIImage *displayImage;
@property (nonatomic, assign) BOOL isVisible;
@property (nonatomic, assign) CGFloat currentScale;
```

## 📝 Global Functions

```objc
// Thêm ảnh
void AddImageOverlay(UIImage *image);

// Thêm ảnh từ pasteboard
void AddImageFromPasteboard();

// Xóa overlay
void RemoveImageOverlay();

// Toggle visibility
void ToggleImageVisibility();
```

## 🐛 Troubleshooting

### Vấn đề: Tweak không hoạt động sau cài đặt

**Giải pháp:**
1. Restart SpringBoard: `killall -9 SpringBoard`
2. Kiểm tra file dylib ở: `/Library/MobileSubstrate/DynamicLibraries/`
3. Kiểm tra MobileSubstrate có được cài không: `dpkg -l | grep substrate`

### Vấn đề: Ảnh không hiển thị

**Giải pháp:**
1. Kiểm tra kích thước ảnh (phải > 0)
2. Kiểm tra image format (PNG, JPG hỗ trợ)
3. Log: `NSLog(@"Image: %@", image);`

### Vấn đề: Gesture không hoạt động

**Giải pháp:**
1. Kiểm tra `userInteractionEnabled = YES` trên view
2. Kiểm tra gesture recognizers được thêm vào
3. Log gesture calls: `NSLog(@"Gesture called");`

### Vấn đề: Overlay biến mất khi mở app khác

**Giải pháp:**
- Điều này là bình thường do window level - hãy tap để hiện lại
- Nếu cần persistent, cần modify window level (cấp cao hơn)

## 📚 Tài Liệu Thêm

- [Theos Documentation](https://theos.dev/)
- [Logos Syntax Guide](https://theos.dev/docs/logos)
- [MobileSubstrate Documentation](https://www.saurik.com/)

## 🔐 Bảo Mật (Security Notes)

- Tweak này yêu cầu quyền truy cập tối cao (root)
- Chỉ cài trên thiết bị của bạn
- Không khuyến cáo sử dụng trên thiết bị công cộng

## 📄 Giấy Phép (License)

Private/Internal Jailbreak Tweak

## 🤝 Hỗ Trợ (Support)

Để thêm tính năng hoặc báo lỗi, hãy chỉnh sửa code source và rebuild.

---

**Phiên bản:** 1.0.0  
**Cập nhật cuối:** 2026-06-11  
**Hỗ trợ:** iOS 18+
