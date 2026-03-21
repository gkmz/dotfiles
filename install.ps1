param(
  [Parameter(Position = 0, ValueFromRemainingArguments = $true)]
  [string[]]$Modules,
  [switch]$Help,
  [Alias("l")][switch]$List,
  [Alias("a")][switch]$All
)

$ErrorActionPreference = "Stop"

$DotfilesDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$Timestamp = Get-Date -Format "yyyyMMdd_HHmmss"

function Write-Section {
  param([string]$Message)
  Write-Host ""
  Write-Host "=== $Message ===" -ForegroundColor Blue
  Write-Host ""
}

function Write-Step {
  param([string]$Message)
  Write-Host $Message -ForegroundColor Yellow
}

function Write-Ok {
  param([string]$Message)
  Write-Host "  [ok] $Message" -ForegroundColor Green
}

function Write-Warn {
  param([string]$Message)
  Write-Host "  [warn] $Message" -ForegroundColor Yellow
}

function Show-Help {
  Write-Host "用法:"
  Write-Host "  .\install.ps1 [选项] [模块...]"
  Write-Host ""
  Write-Host "选项:"
  Write-Host "  -Help        显示帮助信息"
  Write-Host "  -List        列出所有可用模块"
  Write-Host "  -All         安装所有模块（默认）"
  Write-Host ""
  Write-Host "可用模块:"
  Write-Host "  config       Windows 下支持的图形/CLI 配置（nvim, wezterm, lazygit 等）"
  Write-Host "  terminal     终端 shell 配置（Windows 下默认跳过）"
  Write-Host "  git          Git 配置（.gitconfig 等）"
  Write-Host "  vim          Vim 配置（Windows 使用 _vimrc）"
  Write-Host "  vscode       VSCode 系列 IDE 配置"
  Write-Host ""
  Write-Host "示例:"
  Write-Host "  .\install.ps1"
  Write-Host "  .\install.ps1 config git"
  Write-Host "  .\install.ps1 vscode"
  Write-Host "  .\install.ps1 -List"
  Write-Host ""
}

