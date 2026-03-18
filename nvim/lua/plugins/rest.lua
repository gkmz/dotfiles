return {
  {
    "mistweaverco/kulala.nvim",
    ft = { "http", "rest" },
    keys = {
      { "<leader>hr", "<cmd>lua require('kulala').run()<cr>", desc = "Run request" },
      { "<leader>ht", "<cmd>lua require('kulala').toggle_view()<cr>", desc = "Toggle headers/body" },
      { "<leader>hp", "<cmd>lua require('kulala').jump_prev()<cr>", desc = "Prev request" },
      { "<leader>hn", "<cmd>lua require('kulala').jump_next()<cr>", desc = "Next request" },
      { "<leader>he", "<cmd>lua require('kulala').set_env()<cr>", desc = "Select environment" },
    },
    opts = {
      -- 默认配置
      display_mode = "float",
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "http", "xml", "json" })
    end,
  },
}
