# Neovim Active Buffer Highlight Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Give the active buffer in bufferline a clearly distinguishable TokyoNight background while preserving the current transparent theme.

**Architecture:** Add one focused Lazy plugin override for `bufferline.nvim`. Read colors from TokyoNight's active palette and override only selected-buffer highlights; bufferline derives the selected file-icon background from `buffer_selected` automatically.

**Tech Stack:** Neovim, Lua, lazy.nvim, bufferline.nvim, tokyonight.nvim

## Global Constraints

- Use TokyoNight `bg_highlight` for the active buffer background and `fg` for its title.
- Keep non-active buffer highlights and all bufferline behavior unchanged.
- Keep the active title bold and use one continuous background across the title, icon, close button, and separators.
- Add a clear Chinese comment for the key highlight configuration.

---

### Task 1: Add the active buffer highlight override

**Files:**
- Create: `nvim/lua/plugins/bufferline.lua`

**Interfaces:**
- Consumes: `require("tokyonight.colors").setup()` returning the current TokyoNight palette.
- Produces: Lazy plugin spec for `akinsho/bufferline.nvim` whose `opts.highlights` configures selected-buffer highlight groups.

- [ ] **Step 1: Record the failing configuration-presence check**

Run:

```bash
test -f nvim/lua/plugins/bufferline.lua
```

Expected: exit code 1 because the focused override does not exist yet.

- [ ] **Step 2: Create the focused bufferline plugin override**

Create `nvim/lua/plugins/bufferline.lua`:

```lua
return {
  {
    "akinsho/bufferline.nvim",
    opts = function(_, opts)
      local colors = require("tokyonight.colors").setup()

      -- 激活项使用连续的主题背景色，避免透明 tabline 中的当前 buffer 难以辨认。
      opts.highlights = vim.tbl_deep_extend("force", opts.highlights or {}, {
        buffer_selected = {
          fg = colors.fg,
          bg = colors.bg_highlight,
          bold = true,
          italic = false,
        },
        close_button_selected = {
          fg = colors.fg,
          bg = colors.bg_highlight,
        },
        separator_selected = { bg = colors.bg_highlight },
        indicator_selected = { bg = colors.bg_highlight },
        modified_selected = { bg = colors.bg_highlight },
        duplicate_selected = { bg = colors.bg_highlight },
      })
    end,
  },
}
```

- [ ] **Step 3: Verify the Lua file parses**

Run `luac -p nvim/lua/plugins/bufferline.lua`.

Expected: exit code 0 with no output.

- [ ] **Step 4: Verify Neovim loads the override and resolves selected highlights**

Run:

```bash
nvim --headless "+lua require('lazy').load({ plugins = { 'bufferline.nvim' } })" "+lua local c=require('tokyonight.colors').setup(); local b=vim.api.nvim_get_hl(0,{name='BufferLineBufferSelected'}); local x=vim.api.nvim_get_hl(0,{name='BufferLineCloseButtonSelected'}); assert(b.bg==tonumber(c.bg_highlight:sub(2),16)); assert(b.fg==tonumber(c.fg:sub(2),16)); assert(b.bold==true); assert(x.bg==b.bg)" +qa
```

Expected: exit code 0 with no assertion errors.

- [ ] **Step 5: Check formatting and worktree scope**

Run `stylua --check nvim/lua/plugins/bufferline.lua`, `git diff --check -- nvim/lua/plugins/bufferline.lua`, and `git status --short`.

Expected: both checks exit 0; status shows only the new bufferline file from this implementation plus pre-existing user changes.

- [ ] **Step 6: Commit the implementation**

Run:

```bash
git add nvim/lua/plugins/bufferline.lua
git commit -m "feat(nvim): highlight active buffer"
```

Expected: the commit contains only `nvim/lua/plugins/bufferline.lua`.
