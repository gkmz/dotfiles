# Codex 配置

本目录只保存 Codex 的必要配置文件：

- `AGENTS.md`
- `config.toml`
- `mcp_config.json`
- `hooks.json`
- `keybindings.json`
- `rules/default.rules`

不会纳入以下运行时或敏感文件：

- `auth.json`
- `history.jsonl`
- `session_index.jsonl`
- `*.sqlite`
- `sessions/`、`log/`、`plugins/`、`skills/.system/` 等运行时或系统目录

共享 skill 不在本目录重复保存，统一使用 `ai-ide/skills/` 作为来源。

安装方式：

```bash
./install.sh codex
```

会创建以下软链接：

- `~/.codex/AGENTS.md -> <dotfiles>/codex/AGENTS.md`
- `~/.codex/config.toml -> <dotfiles>/codex/config.toml`
- `~/.codex/mcp_config.json -> <dotfiles>/codex/mcp_config.json`
- `~/.codex/hooks.json -> <dotfiles>/codex/hooks.json`
- `~/.codex/keybindings.json -> <dotfiles>/codex/keybindings.json`
- `~/.codex/rules/default.rules -> <dotfiles>/codex/rules/default.rules`
- `~/.codex/skills/geekmo-tech-writer -> <dotfiles>/ai-ide/skills/geekmo-tech-writer`
