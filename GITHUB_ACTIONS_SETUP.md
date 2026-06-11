# GitHub Actions Setup

Đã tạo GitHub Actions workflow để tự động build OverImage tweak.

## Cách sử dụng

### 1. Push code lên GitHub
```bash
git init
git remote add origin https://github.com/YOUR_USERNAME/OverToolIOS.git
git branch -M main
git add .
git commit -m "Initial commit: OverImage tweak"
git push -u origin main
```

### 2. GitHub Actions sẽ tự động:
- **Khi nào**: Mỗi khi push lên `main`, `master`, hoặc `develop`
- **Làm gì**:
  1. Cài đặt dependencies (git, make, clang, etc)
  2. Clone Theos framework
  3. Tải iOS 16.5 SDK (~17MB)
  4. Setup iOS toolchain wrappers
  5. Compile tweak thành dylib
  6. Package vào .deb file

### 3. Lấy kết quả
- Vào tab **Actions** trên GitHub repo
- Xem build status (✅ hoặc ❌)
- Download artifacts (file `.deb`)

## Build Status Badge
Thêm vào README.md của bạn:
```markdown
![Build Status](https://github.com/YOUR_USERNAME/OverToolIOS/actions/workflows/build.yml/badge.svg)
```

## Troubleshooting

**Nếu build fail:**
1. Check **Actions** tab → click build job
2. Scroll down để xem logs
3. Common issues:
   - Network timeout: Retry workflow
   - SDK download failed: GitHub rate limiting (wait 1 hour)
   - Compilation errors: Check source code syntax

**Build logs location:**
- GitHub UI: Actions → Latest workflow run → Logs
- Download logs: Artifacts section

## Files tạo ra
Workflow file: `.github/workflows/build.yml`

Khi build thành công, artifacts sẽ có:
- `com.oveimage.tweak_1.0.0_iphoneos-arm64.deb` ← Deploy file này
- Logs và object files (nếu cần debug)

## Tiếp theo - Deploy
1. SSH vào jailbroken device
2. Copy `.deb` file
3. Run: `dpkg -i /path/to/com.oveimage.tweak_1.0.0_iphoneos-arm64.deb`
4. Restart SpringBoard: `killall -9 SpringBoard`
