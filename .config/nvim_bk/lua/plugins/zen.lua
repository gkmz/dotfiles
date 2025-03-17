return {
  {
    "folke/zen-mode.nvim",
    event = "VeryLazy",
    dependencies = { "lvimuser/lsp-inlayhints.nvim" },
    -- LazyVim v14 supported but not fine, so use this
    enable = true,
    config = function()
      local lsp_inlayhints = require("lsp-inlayhints")
      require("zen-mode").setup({
        window = {
          backdrop = 1,
          height = 1.0,
          width = 1.0,
          options = {
            signcolumn = "no",
            number = true,
            relativenumber = true,
            cursorline = true,
            cursorcolumn = false, -- disable cursor column
            -- foldcolumn = "0", -- disable fold column
            -- list = false, -- disable whitespace characters
          },
        },
        plugins = {
          gitsigns = { enabled = false },
          tmux = { enabled = false },
          twilight = { enabled = false },
          -- this will change the font size on wezterm when in zen mode
          -- See alse also the Plugins/Wezterm section in this projects README
          wezterm = {
            enabled = true,
            -- can be either an absolute font size or the number of incremental steps
            font = "+2", -- (10% increase per step)
          },
        },
      })
      require("config.keymaps").setup_zen_keymaps()
    end,
  },
}
