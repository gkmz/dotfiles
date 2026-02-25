# Git 配置说明

## 📁 文件结构

```
git/
├── .gitconfig              # 主配置文件
├── .gitconfig.local.example # 本地配置模板
├── .git_me                 # 个人项目配置
├── .git_wk                 # 工作项目配置
├── .git_os                 # 开源项目配置
├── .git_cc                 # 区块链项目配置
├── .gitignore              # 全局忽略文件
├── install.sh              # 安装脚本
└── README.md               # 本文件
```

## 🎯 配置说明

### 条件包含（Conditional Includes）

根据项目目录自动使用不同的 Git 用户信息：

| 目录 | 配置文件 | 用户名 | 邮箱 |
|------|---------|--------|------|
| `~/workspace/opensource/` | `.git_os` | hankmo | hankmo.x@gmail.com |
| `~/workspace/` | `.git_me` | hankmo | hankmo.x@gmail.com |
| `~/workspace/work/` | `.git_wk` | myalay | myalay2024@gmail.com |
| `~/workspace/mine/blockchain/` | `.git_cc` | hankmo | hankmo.x@gmail.com |

### 工作原理

当你在不同目录下使用 Git 时，会自动应用对应的配置：

```bash
# 在个人项目中
cd ~/workspace/mine/myproject
git config user.name   # 输出: hankmo
git config user.email  # 输出: hankmo.x@gmail.com

# 在工作项目中
cd ~/workspace/work/company-project
git config user.name   # 输出: myalay
git config user.email  # 输出: myalay2024@gmail.com
```

## 🔧 主要配置

### 核心配置
- 默认编辑器：Neovim
- 行尾符：自动转换（input）
- 全局忽略文件：`~/.gitignore`

### 别名
- `git st` → `git status`
- `git co` → `git checkout`
- `git br` → `git branch`
- `git ci` → `git commit`
- `git lg` → 图形化日志
- `git last` → 查看最后一次提交
- `git unstage` → 取消暂存
- `git amend` → 修改最后一次提交
- `git undo` → 撤销最后一次提交（保留修改）

### 推送和拉取
- 推送策略：simple
- 拉取策略：merge（不使用 rebase）

### 工具配置
- 差异工具：vimdiff
- 合并工具：vimdiff
- 凭证助手：osxkeychain（macOS）

## 📝 使用说明

### 安装配置

```bash
cd ~/dotfiles/git
./install.sh
```

这会创建软链接：
- `~/.gitconfig` → `~/dotfiles/git/.gitconfig`
- `~/.git_me` → `~/dotfiles/git/.git_me`
- `~/.git_wk` → `~/dotfiles/git/.git_wk`
- `~/.git_os` → `~/dotfiles/git/.git_os`
- `~/.git_cc` → `~/dotfiles/git/.git_cc`
- `~/.gitignore` → `~/dotfiles/git/.gitignore`

### 本地配置

如果需要本地特定的配置（如代理、特殊 SSH 密钥等）：

```bash
# 复制模板
cp ~/dotfiles/git/.gitconfig.local.example ~/.gitconfig.local

# 编辑本地配置
vim ~/.gitconfig.local
```

`.gitconfig.local` 不会提交到 Git（已在 .gitignore 中）。

### 修改用户信息

如果需要修改某个目录的用户信息：

```bash
# 编辑对应的配置文件
vim ~/dotfiles/git/.git_me    # 个人项目
vim ~/dotfiles/git/.git_wk    # 工作项目
vim ~/dotfiles/git/.git_os    # 开源项目
vim ~/dotfiles/git/.git_cc    # 区块链项目

# 提交变更
cd ~/dotfiles
git add git/
git commit -m "配置: 更新 Git 用户信息"
git push
```

### 添加新的目录配置

如果需要为新目录添加特定配置：

1. 创建新的配置文件：
```bash
vim ~/dotfiles/git/.git_newproject
```

2. 在 `.gitconfig` 中添加条件包含：
```ini
[includeIf "gitdir:~/workspace/newproject/"]
    path = ~/.git_newproject
```

3. 安装配置：
```bash
cd ~/dotfiles/git
./install.sh
```

## 🔍 验证配置

### 检查当前配置

```bash
# 查看所有配置
git config --list

# 查看用户信息
git config user.name
git config user.email

# 查看配置来源
git config --show-origin user.name
```

### 测试条件包含

```bash
# 在不同目录测试
cd ~/workspace/mine/test
git config user.email  # 应该是 hankmo.x@gmail.com

cd ~/workspace/work/test
git config user.email  # 应该是 myalay2024@gmail.com
```

## ⚠️ 注意事项

1. **条件包含的顺序很重要**
   - 更具体的路径应该放在前面
   - 例如：`~/workspace/mine/blockchain/` 应该在 `~/workspace/` 之前

2. **路径必须以 `/` 结尾**
   - ✅ `gitdir:~/workspace/work/`
   - ❌ `gitdir:~/workspace/work`

3. **本地配置不要提交**
   - `.gitconfig.local` 已在 .gitignore 中
   - 用于存放敏感信息或机器特定配置

## 📚 参考资源

- [Git 配置文档](https://git-scm.com/docs/git-config)
- [条件包含文档](https://git-scm.com/docs/git-config#_conditional_includes)
