# Obsidian 全局主题（Minimal + AI 风格）

本目录用于给所有 Obsidian vault 应用统一主题样式，而不是只改某一个知识库。

## 文件说明

- `snippets/minimal-ai-global.css`：统一主题样式（浅色优先 + 自动兼容深色）
- `apply_global_theme.py`：将样式分发到所有 vault 并自动启用

## 一键应用

在仓库根目录执行：

```bash
python3 obsidian/apply_global_theme.py
```

脚本会自动执行：

1. 读取 `~/Library/Application Support/obsidian/obsidian.json` 的 vault 列表
2. 将 `minimal-ai-global.css` 复制到每个 vault 的 `.obsidian/snippets/`
3. 修改每个 vault 的 `.obsidian/app.json`：
   - `enabledCssSnippets` 加入 `minimal-ai-global`
   - `baseColorScheme` 设置为 `adapt-to-system`（跟随系统自动切换）
   - `cssTheme` 设置为 `Minimal`
4. 修改前自动备份 `app.json.backup.YYYYMMDD_HHMMSS`

## 生效方式

- 重启 Obsidian，或在命令面板执行：`Reload app without saving`

## 回滚

- 每个 vault 的 `.obsidian/app.json.backup.*` 可用于回滚
- 删除对应 vault 的 `snippets/minimal-ai-global.css` 并从 `enabledCssSnippets` 移除即可关闭该样式
