# Claude 配置

本目录默认只纳入 Claude Code 的必要配置文件：

- `settings.json`
- `settings-*.json`（可选的环境变体）

其余目录/文件（如 `history.jsonl`、`sessions/`、`projects/`、`debug/` 等）均为运行时数据，已通过 `.gitignore` 忽略，不建议提交。

安装方式：

```bash
./install.sh claude
```

会创建软链接：

- `~/.claude -> <dotfiles>/claude`
