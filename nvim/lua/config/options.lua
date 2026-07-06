-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.scrolloff = 8 -- Keep at least 8 lines above/below cursor
vim.opt.clipboard = "unnamedplus" -- Sync with system clipboard
vim.opt.mouse = "a" -- Enable mouse support
vim.opt.guifont = "JetBrainsMono Nerd Font:h14" -- Prefer high-quality coding font
vim.opt.wrap = true -- Always enable soft wrapping
vim.opt.linebreak = true -- Wrap at word boundaries
vim.g.autoformat = false -- Turn off LazyVim's autoformat-on-save

local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
if (vim.uv or vim.loop).fs_stat(mason_bin) then
  -- 让 Mason 安装的 tree-sitter、ruff、gopls、debugpy 等工具优先被 Neovim 发现。
  vim.env.PATH = mason_bin .. ":" .. vim.env.PATH
end

vim.g.loaded_node_provider = 0 -- Disable unused Node provider
vim.g.loaded_perl_provider = 0 -- Disable unused Perl provider
vim.g.loaded_ruby_provider = 0 -- Disable unused Ruby provider
