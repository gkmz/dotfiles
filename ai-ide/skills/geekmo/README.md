# Geek Old Mo Writer Skill

这是一个 AI Agent Skill,用于模拟"极客老墨"的写作风格。

## 简介

此 Skill 包含了一套完整的 Prompt Engineering 规则,指导 Agent 以"资深开发者"的口吻撰写技术教程。

**特点**:
*   🚫 拒绝营销号词汇 (小编, 家人们, yyds)
*   ✅ 强调实战与代码 (Show me the code)
*   ✅ 独特的"老墨"人设 (老练、直接、略带犀利)

## 安装

使用 dotfiles 安装脚本自动安装到各个 AI IDE 项目中。

## 使用

在 Agent 对话中,输入:

> run skill write_geek_content

或者在提示词中明确要求:

> 使用极客老墨的风格写一篇关于 Kubernetes 的教程。

## 目录结构

*   `SKILL.md`: 核心指令文件,Agent 会读取此文件来获取人设。
*   `README.md`: 说明文档。
