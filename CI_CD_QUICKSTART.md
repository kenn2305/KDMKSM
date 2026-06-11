# GitHub Actions CI/CD - Quick Start

## 📋 Yêu cầu
- GitHub account (free)
- Repo public hoặc private (GitHub Actions miễn phí cho public repos)

## 🚀 Bước 1: Setup repository

```bash
cd e:\OverToolIOS\OverImageTweak

# Hoặc chạy script PowerShell (đã chuẩn bị)
.\push-to-github.ps1
```

## ✨ Bước 2: GitHub Actions tự động hoạt động
Workflow chạy khi:
- ✅ Push code lên `main`, `master`, hoặc `develop` branch
- ✅ Manual trigger từ Actions tab
- ✅ Pull request được tạo

## 📊 Bước 3: Monitor build

**GitHub UI:**
1. Vào repo → **Actions** tab
2. Click workflow name: **"Build OverImage Tweak"**
3. Xem live logs trong "Build job"

**Logs có:**
- ✓ Dependencies installed
- ✓ Theos cloned
- ✓ iOS SDK downloaded (17MB)
- ✓ Tweak compiled
- ✓ .deb package created

## 📦 Bước 4: Lấy compiled package

**Nếu build ✅ thành công:**
- Scroll down → **Artifacts**
- Download: `OverImage-Tweak-Package`
- Giải nén → file `com.oveimage.tweak_1.0.0_iphoneos-arm64.deb`

**Nếu build ❌ fail:**
- Download: `Build-Logs` artifact
- Check `.theos/` directory logs

## 🚀 Bước 5: Deploy to device

```bash
# SSH vào jailbroken iOS device
ssh -p 2222 root@localhost

# Upload .deb
scp -P 2222 com.oveimage.tweak_1.0.0_iphoneos-arm64.deb root@localhost:/tmp/

# Install
dpkg -i /tmp/com.oveimage.tweak_1.0.0_iphoneos-arm64.deb

# Restart SpringBoard
killall -9 SpringBoard
```

## 🔧 Workflow Details

File: `.github/workflows/build.yml`

**Tài nguyên:**
- Runner: `ubuntu-latest` (GitHub hosted)
- Timeout: 6 giờ (mặc định)
- Storage: 5GB artifacts (30 ngày)

**Build steps:**
1. Checkout code
2. Install system dependencies
3. Clone Theos framework
4. Download iOS 16.5 SDK
5. Setup iOS toolchain
6. `make clean && make package`
7. Upload artifacts

## 💡 Tips

**Để trigger manual build:**
1. Actions → Build OverImage Tweak
2. Click **"Run workflow"** dropdown
3. Select branch → **Run workflow**

**Để commit và push sau:**
```bash
git add .
git commit -m "Update tweak"
git push
```

**Để xem tất cả builds:**
- Actions tab → Filter by branch/status

## ❌ Troubleshooting

| Issue | Solution |
|-------|----------|
| "No artifact" | Check build logs - có error nào không? |
| "Permission denied" | Git credentials không hợp lệ |
| "Timeout" | Build chậm, GitHub Actions free account có limits |
| "SDK download fail" | GitHub rate limiting - chờ 1 giờ rồi retry |

## 📝 Logs

Build logs lưu ở:
- **GitHub**: Actions tab → Job logs
- **Local**: `.theos/` directory sau build

Để debug:
```bash
# Xem Makefile calls
cat .theos/build_session

# Xem compiler output
ls .theos/obj/arm64/
```

---

**Tài liệu liên quan:**
- [GITHUB_ACTIONS_SETUP.md](GITHUB_ACTIONS_SETUP.md) - Chi tiết setup
- [Makefile](Makefile) - Build configuration
- [README.md](README.md) - Project overview
