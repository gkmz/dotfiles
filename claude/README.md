# Claude 配置

本目录只保存 Claude Code 的必要配置文件：

- `settings.json`

全局指令与 Codex 共用，不在本目录重复保存：

- `CLAUDE.md` 使用 `codex/AGENTS.md`
- `RTK.md` 使用 `codex/RTK.md`（供 `AGENTS.md` 中的 `@RTK.md` 引用）

不会纳入以下运行时或敏感文件：

- `history.jsonl`、`sessions/`、`projects/`、`plugins/`、`backups/`、`shell-snapshots/` 等运行时目录

安装方式：

```bash
./install.sh claude
```

会创建以下软链接：

- `~/.claude/settings.json -> <dotfiles>/claude/settings.json`
- `~/.claude/CLAUDE.md -> <dotfiles>/codex/AGENTS.md`
- `~/.claude/RTK.md -> <dotfiles>/codex/RTK.md`

如果 `~/.claude` 是旧版安装留下的整目录软链接，安装脚本会先把它改回普通目录，旧运行时数据仍留在 `<dotfiles>/claude`（已被 `.gitignore` 忽略）。
