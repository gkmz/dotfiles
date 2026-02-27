-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local M = {}
local status, wk = pcall(require, "which-key")
if not status then
  return
end

function M.setup_keymaps()
  M.setup_common_keymaps()
  M.setup_window_keymaps()
  M.setup_buffer_keymaps()
  M.setup_dap_keymaps()
end

function M.setup_dap_keymaps()
  -- dap keymapping to Jetbrains
  local ok, dap = pcall(require, "dap")
  if not ok then
    return
  end
  vim.keymap.set("n", "<F8>", function()
    dap.step_over()
  end)
  vim.keymap.set("n", "<F7>", function()
    dap.step_into()
  end)
  vim.keymap.set("n", "<F9>", function()
    dap.step_out()
  end)
  vim.keymap.set("n", "<F10>", function()
    dap.continue()
  end)
end

function M.setup_common_keymaps()
  -- vim.keymap.set({ "n", "v", "i" }, ";", "<Cmd>Esc<CR>")
  -- simplify quit keymap
  vim.keymap.set({ "n" }, "<leader>qc", "<Cmd>:q<CR>")
  -- intend or unintend fastly
  -- vim.keymap.set("n", "<S-Tab>", "<Cmd><<CR>")
  -- vim.keymap.set("n", "<Tab>", "<Cmd>><CR>")
  -- go to head/tail of a line
  vim.keymap.set({ "n", "v" }, "gj", "j", { remap = true })
  vim.keymap.set({ "n", "v" }, "gk", "k", { remap = true })
  vim.keymap.set({ "n", "v" }, "gh", "^", { remap = true })
  vim.keymap.set({ "n", "v" }, "gl", "$", { remap = true })
  -- fast comment
  vim.keymap.set({ "n", "v" }, "<M-/>", "gcc<CR>", { remap = true })
  wk.add({
    {
      "<leader>Nn",
      "<cmd>:Neotree reveal<CR>:set relativenumber<CR>",
      desc = "NeoTree Show Number",
      silent = true,
    },
    {
      "<leader>Nc",
      "<cmd>:Neotree reveal<CR>:set relativenumber 0<CR>",
      desc = "NeoTree Hide Number",
      silent = true,
    },
  })

  -- IDEA convilent key mapping
  vim.keymap.set({ "n" }, "<M-d>", "yyp", { remap = true, desc = "Duplicate Current Line" })
  vim.keymap.set({ "n" }, "<M-x>", "dd", { remap = true, desc = "Delete Current Line" })
end

function M.setup_dashboard_keymaps()
  -- fast show dashboard
  vim.keymap.set({ "n" }, "<leader>;", "<cmd>Dashboard<CR>")
end

function M.setup_zen_keymaps()
  -- zen mode
  vim.keymap.set({ "n" }, "<C-z>", "<Cmd>:ZenMode<CR>")
end

function M.setup_rest_keymaps()
  -- rest http
  wk.add({
    { "<leader>h", group = "Http", icon = "󰌷" },
    { "<leader>he", "<cmd>lua require('telescope').extensions.rest.select_env()<CR>", desc = "Select env file" },
    { "<leader>hr", "<cmd>Rest run<cr>", desc = "Run request under the cursor" },
    { "<leader>hl", "<cmd>Rest run last<cr>", desc = "Re-run latest request" },
  })
end

function M.setup_go_keymaps()
  wk.add({
    { "<leader>G", group = "Go", icon = "" },
    { "<leader>Gd", "<cmd>lua require('dap-go').debug_test()<cr>", desc = "Debug Test" },
    { "<leader>Gi", "<cmd>GoInstallDeps<Cr>", desc = "Install Go Dependencies" },
    { "<leader>Gt", "<cmd>GoMod tidy<cr>", desc = "Tidy" },
    { "<leader>Ga", "<cmd>GoTestAdd<Cr>", desc = "Add Test" },
    { "<leader>GA", "<cmd>GoTestsAll<Cr>", desc = "Add All Tests" },
    { "<leader>Ge", "<cmd>GoTestsExp<Cr>", desc = "Add Exported Tests" },
    { "<leader>Gg", "<cmd>GoGenerate<Cr>", desc = "Go Generate" },
    { "<leader>GG", "<cmd>GoGenerate %<Cr>", desc = "Go Generate File" },
    { "<leader>Gc", "<cmd>GoCmt<Cr>", desc = "Generate Comment" },
    { "<leader>GI", "<cmd>GoImpl<Cr>", desc = "Implements Interface" },
  })
