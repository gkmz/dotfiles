# Neovim Stable Terminal Layout Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 保持右侧主终端整列高度，并将底部临时终端及其左右分屏限制在左侧编辑区。

**Architecture:** 终端模块维护一个左侧编辑窗口锚点。右侧终端从该锚点垂直分裂并设置高度固定；底部终端始终以锚点为目标进行水平分裂，后续 bottom 终端只在左侧分支内部继续分裂。窗口关闭或失效时通过当前非 terminal 窗口重新发现锚点。

**Tech Stack:** Neovim Lua、内置 window API、`termopen`

## Global Constraints

- 顶层布局固定为“左侧编辑区 | 右侧主终端”。
- 底部临时终端及其后续左右分屏不得改变右侧主终端高度。
- 不改变终端命令、编号语义、Codex/Claude 入口和普通编辑器快捷键。
- 关键代码使用中文注释，公开方法保留文档注释。
- 文件浏览器使用 Snacks Explorer 左侧浮动布局，宽度固定为 28 列，不参与 split 窗口树。

---

### Task 1: 稳定终端布局树

**Files:**
- Modify: `nvim/lua/utils/terminal.lua`
- Create: `nvim/tests/terminal_layout.lua`

**Interfaces:**
- Consumes: `M.toggle(group_name, id)` 和现有 `groups` 终端状态。
- Produces: 左侧编辑锚点、固定高度的右侧终端，以及限定在左侧分支的 bottom split。

- [ ] **Step 1: 编写失败测试**

创建测试，打开右侧终端、记录高度，再打开 bottom 1 和 bottom 2，断言右侧高度不变且其他 terminal 窗口都位于右侧终端左边：

```lua
local ok, err = xpcall(function()
  local terminal = require("utils.terminal")
  terminal.toggle("right", 1)
  vim.wait(100)
  local right_win = vim.api.nvim_get_current_win()
  local right_height = vim.api.nvim_win_get_height(right_win)
  terminal.toggle("bottom", 1)
  vim.wait(100)
  terminal.toggle("bottom", 2)
  vim.wait(100)
  assert(vim.api.nvim_win_is_valid(right_win), "Right terminal window was lost")
  assert(vim.api.nvim_win_get_height(right_win) == right_height, "Right terminal height changed")
  local right_col = vim.api.nvim_win_get_position(right_win)[2]
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if win ~= right_win and vim.bo[vim.api.nvim_win_get_buf(win)].buftype == "terminal" then
      assert(vim.api.nvim_win_get_position(win)[2] < right_col, "Bottom terminal escaped into right column")
    end
  end
end, debug.traceback)
if not ok then
  print(err)
  vim.cmd("cquit 1")
end
print("OK: terminal layout keeps right column stable")
vim.cmd("qa!")
```

- [ ] **Step 2: 运行测试并确认失败**

```bash
nvim --headless -u ~/.config/nvim/init.lua -l ~/.config/nvim/tests/terminal_layout.lua
```

Expected: FAIL，右侧终端高度变化或 bottom 终端进入右侧列。

- [ ] **Step 3: 增加编辑窗口锚点**

在 `terminal.lua` 增加 `layout.editor_win`，并实现 `find_editor_window()`：优先复用有效的非 terminal 锚点，否则遍历 `vim.api.nvim_list_wins()` 找到第一个非 terminal 窗口并保存。

- [ ] **Step 4: 固定右侧主终端**

修改 `open_right_window`：从编辑锚点执行 `botright vsplit`，创建右侧终端后设置 `vim.wo.winfixheight = true`，保存编辑锚点引用。

- [ ] **Step 5: 限定 bottom 分支**

修改 `open_bottom_window`：bottom 1 始终切回编辑锚点后执行 `belowright split`；bottom 2 及之后继续在 bottom group 的 `root_win` 执行 `rightbelow vsplit`，不对右侧终端执行 split。

- [ ] **Step 6: 运行测试确认通过**

```bash
nvim --headless -u ~/.config/nvim/init.lua -l ~/.config/nvim/tests/terminal_layout.lua
```

Expected: `OK: terminal layout keeps right column stable`，退出码为 0。

- [ ] **Step 7: 运行回归检查并提交**

```bash
luac -p nvim/lua/utils/terminal.lua nvim/tests/terminal_layout.lua
git diff --check
nvim --headless -u ~/.config/nvim/init.lua -l ~/.config/nvim/tests/terminal_display.lua
git add nvim/lua/utils/terminal.lua nvim/tests/terminal_layout.lua docs/superpowers/plans/2026-08-30-nvim-terminal-layout.md
git commit -m "fix(nvim): isolate bottom terminals from right column"
```

### Task 2: 将文件浏览器改为左侧浮动窗口

**Files:**
- Modify: `nvim/lua/plugins/snack.lua`
- Create: `nvim/tests/explorer_layout.lua`

**Interfaces:**
- Consumes: Snacks picker explorer source 的 `layout` 配置。
- Produces: 左侧浮动、宽度 28 列且不改变 Neovim split 尺寸的 Explorer。

- [ ] **Step 1: 编写失败测试并确认 Explorer 当前不是浮动布局**

测试读取 Lazy 配置中 explorer source 的布局，断言位置不是 sidebar 且宽度为 28；修改前应失败。

- [ ] **Step 2: 设置左侧浮动 Explorer**

在 `picker.sources.explorer` 中将布局改为 `position = "float"`，宽度设置为 28，左侧偏移为 1，并保留现有 Explorer 行为和快捷键。

- [ ] **Step 3: 运行 Explorer 测试和终端布局回归**

```bash
nvim --headless -u ~/.config/nvim/init.lua -l ~/.config/nvim/tests/explorer_layout.lua
nvim --headless -u ~/.config/nvim/init.lua -l ~/.config/nvim/tests/terminal_layout.lua
```

Expected: 两项测试均退出码为 0。

- [ ] **Step 4: 提交完整改动**

```bash
git add nvim/lua/utils/terminal.lua nvim/lua/plugins/snack.lua nvim/tests/terminal_layout.lua nvim/tests/explorer_layout.lua docs/superpowers/plans/2026-08-30-nvim-terminal-layout.md
git commit -m "fix(nvim): isolate terminal and explorer layouts"
```
