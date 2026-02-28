# AI IDE Skills

这个目录包含了用于 AI IDE 的 Skills 配置。

## 可用的 Skills

### 1. geekmo-practice - 实战文章风格

**适用场景**：
- 问题解决类文章
- 工具使用经验分享
- 踩坑记录
- 技术选型分析

**特点**：
- 从具体问题出发
- 讲解决方案和实现过程
- 口语化更多，有故事性
- 可以有更长的背景介绍
- 总结侧重经验和踩坑记录

**使用方法**：
```
用 geekmo-practice 风格写一篇关于 Docker 部署的文章
```

**文章结构**：
```
开头：问题/场景描述（可以较长）
正文：解决过程 + 完整代码 + 关键部分解释
结尾：经验总结 + 踩坑记录
```

---

### 2. geekmo-course - 教程文章风格

**适用场景**：
- 编程语言系统化教程（Go/Rust/Python/JavaScript 等）
- 知识点讲解
- 概念说明
- 语法特性介绍

**特点**：
- 系统化讲解知识点
- 知识点拆解 + 小代码片段
- 口语化适度（开头/结尾）
- 最后给出完整示例
- 总结侧重知识点和实战建议
- 包含练习题

**使用方法**：
```
用 geekmo-course 风格写一篇 Go 函数的教程
用 geekmo-course 风格写一篇 Rust 所有权的教程
用 geekmo-course 风格写一篇 Python 装饰器的教程
```

**文章结构**：
```
开头：简短场景引入（2-3 段，150 字以内）
正文：知识点 1 + 代码片段
      知识点 2 + 代码片段
      ...
      完整示例
结尾：老墨总结 + 实战建议 + 练习题
```

---

## 两者对比

| 维度 | geekmo-practice (实战) | geekmo-course (教程) |
|------|----------------------|---------------------|
| 目标 | 解决具体问题 | 系统学习知识点 |
| 开头 | 可以更长的故事/背景 | 简短场景引入（2-3段） |
| 结构 | 问题 → 解决过程 → 方案 | 知识点拆解 → 完整示例 |
| 代码 | 完整代码 + 关键部分解释 | 小片段 + 最后完整代码 |
| 口语化 | 可以更多 | 适度（开头/结尾） |
| 总结 | 经验总结 + 踩坑记录 | 知识点列表 + 实战建议 |
| 练习题 | 无 | 3-6 道 |

## 如何选择

**选择 geekmo-practice**：
- ✅ 我遇到了一个问题，想分享解决方案
- ✅ 我想写工具使用经验
- ✅ 我想记录踩坑过程
- ✅ 我想分析技术选型

**选择 geekmo-course**：
- ✅ 我想系统讲解某个语言的特性
- ✅ 我想写知识点教程
- ✅ 我想让读者学会某个概念
- ✅ 我需要配练习题
- ✅ 适用于 Go、Rust、Python、JavaScript 等所有编程语言

## 安装

使用安装脚本自动安装到项目：

```bash
# 安装到指定项目（自动检测 IDE）
./install-ai-ide.sh ~/workspace/myproject

# 安装到指定 IDE
./install-ai-ide.sh ~/workspace/myproject kiro

# 安装到当前目录
./install-ai-ide.sh .
```

## 验证安装

```bash
# 查看已安装的 skills
ls -la ~/workspace/myproject/.kiro/skills

# 应该看到：
# geekmo-practice -> /path/to/dotfiles/ai-ide/skills/geekmo-practice
# geekmo-course -> /path/to/dotfiles/ai-ide/skills/geekmo-course
```

## 使用示例

### 实战文章示例

**提示词**：
```
用 geekmo-practice 风格写一篇文章：我在 Mac 上部署 Ollama 遇到的问题和解决方案
```

**生成的文章特点**：
- 开头会讲遇到的具体问题
- 中间会讲尝试的各种方案
- 会有完整的配置代码
- 结尾会总结经验和踩坑点

### 教程文章示例

**提示词**：
```
用 geekmo-course 风格写一篇 Go 切片的教程
用 geekmo-course 风格写一篇 Rust 生命周期的教程
用 geekmo-course 风格写一篇 Python 列表推导式的教程
```

**生成的文章特点**：
- 开头简短引入（对比其他语言）
- 逐个讲解特性（每个配代码片段）
- 最后给出完整示例
- 结尾有总结、建议和练习题

## 维护

如果需要修改 skill 内容：

1. 编辑 `dotfiles/ai-ide/skills/*/SKILL.md`
2. 重新运行安装脚本（软链接会自动更新）
3. 重启 IDE

## 贡献

欢迎提 PR 改进 skill 内容！
