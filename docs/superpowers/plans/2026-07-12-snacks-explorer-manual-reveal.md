# Snacks Explorer Manual Reveal Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 禁止 Snacks Explorer 自动跟随当前 buffer，并通过 `<leader>fe` 手动定位当前文件。

**Architecture:** 只修改现有 Snacks 插件规格：在 Explorer picker source 上覆盖默认 `follow_file`，并通过插件级快捷键调用官方 `Snacks.explorer.reveal()`。保留 LazyVim 的 `<leader>e` 及现有 Explorer 行为。

**Tech Stack:** Neovim Lua、LazyVim、snacks.nvim

## Global Constraints

- `<leader>e` 保持现有打开或关闭 Explorer 的行为。
- 不修改 Explorer 的文件打开、目录展开或搜索行为。
- 关键配置添加清晰的中文注释。

---

### Task 1: 配置手动定位

**Files:**
- Modify: `nvim/lua/plugins/snack.lua:74-109`

**Interfaces:**
- Consumes: `Snacks.explorer.reveal(opts?)`
- Produces: `<leader>fe` 普通模式快捷键；Explorer source 的 `follow_file = false` 配置

- [ ] **Step 1: 记录修改前的配置加载基线**

Run: `nvim --headless "+lua require('config.lazy')" +qa`

Expected: 进程退出码为 `0`，没有 Lua 配置错误。

- [ ] **Step 2: 添加最小配置**

在 `picker.sources.explorer` 中增加：

```lua
-- 文件树保持用户当前浏览位置，仅在显式触发时定位当前文件。
follow_file = false,
```

在 `keys` 中增加：

```lua
{
  "<leader>fe",
  function()
    Snacks.explorer.reveal()
  end,
  desc = "Reveal Current File in Explorer",
},
```

- [ ] **Step 3: 检查语法和配置加载**

Run: `nvim --headless "+lua require('config.lazy')" +qa`

Expected: 进程退出码为 `0`，没有 Lua 配置错误。

- [ ] **Step 4: 检查补丁范围**

Run: `git diff --check -- nvim/lua/plugins/snack.lua`

Expected: 进程退出码为 `0`，没有空白错误。

Run: `git diff -- nvim/lua/plugins/snack.lua`

Expected: 仅包含 `follow_file = false`、对应中文注释和 `<leader>fe` 快捷键。

- [ ] **Step 5: 提交配置**

```bash
git add nvim/lua/plugins/snack.lua docs/superpowers/plans/2026-07-12-snacks-explorer-manual-reveal.md
git commit -m "feat(nvim): add manual explorer reveal"
```
