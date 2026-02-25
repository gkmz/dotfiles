# VSCode 系列 IDE 插件管理

## 为什么要维护插件列表？

1. **快速恢复环境**：换机器或重装系统时，一键安装所有插件
2. **团队协作**：团队成员使用相同的插件，保持开发环境一致
3. **记录备忘**：记录每个插件的用途，避免忘记为什么安装
4. **版本控制**：跟踪插件的变化历史

## 管理方式

### 方式一：手动维护列表（推荐）

创建 `extensions.md` 文件，记录插件信息：

```markdown
# 必装插件

## 编程语言支持
- **Go** (golang.go) - Go 语言支持
- **Python** (ms-python.python) - Python 语言支持
- **Rust** (rust-lang.rust-analyzer) - Rust 语言支持

## AI 辅助
- **GitHub Copilot** (github.copilot) - AI 代码补全
- **Continue** (continue.continue) - 开源 AI 助手

## 代码质量
- **ESLint** (dbaeumer.vscode-eslint) - JavaScript 代码检查
- **Prettier** (esbenp.prettier-vscode) - 代码格式化

## 工具增强
- **GitLens** (eamodio.gitlens) - Git 增强
- **Todo Tree** (gruntfuggly.todo-tree) - TODO 高亮
- **Error Lens** (usernamehw.errorlens) - 错误提示增强

## 主题和美化
- **One Dark Pro** (zhuangtongfa.material-theme) - 主题
- **Material Icon Theme** (pkief.material-icon-theme) - 图标主题
```

**优点**：
- 可以添加注释说明
- 灵活，可以分类
- 易于阅读和维护

### 方式二：导出插件列表脚本

创建脚本自动导出已安装的插件：

```bash
#!/bin/bash
# export-extensions.sh

echo "# Kiro 插件列表" > extensions-kiro.txt
echo "生成时间: $(date)" >> extensions-kiro.txt
echo "" >> extensions-kiro.txt

# 这里需要根据实际情况调整命令
# Kiro 可能使用 kiro --list-extensions 或类似命令
```

### 方式三：使用 extensions.json

在项目的 `.vscode/` 目录创建 `extensions.json`：

```json
{
  "recommendations": [
    "golang.go",
    "ms-python.python",
    "rust-lang.rust-analyzer",
    "github.copilot",
    "continue.continue",
    "eamodio.gitlens"
  ]
}
```

**注意**：这个文件是项目级的推荐插件，不是全局配置。

## 推荐方案

结合使用：

1. **手动维护 `extensions.md`**（主要）
   - 记录所有插件及其用途
   - 分类管理
   - 添加使用说明

2. **定期导出列表**（辅助）
   - 用脚本导出当前安装的插件
   - 对比 `extensions.md`，查漏补缺

3. **项目级推荐**（可选）
   - 在特定项目中使用 `.vscode/extensions.json`
   - 推荐项目相关的插件

## 安装脚本

创建 `install-extensions.sh`，根据列表批量安装插件：

```bash
#!/bin/bash

# 从 extensions.md 中提取插件 ID 并安装
# 需要根据实际的插件管理命令调整
```

## 同步到其他 IDE

由于 Kiro、Cursor、Trae 等都基于 VSCode，大部分插件是通用的，可以：

1. 维护一份通用插件列表
2. 为每个 IDE 创建特定的插件列表（如果有差异）
3. 使用脚本批量安装到所有 IDE

## 注意事项

1. **插件兼容性**：某些插件可能不兼容所有 IDE
2. **定期更新**：插件列表要定期更新，删除不用的插件
3. **备注说明**：记录每个插件的用途，方便以后回顾
4. **分类管理**：按功能分类，便于查找和管理