function List-Modules {
  Write-Host "可用模块:"
  Write-Host "  [ok] config   - Windows 下支持的配置"
  Write-Host "  [ok] terminal - 终端 shell 配置（Windows 下默认跳过）"
  Write-Host "  [ok] git      - Git 配置"
  Write-Host "  [ok] vim      - Vim 配置"
  Write-Host "  [ok] vscode   - VSCode 系列 IDE 配置"
  Write-Host ""
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

function New-Symlink {
  param(
    [string]$Source,
    [string]$Target
  )

  $targetParent = Split-Path -Parent $Target
  if ($targetParent) {
    New-Item -ItemType Directory -Path $targetParent -Force | Out-Null
  }

  $sourceItem = Get-Item -LiteralPath $Source -Force
  $linkType = if ($sourceItem.PSIsContainer) { "SymbolicLink" } else { "SymbolicLink" }
  New-Item -ItemType $linkType -Path $Target -Target $Source -Force | Out-Null
}

function Backup-And-Link {
  param(
    [string]$Source,
    [string]$Target,
    [string]$Name
  )

  if (-not (Test-Path -LiteralPath $Source)) {
    Write-Warn "$Name 源路径不存在，跳过: $Source"
    return
  }

  Write-Step "安装 $Name"

  $existingTarget = Get-LinkTarget -Path $Target
  if ($existingTarget) {
    try {
      if ((Resolve-Path -LiteralPath $existingTarget).Path -eq (Resolve-Path -LiteralPath $Source).Path) {
        Write-Ok "已存在正确的软链接，跳过"
        return
      }
    } catch {
    }
  }

  if (Test-Path -LiteralPath $Target) {
    $item = Get-Item -LiteralPath $Target -Force
    if ($item.Attributes -band [IO.FileAttributes]::ReparsePoint) {
      Remove-Item -LiteralPath $Target -Force
    } else {
      $backup = "$Target.backup.$Timestamp"
      Move-Item -LiteralPath $Target -Destination $backup
      Write-Warn "已备份现有配置: $backup"
    }
  }

  New-Symlink -Source $Source -Target $Target
  Write-Ok "创建软链接: $Target -> $Source"
}

function Resolve-UserHome {
  return [Environment]::GetFolderPath("UserProfile")
}

function Install-Config {
  Write-Section "安装 Windows 配置"

  $userHome = Resolve-UserHome
  $appData = [Environment]::GetFolderPath("ApplicationData")
  $localAppData = [Environment]::GetFolderPath("LocalApplicationData")

  Backup-And-Link -Source (Join-Path $DotfilesDir "nvim") -Target (Join-Path $localAppData "nvim") -Name "nvim"
  Backup-And-Link -Source (Join-Path $DotfilesDir "lazygit\config.yml") -Target (Join-Path $localAppData "lazygit\config.yml") -Name "lazygit"
  Backup-And-Link -Source (Join-Path $DotfilesDir "lazydocker\config.yml") -Target (Join-Path $appData "lazydocker\config.yml") -Name "lazydocker"
  Backup-And-Link -Source (Join-Path $DotfilesDir "wireshark") -Target (Join-Path $appData "Wireshark") -Name "wireshark"

  $weztermConfigDir = Join-Path $userHome ".config\wezterm"
  Backup-And-Link -Source (Join-Path $DotfilesDir "wezterm") -Target $weztermConfigDir -Name "wezterm dir"
  Backup-And-Link -Source (Join-Path $DotfilesDir "wezterm\wezterm.lua") -Target (Join-Path $userHome ".wezterm.lua") -Name "wezterm entry"

  $unsupported = @("btop", "neofetch", "raycast", "uv", "waveterm", "zed", "opencode", "dlv")
  foreach ($name in $unsupported) {
    if (Test-Path -LiteralPath (Join-Path $DotfilesDir $name)) {
      Write-Warn "$name 未写入 Windows 映射，暂未自动安装"
    }
  }
}

function Install-Terminal {
  Write-Section "安装终端配置"
  Write-Warn "Windows 默认 shell 不是 zsh/bash，terminal 模块当前不自动安装"
}

function Install-Git {
  Write-Section "安装 Git 配置"

  $userHome = Resolve-UserHome
  Backup-And-Link -Source (Join-Path $DotfilesDir "git\.gitconfig") -Target (Join-Path $userHome ".gitconfig") -Name ".gitconfig"

  $optionalFiles = @(".gitignore", ".git_me", ".git_wk", ".git_os", ".git_cc")
  foreach ($file in $optionalFiles) {
    $source = Join-Path $DotfilesDir "git\$file"
    if (Test-Path -LiteralPath $source) {
      Backup-And-Link -Source $source -Target (Join-Path $userHome $file) -Name $file
    }
  }

  Write-Warn ".gitconfig 当前仍包含 macOS 相关项（如 osxkeychain），如需纯 Windows 行为请继续拆分条件配置"
}

function Install-Vim {
  Write-Section "安装 Vim 配置"
  $userHome = Resolve-UserHome
  Backup-And-Link -Source (Join-Path $DotfilesDir "vim\.vimrc") -Target (Join-Path $userHome "_vimrc") -Name "_vimrc"
}

function Get-PythonCommand {
  if (Get-Command python -ErrorAction SilentlyContinue) {
    return @("python", "generate_ide_configs.py")
  }

  if (Get-Command py -ErrorAction SilentlyContinue) {
    return @("py", "generate_ide_configs.py")
  }

  throw "未找到 python/py，无法生成 VSCode 系列 IDE 的合并配置"
}

function Install-VSCode {
  Write-Section "安装 VSCode 系列 IDE 配置"

  $vscodeDir = Join-Path $DotfilesDir "vscode"
  $pythonCommand = Get-PythonCommand
  $pythonExe = $pythonCommand[0]
  $pythonArgs = $pythonCommand[1..($pythonCommand.Length - 1)]

  Write-Step "生成各 IDE 合并配置"
  Push-Location $vscodeDir
  try {
    & $pythonExe @pythonArgs
  } finally {
    Pop-Location
  }

  Write-Step "应用配置到已安装的 IDE"
  & (Join-Path $vscodeDir "install.ps1")
}

function Install-All {
  Install-Config
  Install-Terminal
  Install-Git
  Install-Vim
  Install-VSCode
}

function Invoke-Module {
  param([string]$Name)

  switch ($Name) {
    "config" { Install-Config }
    "terminal" { Install-Terminal }
    "git" { Install-Git }
    "vim" { Install-Vim }
    "vscode" { Install-VSCode }
    default { throw "未知模块: $Name" }
  }
}

Write-Host ""
Write-Host "Dotfiles Windows 安装" -ForegroundColor Green
Write-Host ""

if ($Help) {
  Show-Help
  exit 0
}

if ($List) {
  List-Modules
  exit 0
}

if ($All -or -not $Modules -or $Modules.Count -eq 0) {
  Install-All
  exit 0
}

foreach ($module in $Modules) {
  Invoke-Module -Name $module
}
