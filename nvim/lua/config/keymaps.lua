-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local status, wk = pcall(require, "which-key")
if not status then
  -- which-key 仅用于快捷键提示；不可用时仍继续注册核心映射。
  wk = {
    add = function() end,
  }
end

-------------------------------------------------------------------------------
-- Common Keymaps
-------------------------------------------------------------------------------
-- simplify quit keymap
vim.keymap.set({ "n" }, "<leader>qc", "<Cmd>:q<CR>")

-- go to head/tail of a line
vim.keymap.set({ "n", "v" }, "gh", "^", { remap = true })
vim.keymap.set({ "n", "v" }, "gl", "$", { remap = true })

-- fast comment
vim.keymap.set({ "n", "v" }, "<M-/>", "gcc<CR>", { remap = true })

-- IDEA convenient key mapping
vim.keymap.set({ "n" }, "<M-d>", "yyp", { remap = true, desc = "Duplicate Current Line" })
vim.keymap.set({ "n" }, "<M-x>", "dd", { remap = true, desc = "Delete Current Line" })

-------------------------------------------------------------------------------
-- Window Keymaps
-------------------------------------------------------------------------------
local window = require("utils.window")

vim.keymap.set({ "n", "t" }, "<A-0>", function()
  window.toggle_current_window_fullscreen()
end, { desc = "Toggle Current Window Fullscreen" })

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

-------------------------------------------------------------------------------
-- Buffer Keymaps
-------------------------------------------------------------------------------
wk.add({
  { "<leader>bs", "<Cmd>:BufferLinePick<CR>", desc = "Pick Buffer" },
})

-------------------------------------------------------------------------------
-- Run Keymaps
-------------------------------------------------------------------------------
local runner = require("utils.runner")

wk.add({
  {
    "<leader>rr",
    function()
      runner.run_file()
    end,
    desc = "Run current file",
  },
  {
    "<leader>rp",
    function()
      runner.run_project()
    end,
    desc = "Run project",
  },
  {
    "<leader>rq",
    function()
      runner.close()
    end,
    desc = "Close runner",
  },
})

-------------------------------------------------------------------------------
-- Terminal Keymaps
-------------------------------------------------------------------------------
-- <C-`> / <A-1> : 切换底部 1 号终端
-- <A-2>         : 切换底部 2 号终端，出现在底部区域右侧
-- <A-f>         : 切换浮动终端
-- <A-v>         : 切换右侧 1 号终端
-- <leader>Tb1-4 : 切换底部终端 1-4，后续编号向右追加
-- <leader>Tr1-4 : 切换右侧终端 1-4，后续编号向下追加
-- <leader>Tc    : 打开 Codex CLI 浮动终端
-- <leader>Tl    : 打开 Claude CLI 浮动终端
-- <leader>Tmx   : 将当前终端标记为 Codex CLI
-- <leader>Tma   : 将当前终端标记为 Claude CLI
-- ga             : 将当前文件或选区作为结构化上下文添加到 Agentic
-- gC             : 将选中内容发送到已打开的 Claude CLI
-- <leader>Th    : 隐藏全部终端，但保留 shell 进程
-- <leader>Tq    : 关闭全部终端

local terminal = require("utils.terminal")

-- 终端模式下裸 Esc 默认会传给 shell；这里显式回到 Neovim 的 terminal-normal 状态。
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { desc = "Exit Terminal Input Mode" })

-- AI 终端中直接用 Ctrl+h/j/k/l 跳转窗口；普通终端保留原控制字符。
for _, direction in ipairs({ "h", "j", "k", "l" }) do
  vim.keymap.set("t", "<C-" .. direction .. ">", function()
    return terminal.navigate_from_ai_agent_terminal(direction)
  end, { expr = true, desc = "Navigate Window from AI Terminal" })
end

-- 主终端：Ctrl+` 切换底部 1 号终端
vim.keymap.set({ "n", "i", "t" }, "<C-`>", function()
  terminal.toggle("bottom", 1)
end, { desc = "Toggle Bottom Terminal 1" })
vim.keymap.set({ "n", "i", "t" }, "<A-1>", function()
  terminal.toggle("bottom", 1)
end, { desc = "Toggle Bottom Terminal 1" })
vim.keymap.set({ "n", "i", "t" }, "<A-2>", function()
  terminal.toggle("bottom", 2)
end, { desc = "Toggle Bottom Terminal 2" })

-- 浮动终端：浮窗独立于底部和右侧终端编号
vim.keymap.set({ "n", "i", "t" }, "<leader>Tf", function()
  terminal.toggle("float", 1)
end, { desc = "Toggle Float Terminal" })
vim.keymap.set({ "n", "i", "t" }, "<A-f>", function()
  terminal.toggle("float", 1)
end, { desc = "Toggle Float Terminal" })

-- 右侧终端：1 号打开右栏，后续编号在右栏下方追加
vim.keymap.set({ "n", "i", "t" }, "<leader>Tv", function()
  terminal.toggle("right", 1)
end, { desc = "Toggle Right Terminal 1" })
vim.keymap.set({ "n", "i", "t" }, "<A-v>", function()
  terminal.toggle("right", 1)
end, { desc = "Toggle Right Terminal 1" })

-- 快速切换底部 / 右侧终端 1-4
for i = 1, 4 do
  vim.keymap.set({ "n", "i", "t" }, "<leader>Tb" .. i, function()
    terminal.toggle("bottom", i)
  end, { desc = "Toggle Bottom Terminal " .. i })
  vim.keymap.set({ "n", "i", "t" }, "<leader>Tr" .. i, function()
    terminal.toggle("right", i)
  end, { desc = "Toggle Right Terminal " .. i })
end

wk.add({
  {
    "<leader>Tc",
    function()
      terminal.open_ai_agent("codex")
    end,
    desc = "Open Codex CLI",
  },
  {
    "<leader>Tl",
    function()
      terminal.open_ai_agent("claude")
    end,
    desc = "Open Claude CLI",
  },
  {
    "<leader>Tmx",
    function()
      terminal.mark_current_terminal_as_ai_agent("codex")
    end,
    mode = { "n", "t" },
    desc = "Mark Current Terminal as Codex CLI",
  },
  {
    "<leader>Tma",
    function()
      terminal.mark_current_terminal_as_ai_agent("claude")
    end,
    mode = { "n", "t" },
    desc = "Mark Current Terminal as Claude CLI",
  },
  {
    "gC",
    function()
      terminal.send_visual_selection_to_ai_agent("claude")
    end,
    mode = "v",
    desc = "Send Selection to Claude CLI",
  },
  {
    "<leader>Th",
    function()
      terminal.hide_all_terminals()
    end,
    desc = "Hide All Terminals",
  },
  {
    "<leader>Tq",
    function()
      terminal.close_all_terminals()
    end,
    desc = "Close All Terminals",
  },
})

-------------------------------------------------------------------------------
-- Zen Mode & Misc
-------------------------------------------------------------------------------
vim.keymap.set({ "n" }, "<leader>uz", "<Cmd>:ZenMode<CR>", { desc = "Zen Mode" })

-- Snacks jump (引用跳转)
vim.keymap.set("n", "]]", function()
  Snacks.words.jump(vim.v.count1)
end, { desc = "Next Reference" })
vim.keymap.set("n", "[[", function()
  Snacks.words.jump(-vim.v.count1)
end, { desc = "Prev Reference" })
