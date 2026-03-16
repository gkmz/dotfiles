return {
  {
    "rest-nvim/rest.nvim",
    enabled = true,
    vscode = true,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    ft = { "http" },
    keys = {
      { "<leader>he", "<cmd>lua require('telescope').extensions.rest.select_env()<CR>", desc = "Select env file" },
      { "<leader>hr", "<cmd>Rest run<cr>", desc = "Run request under the cursor" },
      { "<leader>hl", "<cmd>Rest run last<cr>", desc = "Re-run latest request" },
    },
    config = function()
      require("rest-nvim").setup({})
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      table.insert(opts.ensure_installed, "http")
    end,
  },
}