end

-- select window
function M.setup_window_keymaps()
  -- wk.add({ { "<leader>ws", "<Cmd>lua require('nvim-window').pick()<CR>", desc = "select window" } })
  -- Resize window fastly
  vim.keymap.set({ "n" }, "<M-up>", ":res -5<cr>")
  vim.keymap.set({ "n" }, "<M-down>", ":res +5<cr>")
  vim.keymap.set({ "n" }, "<M-left>", ":vertical resize+10<cr>")
  vim.keymap.set({ "n" }, "<M-right>", ":vertical resize-10<cr>")
  vim.keymap.set({ "n" }, "<M-J>", ":res -5<cr>")
  vim.keymap.set({ "n" }, "<M-K>", ":res +5<cr>")
  vim.keymap.set({ "n" }, "<M-H>", ":vertical resize+10<cr>")
  vim.keymap.set({ "n" }, "<M-L>", ":vertical resize-10<cr>")
  -- Go to window fastly
  vim.keymap.set({ "n" }, "<leader><up>", "<C-w>k")
  vim.keymap.set({ "n" }, "<leader><down>", "<C-w>j")
  vim.keymap.set({ "n" }, "<leader><left>", "<C-w>h")
  vim.keymap.set({ "n" }, "<leader><right>", "<C-w>l")
end

function M.setup_buffer_keymaps()
  -- select buffer
  wk.add({
    { "<leader>bs", "<Cmd>:BufferLinePick<CR>", desc = "Pick Buffer" },
  })
end

function M.setup_scissor_keymaps()
  -- scissor manage snippts
  wk.add({
    { "<leader>p", group = "Snippts" },
    { "<leader>pa", ":ScissorsAddNewSnippet<cr>", desc = "Add New Snippt" },
    -- { "<leader>pA", ":'<,'>ScissorsAddNewSnippet<cr>", desc = "Add New Snippt in Visual Mode" },
    { "<leader>pe", ":ScissorsEditSnippet<cr>", desc = "Edit Snippt" },
  })
  vim.keymap.set({ "v" }, "<leader>pA", ":'<,'>ScissorsAddNewSnippet<cr>", { noremap = true })
end

function M.setup_translate_keymaps()
  -- tranlate quickly
  vim.keymap.set("n", "te", ":Translate EN<CR>")
  vim.keymap.set("n", "tz", ":Translate ZH<CR>")
  -- vim.keymap.set("n", "lz", ":'<,'>Translate ZH<CR>")
  vim.keymap.set("n", "tw", "viw:Translate ZH<CR>")
end

function M.setup_markdown_keymaps()
  return {
    {
      "<Leader>uM",
      function()
        local m = require("render-markdown")
        local enabled = require("render-markdown.state").enabled
        if enabled then
          m.disable()
          vim.cmd("setlocal conceallevel=0")
        else
          m.enable()
          vim.cmd("setlocal conceallevel=2")
        end
      end,
      desc = "Toggle markdown render",
    },
  }
end

function M.setup_typescript_lsp_keymaps()
  return {
    {
      "gD",
      function()
        require("vtsls").commands.goto_source_definition(0)
      end,
      desc = "Goto Source Definition",
    },
    {
      "gR",
      function()
        require("vtsls").commands.file_references(0)
      end,
      desc = "File References",
    },
    {
      "<leader>co",
      function()
        require("vtsls").commands.organize_imports(0)
      end,
      desc = "Organize Imports",
    },
    {
      "<leader>cM",
      function()
        require("vtsls").commands.add_missing_imports(0)
      end,
      desc = "Add missing imports",
    },
    {
      "<leader>cu",
      function()
        require("vtsls").commands.remove_unused_imports(0)
      end,
      desc = "Remove unused imports",
    },
    {
      "<leader>cD",
      function()
        require("vtsls").commands.fix_all(0)
      end,
      desc = "Fix all diagnostics",
    },
    {
      "<leader>cV",
      function()
        require("vtsls").commands.select_ts_version(0)
      end,
      desc = "Select TS workspace version",
    },
  }
