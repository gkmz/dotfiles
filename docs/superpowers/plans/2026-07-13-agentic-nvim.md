# Agentic.nvim Integration Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the unused CodeCompanion integration with Agentic.nvim backed by the existing `codex-acp`, while keeping the native Codex and Claude Code terminal workflows.

**Architecture:** A focused Lazy plugin spec owns Agentic configuration and public keymaps. Existing terminal utilities keep CLI-only behavior after their CodeCompanion fallback is removed. Lazy's lock file records Agentic after synchronization without disturbing unrelated dependency updates already present in the worktree.

**Tech Stack:** Neovim 0.11+, Lua, lazy.nvim, Agent Client Protocol, `carlos-algms/agentic.nvim`, `@zed-industries/codex-acp`

## Global Constraints

- Preserve all existing Codex and Claude Code terminal behavior and user-authored uncommitted changes.
- Use `codex-acp` as the only configured Agentic provider in this change.
- Keep key implementation comments and public Lua functions documented in Chinese.
- Do not migrate CodeCompanion HTTP providers, prompts, or inline-edit behavior.
- Do not install provider binaries automatically; use the existing executable on `PATH`.

---

### Task 1: Remove CodeCompanion ownership

**Files:**
- Delete: `nvim/lua/plugins/codecompanion.lua`
- Modify: `nvim/lua/utils/terminal.lua`
- Modify: `nvim/lua/config/keymaps.lua`
- Modify: `nvim/lazy-lock.json`

**Interfaces:**
- Consumes: existing `M.send_visual_selection_to_ai_agent(command, opts)` for CLI-only explicit sending.
- Produces: terminal utilities with no CodeCompanion detection or command invocation.

- [ ] **Step 1: Record the failing removal check**

Run:

```bash
rg -n "CodeCompanion|codecompanion" nvim/lua nvim/lazy-lock.json
```

Expected: matches in the plugin config, terminal fallback, keymap comments, and lock file.

- [ ] **Step 2: Delete the CodeCompanion plugin spec**

Delete `nvim/lua/plugins/codecompanion.lua` in full because every function in that file exists only to configure CodeCompanion.

- [ ] **Step 3: Remove the terminal fallback without changing CLI behavior**

Delete `has_visible_codecompanion_chat()` and remove this branch from `M.send_visual_selection_to_open_ai_agent`:

```lua
if has_visible_codecompanion_chat() then
  vim.cmd("'<,'>CodeCompanionChat Add")
  vim.notify("已发送选中内容到 CodeCompanion。", vim.log.levels.INFO)
  return
end
```

Change its documentation and final warning to mention only Codex and Claude CLI terminals. Keep `send_visual_selection_to_ai_agent`, terminal discovery, bracketed paste, and AI terminal navigation unchanged.

- [ ] **Step 4: Clean global comments and the lock entry**

Change keymap comments from `Codex/Claude/CodeCompanion` to `Codex/Claude CLI`, remove the obsolete plugin-overwrite explanation, and delete only the `"codecompanion.nvim"` entry from `nvim/lazy-lock.json`.

- [ ] **Step 5: Verify complete removal**

Run:

```bash
rg -n "CodeCompanion|codecompanion" nvim/lua nvim/lazy-lock.json
```

Expected: exit code 1 with no matches.

### Task 2: Add the Codex ACP Agentic client

**Files:**
- Create: `nvim/lua/plugins/agentic.lua`

**Interfaces:**
- Consumes: public Agentic functions `toggle`, `add_selection_or_file_to_context`, `add_buffer_diagnostics`, `new_session`, and `restore_session`.
- Produces: Lazy spec for `carlos-algms/agentic.nvim` with provider `codex-acp` and the `<leader>a`/`ga` mappings.

- [ ] **Step 1: Record the failing plugin-presence check**

Run:

```bash
test -f nvim/lua/plugins/agentic.lua
```

