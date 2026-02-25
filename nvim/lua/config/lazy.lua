local status, utils = pcall(require, "utils.vscode")
if not status then
  vim.notify("vscode not loaded")
  -- 给一个默认值
  utils = {
    is_in_vscode = function()
      return false
    end,
  }
end

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    -- add LazyVim and import its plugins
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    -- import/override with your plugins
    { import = "plugins" },
    { import = "lang" },
  },
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    lazy = false,
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install.
    version = false, -- always use the latest git commit
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },
  install = { colorscheme = { "tokyonight", "habamax" } },
  checker = {
    enabled = true, -- check for plugin updates periodically
    notify = false, -- notify on update
  }, -- automatically check for plugin updates
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

-- config custom dap in project .nvim/dap.lua file
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    -- vscode中运行neovim
    if utils.is_in_vscode() then
      return
    end
    local dap_config = vim.fn.getcwd() .. "/.nvim/dap.lua"
    -- vim.notify("dap_config:" .. dap_config)
    if vim.fn.filereadable(dap_config) == 1 then
      local custom_dap = dofile(dap_config)
      local dap = require("dap")
      -- dap.adapters.go = {
      -- 	type = "executable",
      -- 	command = "dlv",
      -- 	args = { "dap", "-l", "127.0.0.1:38697" },
      -- }
      dap.configurations.go = vim.tbl_deep_extend("force", dap.configurations.go, custom_dap)

      vim.notify("Loaded DAP config from .nvim/dap.lua")
    end
  end,
})

require("config.keymaps").setup_keymaps()
