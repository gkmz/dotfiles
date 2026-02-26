# 我的 VSCode 系列 IDE 插件列表

> 最后更新：2026-02-25

## 📝 说明

这个列表记录了我在 Kiro、Cursor、Trae 等 IDE 中使用的插件。

## 🔧 编程语言支持

### Go
- **插件名称**: Go
- **插件 ID**: `golang.go`
- **用途**: Go 语言支持，包括语法高亮、代码补全、调试等
- **必装**: ✅

### Python
- **插件名称**: Python
- **插件 ID**: `ms-python.python`
- **用途**: Python 语言支持
- **必装**: ✅

### Rust
- **插件名称**: rust-analyzer
- **插件 ID**: `rust-lang.rust-analyzer`
- **用途**: Rust 语言支持
- **必装**: ✅

### Markdown
- **插件名称**: Markdown All in One
- **插件 ID**: `yzhang.markdown-all-in-one`
- **用途**: Markdown 编辑增强
- **必装**: ✅

## 🤖 AI 辅助

### GitHub Copilot
- **插件名称**: GitHub Copilot
- **插件 ID**: `github.copilot`
- **用途**: AI 代码补全
- **必装**: ⭐ (如果有订阅)

### Continue
- **插件名称**: Continue
- **插件 ID**: `continue.continue`
- **用途**: 开源 AI 编程助手，支持本地模型
- **必装**: ⭐

## 🎨 代码质量和格式化

### Prettier
- **插件名称**: Prettier - Code formatter
- **插件 ID**: `esbenp.prettier-vscode`
- **用途**: 代码格式化，支持 JavaScript、TypeScript、Markdown、JSON、YAML 等多种语言
- **必装**: ✅
- **配置说明**: 已在 settings.json 中配置为 JS/TS/Markdown 的默认格式化工具

### shell-format
- **插件名称**: shell-format
- **插件 ID**: `foxundermoon.shell-format`
- **用途**: Shell 脚本格式化
- **必装**: ✅ (如果写 Shell 脚本)
- **依赖**: 需要安装 `shfmt` 工具（`brew install shfmt`）
- **配置说明**: 已配置为 2 个空格缩进

### ESLint
- **插件名称**: ESLint
- **插件 ID**: `dbaeumer.vscode-eslint`
- **用途**: JavaScript/TypeScript 代码检查
- **必装**: ✅ (前端项目)

## ⌨️ 编辑器增强

### VSCode Neovim
- **插件名称**: VSCode Neovim
- **插件 ID**: `asvetliakov.vscode-neovim`
- **用途**: 在 VSCode 中集成 Neovim，使用 Vim 键位和命令
- **必装**: ⭐ (Vim 用户必备)

### IntelliJ IDEA Keybindings
- **插件名称**: IntelliJ IDEA Keybindings
- **插件 ID**: `k--kato.intellij-idea-keybindings`
- **用途**: 使用 IntelliJ IDEA 的快捷键
- **必装**: ⭐ (IDEA 用户)

## 🔨 工具增强

### LazyGit
- **插件名称**: LazyGit
- **插件 ID**: `ChaitanyaShahare.lazygit`
- **用途**: 在 VSCode 中集成 LazyGit，提供更好的 Git 操作体验
- **必装**: ⭐

### GitLens
- **插件名称**: GitLens
- **插件 ID**: `eamodio.gitlens`
- **用途**: Git 增强，显示代码作者、提交历史等
- **必装**: ⭐

### Todo Tree
- **插件名称**: Todo Tree
- **插件 ID**: `gruntfuggly.todo-tree`
- **用途**: 高亮和管理 TODO、FIXME 等标记
- **必装**: ✅

### Error Lens
- **插件名称**: Error Lens
- **插件 ID**: `usernamehw.errorlens`
- **用途**: 在代码行内显示错误和警告
- **必装**: ⭐

### Path Intellisense
- **插件名称**: Path Intellisense
- **插件 ID**: `christian-kohler.path-intellisense`
- **用途**: 路径自动补全
- **必装**: ✅

## 🎨 主题和美化

### One Dark Pro
- **插件名称**: One Dark Pro
- **插件 ID**: `zhuangtongfa.material-theme`
- **用途**: 主题
- **必装**: 个人喜好

### Material Icon Theme
- **插件名称**: Material Icon Theme
- **插件 ID**: `pkief.material-icon-theme`
- **用途**: 文件图标主题
- **必装**: 个人喜好

## 📦 其他实用插件

### Docker
- **插件名称**: Docker
- **插件 ID**: `ms-azuretools.vscode-docker`
- **用途**: Docker 支持
- **必装**: ✅ (如果使用 Docker)

### REST Client
- **插件名称**: REST Client
- **插件 ID**: `humao.rest-client`
- **用途**: 在 VSCode 中测试 HTTP 请求
- **必装**: ⭐

### Live Server
- **插件名称**: Live Server
- **插件 ID**: `ritwickdey.liveserver`
- **用途**: 本地开发服务器，支持热重载
- **必装**: ✅ (前端开发)

## 🚀 快速安装

### 方式一：手动安装
在 IDE 的扩展市场搜索插件 ID 并安装。

### 方式二：命令行安装（Kiro IDE）
```bash
# 必装插件
kiro --install-extension golang.go
kiro --install-extension ms-python.python
kiro --install-extension rust-lang.rust-analyzer
kiro --install-extension yzhang.markdown-all-in-one
kiro --install-extension esbenp.prettier-vscode
kiro --install-extension foxundermoon.shell-format
kiro --install-extension christian-kohler.path-intellisense
kiro --install-extension gruntfuggly.todo-tree

# 推荐插件
kiro --install-extension asvetliakov.vscode-neovim
kiro --install-extension ChaitanyaShahare.lazygit
kiro --install-extension eamodio.gitlens
kiro --install-extension usernamehw.errorlens
kiro --install-extension continue.continue

# 前端开发
kiro --install-extension dbaeumer.vscode-eslint
kiro --install-extension ritwickdey.liveserver

# Docker 相关
kiro --install-extension ms-azuretools.vscode-docker
```

### 方式三：安装 shfmt（shell-format 依赖）
```bash
# macOS
brew install shfmt

# Linux
# 下载二进制文件
curl -sS https://webinstall.dev/shfmt | bash
```

## 📝 维护日志

- 2026-02-26: 添加 shell-format 插件，更新 Prettier 配置说明
- 2026-02-26: 添加 VSCode Neovim、IntelliJ IDEA Keybindings、LazyGit 插件
- 2026-02-25: 初始化插件列表
- (在这里记录插件的添加、删除、更新)

## 💡 使用建议

1. **定期审查**: 每个月检查一次，删除不用的插件
2. **按需安装**: 不要一次性安装所有插件，按项目需要安装
3. **性能优先**: 插件太多会影响 IDE 性能
4. **记录原因**: 安装新插件时，记录为什么需要它

## 🔗 相关资源

- [VSCode 插件市场](https://marketplace.visualstudio.com/)
- [我的配置仓库](https://github.com/hankmor/dotfiles)
