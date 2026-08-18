# AI IDE 配置

本目录提供 AI IDE 的安装脚本、Steering 规则和本机适配配置。

Skill 正文统一维护在 `/Users/hank/workspace/mine/workflow.skills`。本目录不再复制维护 Skill，而是负责把源仓库中的 Skill 安装到项目使用的 IDE 配置目录。

## 仓库分工

```text
workflow.skills              Skill 的唯一源仓库，维护 Skill 正文和使用说明
dotfiles/ai-ide              IDE 安装器、Steering 规则和本机适配层
dotfiles/ai-ide/skills       历史兼容目录，不作为默认 Skill 源
```

这样可以避免同一个 Skill 在两个仓库中出现两份内容，减少同步遗漏和版本不一致。

## 快速开始

在 `dotfiles` 仓库目录执行：

```bash
./ai-ide/install-ai-ide.sh ~/workspace/myproject
```

也可以指定 IDE：

```bash
./ai-ide/install-ai-ide.sh ~/workspace/myproject kiro
./ai-ide/install-ai-ide.sh ~/workspace/myproject kiro cursor windsurf
```

安装器默认读取与 `dotfiles` 同级的 `workflow.skills`。如果源仓库位于其他位置，可以覆盖环境变量：

```bash
WORKFLOW_SKILLS_DIR=/path/to/workflow.skills \
  ./ai-ide/install-ai-ide.sh ~/workspace/myproject cursor
```

安装后验证：

```bash
./ai-ide/verify-install.sh ~/workspace/myproject
```

## 当前 Skill

安装器会自动发现源仓库中直接包含 `SKILL.md` 的一级目录。当前包括：

| Skill | 适用场景 |
| --- | --- |
| `geekmo-tech-writer` | 以个人技术写作风格撰写和审阅技术文章 |
| `geekmo-zero-beginner-tutorial` | 面向零基础读者编写循序渐进的教程 |
| `write-professional-technical-content` | 编写、扩写、审阅专业技术文章和技术架构内容 |
| `superpowers-mermaid-diagrams` | 设计和优化 Mermaid 图表及其表达方式 |

Skill 可以按任务组合使用。例如，写一篇面向初学者的专业技术教程时，可以同时要求使用专业技术内容 Skill 和零基础教程 Skill；需要流程图时，再加入 Mermaid Skill。

## 更新方式

修改 `/Users/hank/workspace/mine/workflow.skills` 中的 Skill 后，已经安装的软链接会直接指向最新内容，通常不需要重新安装。重启 IDE 可确保它重新加载 Skill。

新增 Skill 时，只需要在 `workflow.skills` 下创建包含 `SKILL.md` 的一级目录，然后重新运行安装脚本或在目标项目中补充软链接。

`ai-ide/skills` 目录暂时保留用于兼容历史配置，但安装脚本默认不会读取它，也不建议继续在其中新增或修改 Skill。

## 支持的 IDE

- Kiro：`.kiro`
- Cursor：`.cursor`
- Windsurf：`.windsurf`
- Trae：`.trae`
- Antigravity：规则使用 `.antigravity`，Skill 使用 `.agent`
- Comate：`.comate`
- CodeBuddy：`.codebuddy`
- Lingma：`.lingma`

## 卸载

删除目标项目中对应的 Skill 软链接或 IDE 配置目录。确认目标路径后再执行删除操作：

```bash
rm -rf ~/workspace/myproject/.kiro/skills
```

## 故障排除

如果提示找不到 Skill 源仓库，请确认默认路径，或显式设置 `WORKFLOW_SKILLS_DIR`：

```bash
WORKFLOW_SKILLS_DIR=/Users/hank/workspace/mine/workflow.skills \
  ./ai-ide/verify-install.sh ~/workspace/myproject
```

如果 IDE 没有识别 Skill，先运行验证脚本检查软链接，再重启 IDE，并确认当前 IDE 版本支持该目录约定。

## 许可

MIT
