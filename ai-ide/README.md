# AI IDE 配置

这个目录包含了用于各种 AI IDE 的配置文件，包括 Skills 和 Steering 规则。

## 目录结构

```
ai-ide/
├── skills/              # AI Agent Skills
│   ├── geekmo/         # 实战文章风格
│   ├── geekmo-course/  # 教程文章风格
│   └── README.md       # Skills 使用说明
├── steering/           # Steering 规则
│   └── *.md           # 各种规则文件
├── install-ai-ide.sh  # 安装脚本
└── README.md          # 本文件
```

## 快速开始

### 1. 安装到项目

```bash
# 自动检测项目使用的 IDE 并安装
./install-ai-ide.sh ~/workspace/myproject

# 安装到指定 IDE
./install-ai-ide.sh ~/workspace/myproject kiro

# 安装到多个 IDE
./install-ai-ide.sh ~/workspace/myproject kiro cursor windsurf

# 安装到当前目录
./install-ai-ide.sh .
```

### 2. 验证安装

```bash
# 查看已安装的 skills
ls -la ~/workspace/myproject/.kiro/skills

# 应该看到软链接指向 dotfiles
```

### 3. 使用 Skills

在 AI IDE 中，使用以下提示词：

**实战文章**（问题解决、经验分享）：
```
用 geekmo-practice 风格写一篇关于 Docker 部署的文章
```

**教程文章**（系统化知识讲解）：
```
用 geekmo-course 风格写一篇 Go 函数的教程
用 geekmo-course 风格写一篇 Rust 所有权的教程
用 geekmo-course 风格写一篇 Python 装饰器的教程
```

## 支持的 IDE

- Kiro (`.kiro`)
- Cursor (`.cursor`)
- Windsurf (`.windsurf`)
- Trae (`.trae`)
- Antigravity (`.antigravity`)
- Comate (`.comate`)
- CodeBuddy (`.codebuddy`)
- Lingma (`.lingma`)

## Skills 说明

### geekmo-practice - 实战文章风格

**适用场景**：
- 问题解决类文章
- 工具使用经验分享
- 踩坑记录
- 技术选型分析

**特点**：
- 从具体问题出发
- 讲解决方案和实现过程
- 口语化更多，有故事性
- 总结侧重经验和踩坑记录

### geekmo-course - 教程文章风格

**适用场景**：
- 编程语言系统化教程（Go/Rust/Python/JavaScript 等）
- 知识点讲解
- 概念说明
- 语法特性介绍

**特点**：
- 系统化讲解知识点
- 知识点拆解 + 小代码片段
- 口语化适度（开头/结尾）
- 包含完整示例和练习题

详细对比请查看 [skills/README.md](skills/README.md)

## 工作原理

安装脚本会在目标项目的 IDE 配置目录中创建软链接，指向 dotfiles 中的配置文件。这样：

1. **集中管理**：所有配置在 dotfiles 中统一维护
2. **自动同步**：修改 dotfiles 后，所有项目自动生效
3. **版本控制**：配置文件可以通过 git 管理
4. **多项目共享**：一次配置，多个项目使用

## 更新配置

如果修改了 skills 或 steering 内容：

1. 编辑 `dotfiles/ai-ide/skills/*/SKILL.md` 或 `steering/*.md`
2. 不需要重新运行安装脚本（软链接自动生效）
3. 重启 IDE 使配置生效

## 添加新的 Skill

1. 在 `skills/` 目录下创建新的 skill 目录
2. 添加 `SKILL.md` 和 `README.md`
3. 重新运行安装脚本

## 卸载

删除项目中的软链接：

```bash
rm -rf ~/workspace/myproject/.kiro/skills/geekmo
rm -rf ~/workspace/myproject/.kiro/skills/geekmo-course
rm -rf ~/workspace/myproject/.kiro/steering/*
```

或者删除整个配置目录：

```bash
rm -rf ~/workspace/myproject/.kiro
```

## 故障排除

### 软链接失效

如果移动了 dotfiles 目录，软链接会失效。重新运行安装脚本即可：

```bash
./install-ai-ide.sh ~/workspace/myproject
```

### IDE 无法识别 Skill

1. 检查软链接是否正确：`ls -la ~/.kiro/skills`
2. 重启 IDE
3. 确认 IDE 版本支持 Skills 功能

### 权限问题

确保安装脚本有执行权限：

```bash
chmod +x install-ai-ide.sh
```

## 贡献

欢迎提 PR 改进配置和脚本！

## 许可

MIT
