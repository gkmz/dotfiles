# Neovim Window Separator Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 提高 Neovim 水平和垂直 split 分隔线的辨识度，同时保持 TokyoNight Storm 主题的克制视觉风格。

**Architecture:** 在 TokyoNight 的主题回调中设置 `WinSeparator` 和 `VertSplit` 高亮，确保颜色随主题加载稳定应用；在全局选项中明确设置 split 的 `fillchars`，确保终端渲染连续边界。新增一个 headless Neovim 测试检查最终高亮和字符配置。

**Tech Stack:** Neovim Lua、LazyVim、TokyoNight

## Global Constraints

- 分隔线使用 TokyoNight 调色板中的中等对比蓝灰色 `blue0`。
- 不修改浮窗边框、bufferline、窗口背景和活动窗口状态。
- 关键配置使用中文注释。
- 不引入新的插件依赖。

---

### Task 1: 增强窗口分隔线

**Files:**
- Modify: `nvim/lua/plugins/colortheme.lua`
- Modify: `nvim/lua/config/options.lua`
- Create: `nvim/tests/window_separators.lua`

**Interfaces:**
- Consumes: TokyoNight `on_highlights(highlights, colors)` 回调和 Neovim `fillchars` 选项。
- Produces: `WinSeparator`、`VertSplit` 高亮以及连续的水平、垂直和交叉分隔字符。

- [ ] **Step 1: 编写失败测试**

创建 `nvim/tests/window_separators.lua`：

```lua
local ok, err = xpcall(function()
  vim.cmd.colorscheme("tokyonight-storm")

  local win_separator = vim.api.nvim_get_hl(0, { name = "WinSeparator", link = false })
  local vert_split = vim.api.nvim_get_hl(0, { name = "VertSplit", link = false })
  assert(win_separator.fg ~= nil, "WinSeparator foreground is missing")
  assert(win_separator.fg == vert_split.fg, "Split highlight colors are inconsistent")

  local fillchars = vim.opt.fillchars:get()
  assert(fillchars.vert == "│", "Vertical split character is not configured")
  assert(fillchars.horiz == "─", "Horizontal split character is not configured")
  assert(fillchars.verthoriz == "┼", "Split intersection character is not configured")
end, debug.traceback)

if not ok then
  print(err)
  vim.cmd("cquit 1")
end

print("OK: window separators are visually configured")
vim.cmd("qa!")
```

- [ ] **Step 2: 运行测试并确认失败**

Run:

```bash
nvim --headless -u ~/.config/nvim/init.lua -l ~/.config/nvim/tests/window_separators.lua
```

Expected: FAIL，提示某个 split 字符或分隔线高亮尚未配置。

- [ ] **Step 3: 设置 TokyoNight 分隔线高亮**

在 `nvim/lua/plugins/colortheme.lua` 的 TokyoNight `opts` 中增加：

```lua
on_highlights = function(highlights, colors)
  -- 使用中等对比蓝灰色区分 split 窗口，同时避免分隔线抢夺代码焦点。
  highlights.WinSeparator = { fg = colors.blue0 }
  highlights.VertSplit = { fg = colors.blue0 }
end,
```

- [ ] **Step 4: 设置连续分隔字符**

在 `nvim/lua/config/options.lua` 中增加：

```lua
-- 明确设置 split 的直线和连接字符，避免终端默认字符导致窗口边界断裂或过淡。
vim.opt.fillchars:append({
  vert = "│",
  horiz = "─",
  horizup = "┴",
  horizdown = "┬",
  vertleft = "┤",
  vertright = "├",
  verthoriz = "┼",
})
```

- [ ] **Step 5: 运行针对性测试**

Run:

```bash
nvim --headless -u ~/.config/nvim/init.lua -l ~/.config/nvim/tests/window_separators.lua
```

Expected: `OK: window separators are visually configured`，退出码为 0。

- [ ] **Step 6: 运行回归检查**

Run:

```bash
luac -p nvim/lua/plugins/colortheme.lua nvim/lua/config/options.lua nvim/tests/window_separators.lua
git diff --check
```

Expected: 两条命令均无错误并以退出码 0 结束。

- [ ] **Step 7: 提交改动**

```bash
git add nvim/lua/plugins/colortheme.lua nvim/lua/config/options.lua nvim/tests/window_separators.lua docs/superpowers/plans/2026-08-29-nvim-window-separator.md
git commit -m "feat(nvim): clarify split window separators"
```
