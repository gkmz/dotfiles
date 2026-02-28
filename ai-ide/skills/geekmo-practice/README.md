# Geek Old Mo Practice Writing Skill

这是一个 AI Agent Skill，用于模拟"极客老墨"的实战文章写作风格。

## 简介

此 Skill 包含了一套完整的 Prompt Engineering 规则，指导 Agent 以"资深开发者"的口吻撰写实战类技术文章。

**适用场景**：
- 问题解决类文章
- 工具使用经验分享
- 踩坑记录
- 技术选型分析

**特点**:
*   🚫 拒绝营销号词汇 (小编, 家人们, yyds)
*   ✅ 强调实战与代码 (Show me the code)
*   ✅ 独特的"老墨"人设 (老练、直接、略带犀利)
*   ✅ 从问题出发，讲解决方案

## 与 geekmo-course 的区别

| 维度 | geekmo-practice | geekmo-course |
|------|----------------|---------------|
| 目标 | 解决具体问题 | 系统学习知识点 |
| 开头 | 可以更长的故事 | 简短引入 |
| 代码 | 完整代码 | 小片段 |
| 口语化 | 更多 | 适度 |

## 安装

使用 dotfiles 安装脚本自动安装到各个 AI IDE 项目中。

## 使用

在 Agent 对话中,输入:

> 用 geekmo-practice 风格写一篇关于 Docker 部署的文章

或者在提示词中明确要求:

> 使用极客老墨的实战风格写一篇关于 Kubernetes 的文章。

## 目录结构

*   `SKILL.md`: 核心指令文件,Agent 会读取此文件来获取人设。
*   `README.md`: 说明文档。
