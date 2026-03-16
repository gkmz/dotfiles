-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-------------------------------------------------------------------------------
-- Indentation Settings
-------------------------------------------------------------------------------
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "go", "gomod", "gowork", "gotmpl" },
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.colorcolumn = "120"
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "proto" },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab = false
    vim.opt_local.colorcolumn = "120"
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "md" },
  callback = function()
    vim.opt.textwidth = 80
    vim.opt.formatoptions:append("t")
  end,
})

-------------------------------------------------------------------------------
-- Project Specific DAP Config
-------------------------------------------------------------------------------
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local status, utils = pcall(require, "utils.vscode")
    if status and utils.is_in_vscode() then
      return
    end

    local dap_config = vim.fn.getcwd() .. "/.nvim/dap.lua"
    if vim.fn.filereadable(dap_config) == 1 then
      local custom_dap = dofile(dap_config)
      local ok, dap = pcall(require, "dap")
      if ok then
        dap.configurations.go = vim.tbl_deep_extend("force", dap.configurations.go or {}, custom_dap)
        vim.notify("Loaded DAP config from .nvim/dap.lua")
      end
    end
  end,
})
