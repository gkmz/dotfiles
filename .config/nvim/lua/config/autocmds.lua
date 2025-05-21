-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

local function augroup(name)
  return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end

-- not work???
-- vim.api.nvim_create_autocmd("User", {
--   group = augroup("nvim_started"),
--   pattern = "LazyDone",
--   callback = function()
--     vim.notify("User LazyDone triggered from autocomds.lua")
--   end,
-- })
-- vim.api.nvim_create_autocmd("UIEnter", {
--   group = augroup("nvim_started"),
--   callback = function()
--     vim.notify("UIEnter triggered from autocomds.lua")
--   end,
-- })

-- config custom dap in project .nvim/dap.lua file
-- TODO: not work???
-- vim.api.nvim_create_autocmd("VimEnter", {
--   pattern = "*",
--   callback = function()
--     local dap_config = vim.fn.getcwd() .. "/.nvim/dap.lua"
--     -- vim.notify("dap_config:" .. dap_config)
--     if vim.fn.filereadable(dap_config) == 1 then
--       local custom_dap = dofile(dap_config)
--       print(custom_dap)
--       local dap = require("dap")
--       -- dap.adapters.go = {
--       -- 	type = "executable",
--       -- 	command = "dlv",
--       -- 	args = { "dap", "-l", "127.0.0.1:38697" },
--       -- }
--       dap.configurations.go = vim.tbl_deep_extend("force", dap.configurations.go, custom_dap)
--
--       vim.notify("Loaded DAP config from .nvim/dap.lua")
--     end
--   end,
-- })