Expected: exit code 1 because the plugin spec does not exist.

- [ ] **Step 2: Create the focused Agentic plugin spec**

Create `nvim/lua/plugins/agentic.lua` with this behavior:

```lua
return {
  {
    "carlos-algms/agentic.nvim",
    opts = {
      provider = "codex-acp",
      windows = {
        position = "right",
        width = "40%",
      },
      diff_preview = {
        enabled = true,
        layout = "split",
      },
    },
    keys = {
      {
        "<leader>aa",
        function()
          require("agentic").toggle()
        end,
        mode = { "n", "v", "i" },
        desc = "Toggle Agentic Chat",
      },
      {
        "ga",
        function()
          require("agentic").add_selection_or_file_to_context()
        end,
        mode = { "n", "v" },
        desc = "Add File or Selection to Agentic",
      },
      {
        "<leader>ad",
        function()
          require("agentic").add_buffer_diagnostics()
        end,
        desc = "Add Buffer Diagnostics to Agentic",
      },
      {
        "<leader>an",
        function()
          require("agentic").new_session()
        end,
        mode = { "n", "v", "i" },
        desc = "New Agentic Session",
      },
      {
        "<leader>ar",
        function()
          require("agentic").restore_session()
        end,
        mode = { "n", "v", "i" },
        desc = "Restore Agentic Session",
      },
    },
  },
}
```

Add short Chinese comments before the provider and keymap sections to explain the non-obvious ownership boundary.

- [ ] **Step 3: Remove the old global `ga` mapping**

Delete the global visual `ga` mapping from `nvim/lua/config/keymaps.lua`; Lazy must own both normal and visual `ga` so the Agentic module is loaded before the public function is called.

- [ ] **Step 4: Verify the spec parses**

Run:

```bash
luac -p nvim/lua/plugins/agentic.lua
```

Expected: exit code 0 with no output.

### Task 3: Synchronize and verify the integration

**Files:**
- Modify: `nvim/lazy-lock.json`

**Interfaces:**
- Consumes: Lazy plugin spec from Task 2 and `codex-acp` on `PATH`.
- Produces: installed Agentic plugin, updated lock entry, and verified Neovim mappings.

- [ ] **Step 1: Verify environment prerequisites**

Run:

```bash
nvim --version | head -n 1
command -v codex-acp
codex-acp --version
```

Expected: Neovim 0.11 or newer, an executable path, and a successful version response.

- [ ] **Step 2: Synchronize Lazy plugins**

Run:

```bash
nvim --headless "+Lazy! sync" +qa
```

Expected: Agentic installs successfully, CodeCompanion is removed, and the process exits 0.

- [ ] **Step 3: Run the headless configuration checks**

Run:

```bash
nvim --headless "+lua assert(require('lazy.core.config').plugins['agentic.nvim'])" "+lua assert(not require('lazy.core.config').plugins['codecompanion.nvim'])" "+lua assert(vim.fn.maparg('ga', 'n') ~= '')" "+lua assert(vim.fn.maparg('ga', 'x') ~= '')" +qa
```

Expected: exit code 0 with no assertion errors.

- [ ] **Step 4: Run health and regression checks**

Run:

```bash
nvim --headless "+checkhealth agentic" +qa
git diff --check
rg -n "CodeCompanion|codecompanion" nvim/lua nvim/lazy-lock.json
```

Expected: Agentic reports Neovim and `codex-acp` available; `git diff --check` exits 0; the final `rg` exits 1 with no matches.

- [ ] **Step 5: Review the final worktree**

Run:

```bash
git status --short
git diff -- nvim/lua/plugins/agentic.lua nvim/lua/plugins/codecompanion.lua nvim/lua/config/keymaps.lua nvim/lua/utils/terminal.lua nvim/lazy-lock.json
```

Expected: only the requested Agentic migration appears in these paths, while unrelated pre-existing user changes remain untouched.
