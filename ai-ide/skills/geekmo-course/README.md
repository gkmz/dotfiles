# Geek Old Mo Course Writing Skill

这是一个 AI Agent Skill，专门用于编写"极客老墨"风格的编程语言教程系列文章。

## 简介

此 Skill 是 `geekmo` 的教程专用版本，专注于系统化的知识点讲解，而不是实战问题解决。

**支持语言**：Go、Rust、Python、JavaScript/TypeScript、Java、C/C++ 等所有编程语言。

**与 geekmo 的区别**:
- **geekmo**: 实战文章，从问题出发，讲解决方案，口语化更多
- **geekmo-course**: 教程文章，系统讲知识点，结构更清晰，口语化适度

**特点**:
- ✅ 简洁直接，不废话
- ✅ 知识点拆解 + 代码片段
- ✅ 适度口语化（开头/结尾）
- ✅ 完整示例 + 练习题
- ✅ 保持极客老墨的温度和个性

## 安装

使用 dotfiles 安装脚本自动安装到各个 AI IDE 项目中。

## 使用

在 Agent 对话中，明确要求使用教程风格和指定语言：

> 用 geekmo-course 风格写一篇 Go 函数的教程

> 用 geekmo-course 风格写一篇 Rust 所有权的教程

> 用 geekmo-course 风格写一篇 Python 装饰器的教程

或者：

> 这是教程类文章，用极客老墨的教程风格写 JavaScript 异步编程

## 目录结构

- `SKILL.md`: 核心指令文件，Agent 会读取此文件来获取写作规范
- `README.md`: 说明文档
