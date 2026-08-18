# AI IDE Skills 快速开始

## 安装

```bash
cd /Users/hank/workspace/mine/dotfiles
./ai-ide/install-ai-ide.sh ~/workspace/myproject
```

默认 Skill 源仓库是：

```text
/Users/hank/workspace/mine/workflow.skills
```

源仓库不在默认位置时：

```bash
WORKFLOW_SKILLS_DIR=/path/to/workflow.skills \
  ./ai-ide/install-ai-ide.sh ~/workspace/myproject cursor
```

## Skill 选择

| 需求 | Skill |
| --- | --- |
| 个人风格的技术文章 | `geekmo-tech-writer` |
| 面向零基础读者的教程 | `geekmo-zero-beginner-tutorial` |
| 专业技术文章、技术架构、系统审阅 | `write-professional-technical-content` |
| Mermaid 流程图、时序图、架构图 | `superpowers-mermaid-diagrams` |

示例：

```text
使用 write-professional-technical-content 改写这篇 Context 教程。
使用 write-professional-technical-content 和 superpowers-mermaid-diagrams，补充一张请求取消流程图。
```

## 验证

```bash
./ai-ide/verify-install.sh ~/workspace/myproject
```

验证脚本会根据 `workflow.skills` 中实际存在的 `SKILL.md` 检查全部 Skill，不再依赖固定的 Skill 名单。

## 更新

Skill 正文只在 `/Users/hank/workspace/mine/workflow.skills` 中维护。修改后，已安装的软链接会自动指向新内容；重启 IDE 使其重新加载即可。通常不需要修改 `dotfiles/ai-ide/skills`，也不需要重复复制文件。

## 个人命名是否可以

可以。Skill 名称可以体现个人风格、方法论或工作流，例如 `geekmo-tech-writer`。只要名称稳定、描述清楚、适用边界明确，并且不与其他 Skill 产生严重重叠，就不需要为了通用化而改名。
