# ============================================================
# Claude Code GLM Mode - One-Click Installer for Windows
# ============================================================
# 사용법:
#   .\install-claude-glm.ps1 -ApiKey "your_api_key_here"
# 또는
#   .\install-claude-glm.ps1  (API 키 입력 프롬프트)
# ============================================================

param(
    [Parameter(Mandatory=$false)]
    [string]$ApiKey
)

# UTF-8 인코딩 설정
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host "`n====================================" -ForegroundColor Cyan
Write-Host " Claude GLM Mode Installer" -ForegroundColor Cyan
Write-Host "====================================`n" -ForegroundColor Cyan

# 1단계: 실행 정책 확인
Write-Host "[1/5] Checking execution policy..." -ForegroundColor Yellow
$policy = Get-ExecutionPolicy -Scope CurrentUser
if ($policy -eq "Restricted" -or $policy -eq "Undefined") {
    Write-Host "  Setting execution policy to RemoteSigned..." -ForegroundColor Gray
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
    Write-Host "  Done." -ForegroundColor Green
} else {
    Write-Host "  Execution policy: $policy (OK)" -ForegroundColor Green
}

# 2단계: Claude Code 설치 확인
Write-Host "`n[2/5] Checking Claude Code installation..." -ForegroundColor Yellow
$claudePath = "$env:APPDATA\npm\claude.ps1"
if (!(Test-Path $claudePath)) {
    Write-Host "  Error: Claude Code not found!" -ForegroundColor Red
    Write-Host "  Please install first: npm install -g @anthropic-ai/claude-code" -ForegroundColor Gray
    exit 1
}
Write-Host "  Found: $claudePath" -ForegroundColor Green

# 3단계: API 키 입력
Write-Host "`n[3/5] Configuring API key..." -ForegroundColor Yellow
if ([string]::IsNullOrWhiteSpace($ApiKey)) {
    $ApiKey = Read-Host "  Enter your z.ai API Key"
}
if ([string]::IsNullOrWhiteSpace($ApiKey)) {
    Write-Host "  Error: API Key is required!" -ForegroundColor Red
    exit 1
}
Write-Host "  API Key: $($ApiKey.Substring(0, 10))..." -ForegroundColor Green

# 4단계: claude 파일 이름 변경
Write-Host "`n[4/5] Renaming claude files..." -ForegroundColor Yellow
try {
    $origPs1 = "$env:APPDATA\npm\claude-orig.ps1"
    $origCmd = "$env:APPDATA\npm\claude-orig.cmd"

    if (Test-Path "$env:APPDATA\npm\claude.ps1") {
        if (Test-Path $origPs1) { Remove-Item $origPs1 -Force }
        Rename-Item "$env:APPDATA\npm\claude.ps1" "claude-orig.ps1" -Force
        Write-Host "  Renamed: claude.ps1 -> claude-orig.ps1" -ForegroundColor Green
    }
    if (Test-Path "$env:APPDATA\npm\claude.cmd") {
        if (Test-Path $origCmd) { Remove-Item $origCmd -Force }
        Rename-Item "$env:APPDATA\npm\claude.cmd" "claude-orig.cmd" -Force
        Write-Host "  Renamed: claude.cmd -> claude-orig.cmd" -ForegroundColor Green
    }
} catch {
    Write-Host "  Warning: Could not rename files - $_" -ForegroundColor Yellow
}

# 5단계: PowerShell 프로필 생성
Write-Host "`n[5/5] Creating PowerShell profile..." -ForegroundColor Yellow

# 프로필 폴더 확인
$profileDir = Split-Path -Parent $PROFILE
if (!(Test-Path $profileDir)) {
    New-Item -ItemType Directory -Path $profileDir -Force | Out-Null
}

# 기존 프로필 백업
if (Test-Path $PROFILE) {
    $backupPath = "$PROFILE.backup"
    Write-Host "  Backing up existing profile to: $backupPath" -ForegroundColor Gray
    Copy-Item $PROFILE $backupPath -Force
}

# 새 프로필 내용
$profileContent = @"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
`$OutputEncoding = [System.Text.Encoding]::UTF8

# ============================================================
# Claude Code --glm mode switch
# ============================================================

`$env:ZAI_API_KEY = "$ApiKey"
`$env:ZAI_BASE_URL = "https://api.z.ai/api/anthropic"
`$claudePath = "`$env:APPDATA\npm\claude-orig.ps1"

function claude {
    if (`$args.Count -gt 0 -and `$args[0] -eq "--glm") {
        `$remainingArgs = @()
        if (`$args.Count -gt 1) {
            `$remainingArgs = `$args[1..(`$args.Count - 1)]
        }
        Write-Host "[GLM MODE] Running Claude with z.ai API" -ForegroundColor Cyan
        `$env:ANTHROPIC_API_KEY = `$env:ZAI_API_KEY
        `$env:ANTHROPIC_BASE_URL = `$env:ZAI_BASE_URL
        & `$claudePath @remainingArgs
        Remove-Item Env:ANTHROPIC_API_KEY -ErrorAction SilentlyContinue
        Remove-Item Env:ANTHROPIC_BASE_URL -ErrorAction SilentlyContinue
    }
    else {
        Write-Host "[ANTHROPIC MODE] Running Claude with subscription" -ForegroundColor Green
        & `$claudePath @args
    }
}

function claude-status {
    Write-Host "claude          = Anthropic subscription mode"
    Write-Host "claude --glm    = z.ai API mode (GLM)"
    if (`$env:ZAI_API_KEY) {
        Write-Host "ZAI_API_KEY     = `(`$env:ZAI_API_KEY.Substring(0,10))..." -ForegroundColor Gray
    }
}

Write-Host "Claude --glm mode switcher loaded!" -ForegroundColor Green
"@

Set-Content -Path $PROFILE -Value $profileContent -Encoding UTF8
Write-Host "  Profile created: $PROFILE" -ForegroundColor Green

# 완료 메시지
Write-Host "`n====================================" -ForegroundColor Cyan
Write-Host " Installation Complete!" -ForegroundColor Green
Write-Host "====================================`n" -ForegroundColor Cyan

Write-Host "Please CLOSE this PowerShell and open a NEW one.`n" -ForegroundColor Yellow
Write-Host "Available commands:" -ForegroundColor White
Write-Host "  claude          = Anthropic subscription mode" -ForegroundColor Gray
Write-Host "  claude --glm    = z.ai API mode (GLM)" -ForegroundColor Gray
Write-Host "  claude-status   = Check status`n" -ForegroundColor Gray
