# Dotfiles

> 极客老墨的开发环境配置

通过软链接统一管理所有开发工具的配置文件。

## 📁 包含的配置

- **VSCode 系列 IDE** - Kiro、Cursor、Trae、Antigravity、VSCode
- **Neovim** - 编辑器配置
- **终端** - Zsh、Bash 配置
- **Git** - 全局配置和条件包含
- **WezTerm** - 终端模拟器
- **Lazygit** - Git TUI 工具
- **Lazydocker** - Docker TUI 工具
- **OpenCode** - AI 编程工具
- **Codex** - Codex CLI 配置
- **Claude** - Claude Code 配置
- **BTOP** - 系统监控工具
- **Vim** - Vim 配置

## 🚀 快速开始

### 首次安装

```bash
# 克隆仓库
git clone git@github.com:hankmor/dotfiles.git ~/dotfiles

# 安装所有配置
cd ~/dotfiles
./install.sh
```

### Windows 一键安装

```powershell
git clone git@github.com:hankmor/dotfiles.git $HOME\dotfiles
cd $HOME\dotfiles
pwsh -ExecutionPolicy Bypass -File .\install.ps1
```

前置条件：

- 已安装 PowerShell 7+（`pwsh`）
- 已安装 `git`
- 如需安装 `vscode` 模块，需安装 `python` 或 `py`

也可以按模块安装：

```powershell
.\install.ps1 -List
.\install.ps1 config git
.\install.ps1 vscode
```

### 增量安装（推荐）

支持模块化安装，只安装需要的配置：

```bash
# 查看所有可用模块
./install.sh -l

# 只安装 VSCode 系列 IDE 配置
./install.sh vscode

# 只安装终端配置
./install.sh terminal

# 安装多个模块
./install.sh terminal git vim

# 查看帮助
./install.sh -h
```

**可用模块：**
- `config` - ~/.config 下的配置（nvim, wezterm, lazygit 等）
- `terminal` - 终端配置（.zshrc, .bashrc 等）
- `git` - Git 配置（.gitconfig 等）
- `vim` - Vim 配置（.vimrc）
- `codex` - Codex 配置（~/.codex 下必要文件）
- `claude` - Claude Code 配置（~/.claude 软链接）
- `vscode` - VSCode 系列 IDE 配置（包含 Kiro、Cursor、Trae、Antigravity 等衍生 IDE）

### 验证安装

```bash
# 检查软链接
ls -la ~/.config/nvim
ls -la ~/.zshrc
ls -la ~/.gitconfig

# 应该看到类似输出：
# ~/.config/nvim -> /Users/hank/dotfiles/nvim
# ~/.zshrc -> /Users/hank/dotfiles/terminal/.zshrc
```

## 📝 日常使用

### 修改配置

配置文件通过软链接管理，修改任何一边都会同步：

```bash
# 方式 A：直接修改 dotfiles（推荐）
vim ~/dotfiles/nvim/init.lua
vim ~/dotfiles/terminal/.zshrc

# 方式 B：修改实际位置（效果相同）
vim ~/.config/nvim/init.lua
vim ~/.zshrc
```

### 提交变更

```bash
cd ~/dotfiles
git add .
git commit -m "配置: 更新 XXX"
git push
```

### 同步到其他机器

```bash
# 在新机器上
git clone git@github.com:hankmor/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh

# 配置自动生效
```

### 增量更新配置

如果只修改了某个模块的配置，可以只重新安装该模块：

```bash
# 更新了 .zshrc
./install.sh terminal
# 脚本会智能检测，如果软链接已存在且正确，会跳过

# 修改了 VSCode 系列 IDE（包括 Cursor/Kiro 等）的 keybindings/settings
cd vscode
python generate_ide_configs.py
cd ..
./install.sh vscode
```

## 🔧 工作原理

安装后，实际配置文件是指向 dotfiles 的软链接：

```
~/.config/nvim  →  ~/dotfiles/nvim/
~/.zshrc        →  ~/dotfiles/terminal/.zshrc
~/.gitconfig    →  ~/dotfiles/git/.gitconfig
```

修改任何一边，另一边自动同步，只需关心 Git 提交。

### Windows 路径策略

Windows 不是所有软件都把配置放在安装目录里，因此 `install.ps1` 分成两类处理：

- **标准用户配置目录**：即使软件用 Scoop 安装，配置仍在 `%APPDATA%` / `%LOCALAPPDATA%`
  - `nvim` -> `%LOCALAPPDATA%\nvim`
  - `lazygit` -> `%LOCALAPPDATA%\lazygit\config.yml`
  - `lazydocker` -> `%APPDATA%\lazydocker\config.yml`
  - `wireshark` -> `%APPDATA%\Wireshark`
- **便携 / 安装目录内配置**：优先探测 portable 目录，再回退到标准 `%APPDATA%`
  - 普通安装：`%APPDATA%\{IDE}\User`
  - 便携安装：`<安装目录>\data\user-data\User`
  - Scoop 安装：优先 `%SCOOP%\persist\<app>\data\user-data\User`，其次 `%SCOOP%\apps\<app>\current\data\user-data\User`

也就是说，Windows 脚本不会粗暴地把所有配置都链到安装目录，只对 VSCode 系列这种支持 portable data 目录的软件这么做；其余软件仍然链到各自官方用户配置目录。

### Windows 当前支持

