#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Setup GitHub authentication and push OverImage tweak
.DESCRIPTION
    Configures Git authentication and pushes to OverlayTools repository
.EXAMPLE
    .\setup-github-auth.ps1
#>

param(
    [ValidateSet('ssh', 'token', 'cli')]
    [string]$Method = 'token'
)

Write-Host "`n╔═══════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║  OverImage Tweak - GitHub Authentication    ║" -ForegroundColor Cyan
Write-Host "╚═══════════════════════════════════════════════╝`n" -ForegroundColor Cyan

$repoUrl = "https://github.com/kennchan05-prog/OverlayTools.git"

if ($Method -eq 'token') {
    Write-Host "📋 GitHub Personal Access Token Method`n" -ForegroundColor Yellow
    
    Write-Host "Step 1: Create GitHub Token" -ForegroundColor Green
    Write-Host "  1. Go to: https://github.com/settings/tokens"
    Write-Host "  2. Click: Generate new token (classic)"
    Write-Host "  3. Select scopes:"
    Write-Host "     ☑ repo (full control)"
    Write-Host "     ☑ workflow (GitHub Actions)"
    Write-Host "  4. Copy the generated token`n"
    
    $token = Read-Host "Paste your GitHub token"
    $username = Read-Host "Enter your GitHub username"
    
    if ([string]::IsNullOrEmpty($token) -or [string]::IsNullOrEmpty($username)) {
        Write-Host "❌ Token and username required" -ForegroundColor Red
        exit 1
    }
    
    Write-Host "`n✓ Configuring Git with token..." -ForegroundColor Green
    git config --global user.email "${username}@github.local"
    git config --global user.name $username
    
    $remoteUrl = $repoUrl -replace "https://", "https://${username}:${token}@"
    git remote remove origin 2>$null
    git remote add origin $remoteUrl
    
    Write-Host "✓ Git configured" -ForegroundColor Green
}
elseif ($Method -eq 'ssh') {
    Write-Host "🔑 SSH Key Method`n" -ForegroundColor Yellow
    
    Write-Host "Step 1: Check for SSH key" -ForegroundColor Green
    $sshPath = "$env:USERPROFILE\.ssh\id_ed25519"
    
    if (Test-Path $sshPath) {
        Write-Host "✓ SSH key found: $sshPath`n" -ForegroundColor Green
    } else {
        Write-Host "⚠️  No SSH key found. Creating one...`n" -ForegroundColor Yellow
        
        $email = Read-Host "Enter your GitHub email"
        ssh-keygen -t ed25519 -C $email -f $sshPath -N ""
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✓ SSH key created`n" -ForegroundColor Green
            Write-Host "Step 2: Add key to GitHub" -ForegroundColor Green
            Write-Host "  1. Copy this public key:"
            Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
            Get-Content "$sshPath.pub"
            Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n"
            
            Write-Host "  2. Go to: https://github.com/settings/keys"
            Write-Host "  3. Click: New SSH key"
            Write-Host "  4. Paste the key above"
            Write-Host "  5. Press Enter when done..."
            Read-Host
        }
    }
    
    Write-Host "Configuring Git SSH..." -ForegroundColor Green
    git remote remove origin 2>$null
    git remote add origin git@github.com:kennchan05-prog/OverlayTools.git
    git config --global core.sshCommand "ssh -i $sshPath"
    
    Write-Host "✓ SSH configured`n" -ForegroundColor Green
}
elseif ($Method -eq 'cli') {
    Write-Host "🔐 GitHub CLI Method`n" -ForegroundColor Yellow
    
    if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
        Write-Host "Installing GitHub CLI..." -ForegroundColor Yellow
        winget install GitHub.cli -e
    }
    
    Write-Host "Authenticating with GitHub CLI..." -ForegroundColor Green
    gh auth login
    
    git remote remove origin 2>$null
    git remote add origin https://github.com/kennchan05-prog/OverlayTools.git
    
    Write-Host "✓ GitHub CLI configured`n" -ForegroundColor Green
}

# Try to push
Write-Host "`nAttempting to push code..." -ForegroundColor Cyan
cd e:\OverToolIOS\OverImageTweak

try {
    git push -u origin main -v
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "`n✅ Successfully pushed to GitHub!`n" -ForegroundColor Green
        Write-Host "Repository: $repoUrl`n" -ForegroundColor Green
        
        Write-Host "Next steps:" -ForegroundColor Cyan
        Write-Host "1. Go to: https://github.com/kennchan05-prog/OverlayTools"
        Write-Host "2. Click 'Actions' tab"
        Write-Host "3. Watch 'Build OverImage Tweak' workflow"
        Write-Host "4. Download .deb from Artifacts when complete`n"
        
        Write-Host "GitHub Actions Status: https://github.com/kennchan05-prog/OverlayTools/actions`n"
    } else {
        Write-Host "`n❌ Push failed. Check the error above.`n" -ForegroundColor Red
    }
}
catch {
    Write-Host "`n❌ Error: $_`n" -ForegroundColor Red
}
