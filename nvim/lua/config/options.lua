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

-- 行尾只保留简短诊断，完整内容通过可折行浮窗展示，避免长提示挤出编辑区域。
vim.diagnostic.config({
  virtual_text = {
    spacing = 2,
    source = "if_many",
    prefix = "●",
    format = function(diagnostic)
      local message = diagnostic.message:gsub("\n", " ")
      if #message > 80 then
        return message:sub(1, 77) .. "..."
      end
      return message
    end,
  },
  float = {
    border = "rounded",
    source = "if_many",
    focusable = false,
    close_events = { "BufHidden", "InsertCharPre", "WinLeave" },
    max_width = 100,
    max_height = 12,
  },
  severity_sort = true,
  update_in_insert = false,
})

-- 明确设置 split 的直线和连接字符，避免终端默认字符导致窗口边界断裂或过淡。
vim.opt.fillchars:append({
  vert = "│",
  horiz = "─",
  horizup = "┴",
  horizdown = "┬",
  vertleft = "┤",
  vertright = "├",
  verthoriz = "┼",
})

local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
if (vim.uv or vim.loop).fs_stat(mason_bin) then
  -- 让 Mason 安装的 tree-sitter、ruff、gopls、debugpy 等工具优先被 Neovim 发现。
  vim.env.PATH = mason_bin .. ":" .. vim.env.PATH
end

vim.g.loaded_node_provider = 0 -- Disable unused Node provider
vim.g.loaded_perl_provider = 0 -- Disable unused Perl provider
vim.g.loaded_ruby_provider = 0 -- Disable unused Ruby provider
