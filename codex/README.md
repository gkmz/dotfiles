# Codex 配置

本目录只保存 Codex 的必要配置文件：

- `config.toml`
- `mcp_config.json`
- `rules/default.rules`

不会纳入以下运行时或敏感文件：

- `auth.json`
- `history.jsonl`
- `session_index.jsonl`
- `*.sqlite`
- `sessions/`、`log/` 等目录

安装方式：

```bash
./install.sh codex
```

会创建以下软链接：

- `~/.codex/config.toml -> <dotfiles>/codex/config.toml`
- `~/.codex/mcp_config.json -> <dotfiles>/codex/mcp_config.json`
- `~/.codex/rules/default.rules -> <dotfiles>/codex/rules/default.rules`
