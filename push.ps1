#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Push OverImage tweak to GitHub with authentication
.DESCRIPTION
    Securely pushes code using SSH or Personal Access Token
#>

$repoUrl = "https://github.com/kenn2305/KDMKSM.git"
$sshUrl = "git@github.com:kenn2305/KDMKSM.git"

Write-Host "`n╔════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║     OverImage - Push to GitHub                        ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════╝`n" -ForegroundColor Cyan

Write-Host "Choose authentication method:`n" -ForegroundColor Yellow
Write-Host "1️⃣  Personal Access Token (Recommended for Windows)"
Write-Host "2️⃣  SSH Key (More secure)"
Write-Host "3️⃣  Windows Credential Manager (Auto-save credentials)`n"

$choice = Read-Host "Select 1, 2, or 3"

cd e:\OverToolIOS\OverImageTweak

if ($choice -eq "1") {
    Write-Host "`n📋 Personal Access Token Setup" -ForegroundColor Green
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    Write-Host "1. Go to: https://github.com/settings/tokens"
    Write-Host "2. Click: 'Generate new token (classic)'"
    Write-Host "3. Select scopes:"
    Write-Host "   ✓ repo (full control of private repositories)"
    Write-Host "   ✓ workflow (update GitHub Actions and workflows)"
    Write-Host "4. Generate token and COPY IT`n"
    
    $token = Read-Host "Paste your GitHub Personal Access Token"
    $username = Read-Host "Enter your GitHub username"
    
    if ([string]::IsNullOrEmpty($token) -o [string]::IsNullOrEmpty($username)) {
        Write-Host "❌ Token and username are required" -ForegroundColor Red
        exit 1
    }
    
    git remote add origin "https://${username}:${token}@github.com/kennchan05-prog/OverlayTools.git"
    Write-Host "✓ Remote configured with token authentication" -ForegroundColor Green
}
elseif ($choice -eq "2") {
    Write-Host "`n🔑 SSH Key Setup" -ForegroundColor Green
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    $sshPath = "$env:USERPROFILE\.ssh\id_ed25519"
    
    if (Test-Path $sshPath) {
        Write-Host "✓ SSH key found at: $sshPath`n" -ForegroundColor Green
    } else {
        Write-Host "⚠️  SSH key not found at: $sshPath"
        Write-Host "Generating new SSH key...`n" -ForegroundColor Yellow
        
        $email = Read-Host "Enter your GitHub email"
        ssh-keygen -t ed25519 -C $email -f $sshPath -N ""
        
        if ($LASTEXITCODE -ne 0) {
            Write-Host "❌ SSH key generation failed" -ForegroundColor Red
            exit 1
        }
        
        Write-Host "`n✓ SSH key generated" -ForegroundColor Green
        Write-Host "`n📌 ADD THIS PUBLIC KEY TO GITHUB:"
        Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        Get-Content "$sshPath.pub"
        Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        
        Write-Host "`n1. Go to: https://github.com/settings/keys"
        Write-Host "2. Click: 'New SSH key'"
        Write-Host "3. Paste the key shown above"
        Write-Host "4. Title: 'OverImage Build Key'"
        Write-Host "`nPress Enter when done...`n"
        Read-Host | Out-Null
    }
    
    git remote add origin $sshUrl
    Write-Host "✓ Remote configured with SSH" -ForegroundColor Green
}
elseif ($choice -eq "3") {
    Write-Host "`n💾 Windows Credential Manager Setup" -ForegroundColor Green
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    git config --global credential.helper wincred
    git remote add origin $repoUrl
    
    Write-Host "✓ Credential helper configured" -ForegroundColor Green
    Write-Host "`nWhen you push, Git will prompt for credentials."
    Write-Host "Choose 'Save' to store in Windows Credential Manager.`n"
} else {
    Write-Host "❌ Invalid choice" -ForegroundColor Red
    exit 1
}

Write-Host "`n🚀 Pushing to GitHub..." -ForegroundColor Cyan
Write-Host "Repository: $repoUrl`n"

git branch -M main
git push -u origin main -v

if ($LASTEXITCODE -eq 0) {
    Write-Host "`n✅ SUCCESSFULLY PUSHED TO GITHUB!`n" -ForegroundColor Green
    Write-Host "🎉 Next Steps:" -ForegroundColor Cyan
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    Write-Host "1. Open: https://github.com/kennchan05-prog/OverlayTools"
    Write-Host "2. Go to: Actions tab"
    Write-Host "3. Watch: 'Build OverImage Tweak' workflow"
    Write-Host "4. Download: .deb package when complete"
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n"
    Write-Host "📊 GitHub Actions Status:"
    Write-Host "https://github.com/kennchan05-prog/OverlayTools/actions`n"
} else {
    Write-Host "`n❌ Push failed" -ForegroundColor Red
    Write-Host "Check the error above and try again`n"
    exit 1
}
