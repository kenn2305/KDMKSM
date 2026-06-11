# 🚀 Push to GitHub - Instructions

Repository: https://github.com/kennchan05-prog/OverlayTools

## ⚡ Quick Start

### Option 1️⃣: Interactive Script (RECOMMENDED)
```powershell
cd e:\OverToolIOS\OverImageTweak
.\push.ps1
```
This will:
- Ask you to choose authentication method (PAT, SSH, or Credential Manager)
- Guide you through setup
- Automatically push code

### Option 2️⃣: Manual Push with GitHub CLI
```powershell
# Install GitHub CLI (if not already installed)
winget install GitHub.cli -e --accept-source-agreements

# Authenticate
gh auth login

# Push from project directory
cd e:\OverToolIOS\OverImageTweak
git push -u origin main
```

### Option 3️⃣: Manual Push with Personal Access Token
```powershell
$token = Read-Host "Paste your GitHub token"
$username = Read-Host "Enter your GitHub username"

cd e:\OverToolIOS\OverImageTweak

git remote remove origin
git remote add origin "https://${username}:${token}@github.com/kennchan05-prog/OverlayTools.git"
git push -u origin main
```

### Option 4️⃣: SSH Key Setup
```powershell
# Generate SSH key (if needed)
ssh-keygen -t ed25519 -C "your_email@example.com"

# Update git remote
cd e:\OverToolIOS\OverImageTweak
git remote remove origin
git remote add origin git@github.com:kennchan05-prog/OverlayTools.git
git push -u origin main
```

## 📋 Get GitHub Personal Access Token

1. Go to: https://github.com/settings/tokens
2. Click: **Generate new token** → **Generate new token (classic)**
3. Select scopes:
   - ✓ `repo` (full control of private repositories)
   - ✓ `workflow` (update GitHub Actions and workflows)
4. Click: **Generate token**
5. **Copy the token** (you won't see it again!)

## 🔑 Get SSH Key Ready

1. Check for existing key:
   ```powershell
   Test-Path "$env:USERPROFILE\.ssh\id_ed25519"
   ```

2. If not found, generate:
   ```powershell
   ssh-keygen -t ed25519 -C "your_email@example.com" -f "$env:USERPROFILE\.ssh\id_ed25519" -N ""
   ```

3. Add public key to GitHub:
   ```powershell
   # Copy the public key
   Get-Content "$env:USERPROFILE\.ssh\id_ed25519.pub" | Set-Clipboard
   
   # Then go to: https://github.com/settings/keys
   # Click: New SSH key
   # Paste and save
   ```

## ✅ Verify Push Success

After pushing, you should see:
```
To https://github.com/kennchan05-prog/OverlayTools.git
 * [new branch]      main -> main
Branch 'main' set up to track remote branch 'main' from 'origin'.
```

## 🎯 After Successful Push

1. **Watch the build:**
   - Go to: https://github.com/kennchan05-prog/OverlayTools
   - Click: **Actions** tab
   - Watch the workflow run

2. **Download the .deb package:**
   - Wait for "Build OverImage Tweak" to complete
   - Click the successful workflow run
   - Scroll to **Artifacts**
   - Download `OverImage-Tweak-Package`

3. **Deploy to iOS 18 device:**
   ```bash
   # SSH into jailbroken device
   ssh -p 2222 root@192.168.x.x
   
   # Upload .deb
   scp -P 2222 com.oveimage.tweak_1.0.0_iphoneos-arm64.deb root@192.168.x.x:/tmp/
   
   # Install
   dpkg -i /tmp/com.oveimage.tweak_1.0.0_iphoneos-arm64.deb
   
   # Restart SpringBoard
   killall -9 SpringBoard
   ```

## ❓ Troubleshooting

| Problem | Solution |
|---------|----------|
| "Permission denied" | Check token/SSH key credentials |
| "Repository not found" | Verify URL: `git remote -v` |
| "fatal: Authentication failed" | Token expired? Generate new one |
| "No such key" (SSH) | Generate SSH key first |

## 📞 Need Help?

- GitHub Docs: https://docs.github.com/en/authentication
- Theos Wiki: https://theos.dev
- GitHub Actions: https://docs.github.com/en/actions