- `config`: `nvim`、`wezterm`、`lazygit`、`lazydocker`、`wireshark`
- `codex`: `~/.codex/config.toml`、`~/.codex/mcp_config.json`、`~/.codex/rules/default.rules`
- `claude`: `~/.claude`（目录软链接，仓库中仅跟踪必要配置，运行时文件已忽略）
- `git`: 使用 `~\.gitconfig` 等软链接
- `vim`: 使用 `~\_vimrc`
- `vscode`: 自动识别 VSCode、Cursor、Windsurf、Kiro、Trae、Antigravity 的标准安装 / 便携安装 / Scoop 安装

以下目录暂未做 Windows 自动映射：`btop`、`neofetch`、`raycast`、`uv`、`waveterm`、`zed`、`opencode`、`dlv`

## ⚠️ 敏感信息处理

### 使用本地配置文件

对于包含敏感信息的配置，使用 `.local` 文件：

**Zsh 配置**：
```bash
# 在 .zshrc 末尾已添加
[ -f ~/.zshrc.local ] && source ~/.zshrc.local

# 创建本地配置
vim ~/.zshrc.local
# 在这里添加 API Keys、Tokens 等敏感信息
```

**Git 配置**：
```bash
# 在 .gitconfig 末尾已添加
[include]
    path = ~/.gitconfig.local

# 创建本地配置
vim ~/.gitconfig.local
# 在这里添加代理、特殊 SSH 配置等
```

`.local` 文件已在 `.gitignore` 中，不会提交到 Git。

**Codex 配置**：
```bash
# 仅同步必要配置：
# ~/.codex/config.toml
# ~/.codex/mcp_config.json
# ~/.codex/rules/default.rules

# 不同步 auth/history/sessions/sqlite 等运行时或敏感文件
```

**Claude 配置**：
```bash
# 同步目录：~/.claude -> <dotfiles>/claude

# 默认仅提交：
# ~/.claude/settings.json
# ~/.claude/settings-*.json

# 不同步 history/sessions/projects/debug/telemetry 等运行时文件
```

## 🗂️ 目录结构

```
dotfiles/
├── README.md              # 本文件
├── install.sh             # macOS / Linux 安装脚本
├── install.ps1            # Windows 安装脚本
├── uninstall.sh           # 卸载脚本
├── .gitignore             # Git 忽略规则
│
├── vscode/                # VSCode 系列 IDE 统一配置
│   ├── settings.json      # VSCode 系列通用 settings 基础配置
│   ├── keybindings.json   # VSCode 系列通用 keybindings 基础配置
│   ├── generate_ide_configs.py  # 生成各 IDE 最终配置的脚本
│   ├── install.sh         # macOS / Linux 下将各 IDE 配置软链接到系统目录
│   ├── install.ps1        # Windows 下将各 IDE 配置软链接到系统目录
│   ├── vscode/            # 原生 VSCode 专用配置（合并结果）
│   ├── cursor/            # Cursor 专用配置（合并结果）
│   ├── kiro/              # Kiro IDE 专用配置（合并结果）
│   ├── antigravity/       # Antigravity IDE 专用配置（合并结果）
│   ├── winds* / trae/ ... # 其它 VSCode 衍生 IDE 专用配置（合并结果）
│   └── my-extensions.md
│
├── nvim/                  # Neovim 配置
│   └── install.sh
│
├── terminal/              # 终端配置
│   ├── .zshrc
│   ├── .bashrc
│   ├── .bash_profile
│   ├── .profile
│   ├── .zshrc.local.example
│   └── install.sh
│
├── git/                   # Git 配置
│   ├── .gitconfig
│   ├── .gitconfig.local.example
│   ├── .git_me            # 个人项目配置
│   ├── .git_wk            # 工作项目配置
│   ├── .git_os            # 开源项目配置
│   ├── .git_cc            # 区块链项目配置
│   ├── README.md
│   └── install.sh
│
├── wezterm/               # WezTerm 配置
├── lazygit/               # Lazygit 配置
├── lazydocker/            # Lazydocker 配置
├── opencode/              # OpenCode 配置
├── codex/                 # Codex 配置（仅必要文件）
├── claude/                # Claude Code 配置（仅必要文件）
├── btop/                  # BTOP 配置
└── vim/                   # Vim 配置
```

## 🔄 卸载配置

如果需要恢复独立配置：

```bash
cd ~/dotfiles
./uninstall.sh
```

这会删除所有软链接，并提示如何从备份恢复。

## 💡 常见问题

### Q: 修改配置后需要重启吗？

A: 大部分配置会自动生效，少数需要重启应用：
- Neovim: 重启 Neovim
- WezTerm: 重启 WezTerm  
- Zsh: 运行 `source ~/.zshrc`
- Git: 立即生效

### Q: 如何在多台机器间同步？

A: 
```bash
# 机器 A 修改配置
cd ~/dotfiles
git add .
git commit -m "配置: XXX"
git push

# 机器 B 同步配置
cd ~/dotfiles
git pull
# 配置自动生效
```

### Q: 如何添加新的配置？

A:
1. 将配置复制到 dotfiles 对应目录
2. 创建 install.sh 脚本（参考其他配置）
3. 在总 install.sh 中添加安装命令
4. 提交到 Git

## 📚 详细说明

- Git 配置说明：[git/README.md](./git/README.md)
- VSCode 插件管理：[vscode/my-extensions.md](./vscode/my-extensions.md)

## 📄 许可证

MIT License

---

**极客老墨的开发环境配置**

📝 [博客](https://hankmo.com) | 💻 [GitHub](https://github.com/hankmor) | 📱 微信公众号：**极客老墨**

<p align="center">
  <img src="./weixinqr.jpg" alt="微信公众号：极客老墨" width="200"/>
</p>

> 关注公众号，获取更多开发技巧和工具推荐