end

function M.setup_diffview_keymaps()
  local keymaps = {
    -- use [c and [c to navigate diffs (vim built in), see :h jumpto-diffs
    -- use ]x and [x to navigate conflicts
    { "<leader>gd", group = "Git Diff" },
    { "<leader>gdc", ":DiffviewOpen origin/main...HEAD", desc = "Compare commits" },
    { "<leader>gdq", ":DiffviewClose<CR>", desc = "Close Diffview tab" },
    { "<leader>gdh", ":DiffviewFileHistory %<CR>", desc = "File history" },
    { "<leader>gdH", ":DiffviewFileHistory<CR>", desc = "Repo history" },
    { "<leader>gdm", ":DiffviewOpen<CR>", desc = "Solve merge conflicts" },
    { "<leader>gdo", ":DiffviewOpen main", desc = "DiffviewOpen" },
    { "<leader>gdt", ":DiffviewOpen<CR>", desc = "DiffviewOpen this" },
    { "<leader>gdp", ":DiffviewOpen origin/main...HEAD --imply-local", desc = "Review current PR" },
    {
      "<leader>gdP",
      ":DiffviewFileHistory --range=origin/main...HEAD --right-only --no-merges --reverse",
      desc = "Review current PR (per commit)",
    },
  }
  wk.add(keymaps)
  return keymaps
end

function M.setup_terminal_keymaps()
  -- Both <C-/> and <C-_> are mapped due to the way control characters are interpreted by terminal emulators.
  -- ASCII value of '/' is 47, and of '_' is 95. When <C-/> is pressed, the terminal sends (47 - 64) which wraps around to 111 ('o').
  -- When <C-_> is pressed, the terminal sends (95 - 64) which is 31. Hence, both key combinations need to be mapped.

  -- <C-/> toggles the floating terminal
  local ctrl_slash = "<C-/>"
  local alt_underscore = "<A-_>"
  local ctrl_alt_slash = "<C-A-/>"
  local ctrl_alt_underscore = "<C-A-_>"
  local floating_term_cmd = function()
    vim.api.nvim_set_keymap("t", "<Esc><Esc>", "<C-\\><C-n>", { noremap = true })
    require("utils.terminal").toggle_fterm()
  end
  local split_term_cmd = function()
    vim.api.nvim_set_keymap("t", "<Esc><Esc>", "<C-\\><C-n>", { noremap = true })
    require("utils.terminal").toggle_terminal_native()
  end
  vim.keymap.set({ "n", "i", "t", "v" }, ctrl_alt_slash, split_term_cmd, { desc = "Toggle terminal" })
  vim.keymap.set({ "n", "i", "t", "v" }, ctrl_alt_underscore, split_term_cmd, { desc = "Toggle terminal" })

  -- C-A-/ toggles split terminal on/off
  vim.keymap.set({ "n", "i", "t", "v" }, ctrl_slash, floating_term_cmd, { desc = "Toggle native terminal" })
  vim.keymap.set({ "n", "i", "t", "v" }, alt_underscore, floating_term_cmd, { desc = "Toggle native terminal" })
end

function M.setup_minimap_keymaps()
  local keymap = {
    { "<Leader>um", group = "Mini Map" },
    { "<Leader>umt", "<cmd>Neominimap toggle<CR>", desc = "Toggle Mini map" },
    -- { "<leader>ume", "<cmd>Neominimap on<cr>", desc = "Enable minimap" },
    -- { "<leader>umd", "<cmd>Neominimap off<cr>", desc = "Disable minimap" },
    -- { "<leader>umf", "<cmd>Neominimap focus<cr>", desc = "Focus on minimap" },
    -- { "<leader>umu", "<cmd>Neominimap unfocus<cr>", desc = "Unfocus minimap" },
    { "<leader>umf", "<cmd>Neominimap toggleFocus<cr>", desc = "Toggle focus on minimap" },
    { "<leader>umw", "<cmd>Neominimap winToggle<cr>", desc = "Toggle minimap for current window" },
    { "<leader>umr", "<cmd>Neominimap winRefresh<cr>", desc = "Refresh minimap for current window" },
    -- { "<leader>nwo", "<cmd>Neominimap winOn<cr>", desc = "Enable minimap for current window" },
    -- { "<leader>nwc", "<cmd>Neominimap winOff<cr>", desc = "Disable minimap for current window" },
    { "<leader>umb", "<cmd>Neominimap bufToggle<cr>", desc = "Toggle minimap for current buffer" },
    { "<leader>uma", "<cmd>Neominimap bufRefresh<cr>", desc = "Refresh minimap for current buffer" },
    -- { "<leader>nbo", "<cmd>Neominimap bufOn<cr>", desc = "Enable minimap for current buffer" },
    -- { "<leader>nbc", "<cmd>Neominimap bufOff<cr>", desc = "Disable minimap for current buffer" },
  }
  wk.add(keymap)
  return keymap
end

function M.setup_obsidian_keymaps(obsidian_vars)
  local keymap = {
    { "<leader>o", group = "Obsidian" },
    { "<leader>os", "<cmd>ObsidianSearch<cr>", desc = "[N]otes: [s]earch text" },
    { "<leader>of", "<cmd>ObsidianQuickSwitch<cr>", desc = "[N]otes: search [f]ilenames" },
    { "<leader>on", "<cmd>ObsidianNew<cr>", desc = "[N]otes: [n]new" },
    { "<leader>ol", "<cmd>ObsidianQuickSwitch Learning.md<cr><cr>", desc = "[N]otes: [l]earning" },
    { "<leader>og", "<cmd>ObsidianQuickSwitch Go.md<cr><cr>", desc = "[N]otes: [g]olang learning" },
    { "<leader>ov", "<cmd>ObsidianQuickSwitch Neovim config.md<cr><cr>", desc = "[N]otes: Neo[v]im todo" },
    {
      "<leader>oS",
      function()
        local client = require("obsidian").get_client()
        client:open_note(obsidian_vars.scratchpad_path)
      end,
      desc = "[N]otes: [S]cratchpad",
    },
    {
      "<leader>om",
      function()
        local client = require("obsidian").get_client()
        -- client.dir is the vault path
        local note = client:create_note({
          title = "Meeting notes",
          dir = vim.fn.expand(obsidian_vars.notes_path),
          -- NOTE: if folder "templates" exist in $cwd,
          -- the template is expected to be found there.
          template = "meeting_notes",
        })
        client:open_note(note)
      end,
      desc = "[N]otes: new [m]eeting agenda from template",
    },
  }
  wk.add(keymap)
  return keymap
end

function M.setup_code_runner_keymaps()
  local keymap = {
    { "<leader>R", group = "Code Runner" },
    { "<leader>Rc", "<cmd>RunCode<cr>", desc = "Run code" },
    { "<leader>RC", "<cmd>RunCode tab<cr>", desc = "Run code in tab" },
    { "<leader>Rf", "<cmd>RunFile<cr>", desc = "Run file" },
    { "<leader>RF", "<cmd>RunFile tab<cr>", desc = "Run file in tab" },
    { "<leader>Rp", "<cmd>RunProject<cr>", desc = "Run project" },
    { "<leader>Rx", "<cmd>RunClose<cr>", desc = "Run close" },
    { "<leader>Rt", "<cmd>CRFiletype<cr>", desc = "Run file type" },
    { "<leader>Rs", "<cmd>CRProjects<cr>", desc = "Run projects" },
  }
  wk.add(keymap)
  return keymap
end

return M
