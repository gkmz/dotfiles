return {
  {
    "Isrothy/neominimap.nvim",
    lazy = true,
    keys = {
      { "<Leader>um", group = "Mini Map" },
      { "<Leader>umt", "<cmd>Neominimap toggle<CR>", desc = "Toggle Mini map" },
      { "<leader>umf", "<cmd>Neominimap toggleFocus<cr>", desc = "Toggle focus on minimap" },
      { "<leader>umw", "<cmd>Neominimap winToggle<cr>", desc = "Toggle minimap for current window" },
      { "<leader>umr", "<cmd>Neominimap winRefresh<cr>", desc = "Refresh minimap for current window" },
      { "<leader>umb", "<cmd>Neominimap bufToggle<cr>", desc = "Toggle minimap for current buffer" },
      { "<leader>uma", "<cmd>Neominimap bufRefresh<cr>", desc = "Refresh minimap for current buffer" },
    },
    init = function()
      -- The plugin documentation recommends setting these options here
      vim.opt.wrap = true
      vim.opt.sidescrolloff = 36
      vim.g.neominimap_enabled = true
    end,
    opts = {
      auto_enable = true,
    },
  },
}
