param()

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$Timestamp = Get-Date -Format "yyyyMMdd_HHmmss"

$IdeMap = @{
  vscode = @{
    AppDataName   = "Code"
    ScoopApps     = @("vscode", "vscode-portable")
    CommandNames  = @("code", "code.cmd")
    InstallNames  = @("Microsoft VS Code", "Code", "VSCode")
  }
  cursor = @{
    AppDataName   = "Cursor"
    ScoopApps     = @("cursor", "cursor-portable")
    CommandNames  = @("cursor", "cursor.cmd")
    InstallNames  = @("Cursor")
  }
  trae = @{
    AppDataName   = "Trae"
    ScoopApps     = @("trae")
    CommandNames  = @("trae", "trae.cmd")
    InstallNames  = @("Trae")
  }
  antigravity = @{
    AppDataName   = "Antigravity"
    ScoopApps     = @("antigravity")
    CommandNames  = @("antigravity", "antigravity.cmd")
    InstallNames  = @("Antigravity")
  }
  kiro = @{
    AppDataName   = "Kiro"
    ScoopApps     = @("kiro")
    CommandNames  = @("kiro", "kiro.cmd")
    InstallNames  = @("Kiro")
  }
  windsurf = @{
    AppDataName   = "Windsurf"
    ScoopApps     = @("windsurf")
    CommandNames  = @("windsurf", "windsurf.cmd")
    InstallNames  = @("Windsurf")
  }
}

function Write-Ok {
  param([string]$Message)
  Write-Host "  [ok] $Message" -ForegroundColor Green
}

function Write-Warn {
  param([string]$Message)
  Write-Host "  [warn] $Message" -ForegroundColor Yellow
}

function Get-LinkTarget {
  param([string]$Path)

  if (-not (Test-Path -LiteralPath $Path)) {
    return $null
  }

  $item = Get-Item -LiteralPath $Path -Force
  if (-not ($item.Attributes -band [IO.FileAttributes]::ReparsePoint)) {
    return $null
  }

  if ($null -eq $item.Target) {
    return $null
  }

  if ($item.Target -is [System.Array]) {
    return [string]$item.Target[0]
  }

  return [string]$item.Target
}

function Backup-And-Link {
  param(
    [string]$Source,
    [string]$Target,
    [string]$Name
  )

  $existingTarget = Get-LinkTarget -Path $Target
  if ($existingTarget) {
    try {
      if ((Resolve-Path -LiteralPath $existingTarget).Path -eq (Resolve-Path -LiteralPath $Source).Path) {
        Write-Ok "$Name 已存在正确的软链接"
        return
      }
    } catch {
    }
  }

  $targetParent = Split-Path -Parent $Target
  if ($targetParent) {
    New-Item -ItemType Directory -Path $targetParent -Force | Out-Null
  }

  if (Test-Path -LiteralPath $Target) {
    $item = Get-Item -LiteralPath $Target -Force
    if ($item.Attributes -band [IO.FileAttributes]::ReparsePoint) {
      Remove-Item -LiteralPath $Target -Force
    } else {
      $backup = "$Target.backup.$Timestamp"
      Move-Item -LiteralPath $Target -Destination $backup
      Write-Warn "$Name 已备份到 $backup"
    }
  }

  New-Item -ItemType SymbolicLink -Path $Target -Target $Source -Force | Out-Null
  Write-Ok "$Name -> $Source"
}

function Get-ScoopRoots {
  $roots = @()

  if ($env:SCOOP) {
    $roots += $env:SCOOP
  } else {
    $roots += (Join-Path ([Environment]::GetFolderPath("UserProfile")) "scoop")
  }

  if ($env:SCOOP_GLOBAL) {
    $roots += $env:SCOOP_GLOBAL
  } else {
    $roots += (Join-Path $env:ProgramData "scoop")
  }

  return $roots | Select-Object -Unique
}

function Get-PortableRootsFromCommands {
  param([string[]]$CommandNames)

  $roots = @()
  foreach ($name in $CommandNames) {
    $cmd = Get-Command $name -ErrorAction SilentlyContinue
    if (-not $cmd) {
      continue
    }

    $sourcePath = $cmd.Source
    if (-not $sourcePath) {
      continue
    }

    $candidate = Split-Path -Parent $sourcePath
    if ($candidate -match "[\\/](bin)$") {
      $candidate = Split-Path -Parent $candidate
    }

    $roots += $candidate
  }

  return $roots | Select-Object -Unique
}

function Resolve-IdeUserDir {
  param([string]$Ide)

  $meta = $IdeMap[$Ide]
  $appData = [Environment]::GetFolderPath("ApplicationData")

  foreach ($root in Get-ScoopRoots) {
    foreach ($app in $meta.ScoopApps) {
      $persistDir = Join-Path $root "persist\$app\data\user-data\User"
      if (Test-Path -LiteralPath $persistDir) {
        return $persistDir
      }

      $currentDir = Join-Path $root "apps\$app\current\data\user-data\User"
      if (Test-Path -LiteralPath $currentDir) {
        return $currentDir
      }
    }
  }

  foreach ($root in Get-PortableRootsFromCommands -CommandNames $meta.CommandNames) {
    $portableDir = Join-Path $root "data\user-data\User"
    if (Test-Path -LiteralPath $portableDir) {
      return $portableDir
    }
  }

  $commonBases = @(
    Join-Path $env:LOCALAPPDATA "Programs",
    $env:ProgramFiles,
    ${env:ProgramFiles(x86)}
  ) | Where-Object { $_ }

  foreach ($base in $commonBases) {
    foreach ($name in $meta.InstallNames) {
      $portableDir = Join-Path $base "$name\data\user-data\User"
      if (Test-Path -LiteralPath $portableDir) {
        return $portableDir
      }
    }
  }

  return (Join-Path $appData "$($meta.AppDataName)\User")
}

Write-Host ""
Write-Host "=== VSCode 系列 IDE Windows 配置安装 ===" -ForegroundColor Green
Write-Host ""

foreach ($ide in $IdeMap.Keys) {
  $ideSrcDir = Join-Path $ScriptDir $ide
  $settingsSource = Join-Path $ideSrcDir "settings.json"
  $keybindingsSource = Join-Path $ideSrcDir "keybindings.json"

  Write-Host "处理 $ide..." -ForegroundColor Yellow

  if (-not (Test-Path -LiteralPath $settingsSource) -or -not (Test-Path -LiteralPath $keybindingsSource)) {
    Write-Warn "$ide 未找到生成后的 settings.json/keybindings.json，跳过"
    Write-Host ""
    continue
  }

  $userDir = Resolve-IdeUserDir -Ide $ide
  if (-not $userDir) {
    Write-Warn "$ide 未探测到配置目录，跳过"
    Write-Host ""
    continue
  }

  New-Item -ItemType Directory -Path $userDir -Force | Out-Null

  Backup-And-Link -Source $keybindingsSource -Target (Join-Path $userDir "keybindings.json") -Name "$ide keybindings"
  Backup-And-Link -Source $settingsSource -Target (Join-Path $userDir "settings.json") -Name "$ide settings"

  if ($userDir -like "*\persist\*\data\user-data\User") {
    Write-Host "  路径类型: Scoop portable/persist" -ForegroundColor Cyan
  } elseif ($userDir -like "*\data\user-data\User") {
    Write-Host "  路径类型: 便携版安装目录" -ForegroundColor Cyan
  } else {
    Write-Host "  路径类型: 标准 AppData 用户目录" -ForegroundColor Cyan
  }

  Write-Host ""
}
