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
-- Terminal Keymaps
-------------------------------------------------------------------------------
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

vim.keymap.set({ "n", "i", "t", "v" }, ctrl_alt_slash, split_term_cmd, { desc = "Toggle Terminal" })
vim.keymap.set({ "n", "i", "t", "v" }, ctrl_alt_underscore, split_term_cmd, { desc = "Toggle Terminal" })
vim.keymap.set({ "n", "i", "t", "v" }, ctrl_slash, floating_term_cmd, { desc = "Toggle Floating Terminal" })
vim.keymap.set({ "n", "i", "t", "v" }, alt_underscore, floating_term_cmd, { desc = "Toggle Floating Terminal" })

-------------------------------------------------------------------------------
-- Zen Mode & Misc
-------------------------------------------------------------------------------
vim.keymap.set({ "n" }, "<C-z>", "<Cmd>:ZenMode<CR>", { desc = "Zen Mode" })
