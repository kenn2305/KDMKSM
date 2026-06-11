#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Push OverImage tweak to GitHub and trigger CI/CD build
.DESCRIPTION
    Initializes Git repo, adds all files, commits, and pushes to GitHub
.EXAMPLE
    ./push-to-github.ps1
#>

param(
    [string]$GithubUrl = "",
    [string]$Branch = "main"
)

Write-Host "=== OverImage Tweak - Push to GitHub ===" -ForegroundColor Cyan

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "Git not found. Install Git from https://git-scm.com/" -ForegroundColor Red
    exit 1
}

# Check if already a git repo
if (Test-Path .git) {
    Write-Host "✓ Already a Git repository" -ForegroundColor Green
} else {
    Write-Host "Initializing Git repository..."
    git init
    git config user.email "builder@github.local"
    git config user.name "OverImage Builder"
}

# Configure GitHub URL
if ([string]::IsNullOrEmpty($GithubUrl)) {
    Write-Host "`nEnter your GitHub repository URL (e.g., https://github.com/username/OverToolIOS.git):"
    $GithubUrl = Read-Host
}

if ([string]::IsNullOrEmpty($GithubUrl)) {
    Write-Host "No URL provided. Exiting." -ForegroundColor Red
    exit 1
}

# Add remote
Write-Host "`nConfiguring remote: $GithubUrl"
git remote remove origin 2>$null
git remote add origin $GithubUrl

# Add all files
Write-Host "`nStaging files..."
git add .
$stagedCount = (git diff --cached --name-only | Measure-Object).Count
Write-Host "✓ Staged $stagedCount files" -ForegroundColor Green

# Create commit
Write-Host "`nCreating commit..."
git commit -m "OverImage iOS 18 tweak - Theos framework with gesture controls

- Global image overlay with pinch zoom (0.5x-3x)
- Pan to move, tap outside to toggle visibility
- Preserves original image resolution
- Ready for GitHub Actions CI/CD build"

if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Commit created" -ForegroundColor Green
} else {
    Write-Host "Note: Repository may already be up to date" -ForegroundColor Yellow
}

# Rename branch if needed
Write-Host "`nConfiguring branch..."
git branch -M $Branch 2>$null
Write-Host "✓ Using branch: $Branch" -ForegroundColor Green

# Push to GitHub
Write-Host "`nPushing to GitHub..."
Write-Host "URL: $GithubUrl" -ForegroundColor DarkGray

git push -u origin $Branch

if ($LASTEXITCODE -eq 0) {
    Write-Host "`n✓ Successfully pushed to GitHub!" -ForegroundColor Green
    Write-Host "`nNext steps:" -ForegroundColor Cyan
    Write-Host "1. Go to: $(($GithubUrl -replace '\.git$', '') -replace 'https://', 'https://github.com/')"
    Write-Host "2. Click 'Actions' tab"
    Write-Host "3. Watch the build workflow"
    Write-Host "4. Download .deb package from artifacts when complete"
} else {
    Write-Host "`n✗ Push failed. Check GitHub credentials and repository URL." -ForegroundColor Red
    exit 1
}
