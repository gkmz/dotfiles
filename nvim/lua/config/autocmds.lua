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
-- Lightweight Auto Save
-------------------------------------------------------------------------------
local autosave_group = vim.api.nvim_create_augroup("dotfiles_light_auto_save", { clear = true })

local autosave_skip_filetypes = {
  gitcommit = true,
  gitrebase = true,
  help = true,
  lazy = true,
  ["neo-tree"] = true,
  qf = true,
  TelescopePrompt = true,
}

local autosave_skip_buftypes = {
  acwrite = true,
  help = true,
  nofile = true,
  nowrite = true,
  prompt = true,
  quickfix = true,
  terminal = true,
}

local function should_auto_save(buf)
  if not vim.api.nvim_buf_is_valid(buf) or not vim.bo[buf].modified then
    return false
  end

  if vim.api.nvim_buf_get_name(buf) == "" then
    return false
  end

  if not vim.bo[buf].modifiable or vim.bo[buf].readonly then
    return false
  end

  if autosave_skip_filetypes[vim.bo[buf].filetype] or autosave_skip_buftypes[vim.bo[buf].buftype] then
    return false
  end

  return true
end

vim.api.nvim_create_autocmd({ "FocusLost", "BufLeave", "InsertLeave" }, {
  group = autosave_group,
  callback = function(event)
    if not should_auto_save(event.buf) then
      return
    end

    -- 使用 noautocmd 避免保存触发额外格式化或递归 autocmd，行为更接近 JetBrains 的轻量自动保存。
    vim.api.nvim_buf_call(event.buf, function()
      vim.cmd("silent! noautocmd write")
    end)
  end,
})

-------------------------------------------------------------------------------
-- Terminal Buffer Settings
-------------------------------------------------------------------------------
local terminal_group = vim.api.nvim_create_augroup("dotfiles_terminal_buffer", { clear = true })

vim.api.nvim_create_autocmd("TermOpen", {
  group = terminal_group,
  callback = function(event)
    -- 限制终端 scrollback，避免 Codex 等 TUI 频繁重绘时无限增长终端 buffer。
    vim.bo[event.buf].scrollback = 10000
  end,
})

vim.api.nvim_create_autocmd({ "BufWinEnter", "TermEnter", "WinEnter" }, {
  group = terminal_group,
  callback = function(event)
    if vim.bo[event.buf].buftype ~= "terminal" then
      return
    end

    -- 终端窗口不显示代码行号，减少把 scrollback 增长误认为正文输出的干扰。
    vim.wo.number = false
    vim.wo.relativenumber = false
    vim.wo.signcolumn = "no"
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
