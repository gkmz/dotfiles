-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local status, wk = pcall(require, "which-key")
if not status then
  return
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

-- IDEA convenient key mapping
vim.keymap.set({ "n" }, "<M-d>", "yyp", { remap = true, desc = "Duplicate Current Line" })
vim.keymap.set({ "n" }, "<M-x>", "dd", { remap = true, desc = "Delete Current Line" })

-------------------------------------------------------------------------------
-- Window Keymaps
-------------------------------------------------------------------------------
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
-- Terminal Keymaps (toggleterm.nvim)
-------------------------------------------------------------------------------
-- <C-`>        : 切换底部终端（终端1）
-- <C-`> 2<C-`> : 切换终端2，以此类推（:2ToggleTerm）
-- <leader>tf   : 浮动终端
-- <leader>tv   : 垂直终端
-- <leader>tn   : 新建终端（下一个编号）

local function toggle_term(id, direction)
  local cmd = id and (id .. "ToggleTerm") or "ToggleTerm"
  if direction then
    cmd = cmd .. " direction=" .. direction
  end
  vim.cmd(cmd)
end

-- 主终端：Ctrl+` 切换底部终端
vim.keymap.set({ "n", "i", "t" }, "<C-`>", function() toggle_term(1) end, { desc = "Toggle Terminal 1" })

-- 浮动终端
vim.keymap.set({ "n", "i", "t" }, "<leader>tf", function() toggle_term(nil, "float") end,
  { desc = "Toggle Float Terminal" })

-- 垂直终端
vim.keymap.set({ "n", "i", "t" }, "<leader>tv", function() toggle_term(nil, "vertical") end,
  { desc = "Toggle Vertical Terminal" })

-- 快速切换终端 1-4
for i = 1, 4 do
  vim.keymap.set({ "n" }, "<leader>t" .. i, function() toggle_term(i) end, { desc = "Toggle Terminal " .. i })
end

wk.add({
  { "<leader>tc", function() require("utils.terminal").close_all_terminals() end, desc = "Close All Terminals" },
})

-------------------------------------------------------------------------------
-- Zen Mode & Misc
-------------------------------------------------------------------------------
vim.keymap.set({ "n" }, "<C-z>", "<Cmd>:ZenMode<CR>", { desc = "Zen Mode" })

-- Snacks jump (引用跳转)
vim.keymap.set("n", "]]", function() Snacks.words.jump(vim.v.count1) end, { desc = "Next Reference" })
vim.keymap.set("n", "[[", function() Snacks.words.jump(-vim.v.count1) end, { desc = "Prev Reference" })
