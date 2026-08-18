# Legacy Skills 目录

本目录是历史遗留的 Skill 目录，仅为兼容已有配置而保留。Skill 正文的唯一源仓库是：

```text
/Users/hank/workspace/mine/workflow.skills
```

`install-ai-ide.sh` 默认从 `workflow.skills` 自动发现包含 `SKILL.md` 的一级目录，不再从本目录读取 Skill。

请不要在本目录新增或修改 Skill。源仓库不在默认位置时，可以通过环境变量指定：

```bash
WORKFLOW_SKILLS_DIR=/path/to/workflow.skills \
  ./ai-ide/install-ai-ide.sh /path/to/project
```

迁移历史 Skill 时，请先确认 `workflow.skills` 中已经存在对应目录，再清理目标项目中指向旧目录的软链接。
