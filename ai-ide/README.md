# AI IDE 配置

这个目录包含了适用于各种 AI IDE 的共享配置,包括 skills 和 steering 规则。

## 目录结构

```
ai-ide/
├── steering/           # Steering 规则(适用于 Kiro 等)
│   └── git-commit-chinese.md
├── skills/            # Skills 定义(适用于 Kiro 等)
│   └── geekmo/
│       ├── SKILL.md
│       └── README.md
└── install-ai-ide.sh  # 安装脚本
```

## 支持的 AI IDE

- Kiro
- Cursor
- Windsurf
- Trae / Trae CN
- Antigravity
- Comate
- CodeBuddy
- Lingma

## 使用方法

### 方式一：自动检测安装（推荐）

```bash
cd /path/to/your/project
~/dotfiles/ai-ide/install-ai-ide.sh
```

脚本会自动检测项目中已有的 IDE 配置目录（如 `.kiro`, `.cursor` 等）并安装相应配置。

### 方式二：手动指定 IDE

```bash
# 安装到单个 IDE
cd /path/to/your/project
~/dotfiles/ai-ide/install-ai-ide.sh kiro

# 安装到多个 IDE
~/dotfiles/ai-ide/install-ai-ide.sh kiro cursor windsurf
```

### 方式三：通过主安装脚本

```bash
# 在 dotfiles 目录中
./install.sh ai-ide
```

注意：ai-ide 模块需要在项目目录中运行，主安装脚本会提示你如何使用。

## 配置说明

### Steering 规则

- `git-commit-chinese.md`: 强制使用中文 Git 提交信息

### Skills

- `geekmo`: 极客老墨写作风格,用于撰写技术文章

## 验证安装

```bash
# 查看软链接
ls -la .kiro/steering/
ls -la .kiro/skills/

# 应该看到类似输出：
# lrwxr-xr-x  git-commit-chinese.md -> ~/dotfiles/ai-ide/steering/git-commit-chinese.md
# lrwxr-xr-x  geekmo -> ~/dotfiles/ai-ide/skills/geekmo
```

## 注意事项

- 安装脚本会创建软链接,不会复制文件
- 如果项目已有配置,会自动备份（添加 `.backup.日期时间` 后缀）
- 不同 IDE 的配置目录结构可能不同,脚本会自动适配
- 修改 dotfiles 中的配置会立即影响所有已安装的项目
