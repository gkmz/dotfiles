return {

  {
    "rest-nvim/rest.nvim",
    enabled = true,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      opts = function(_, opts)
        opts.ensure_installed = opts.ensure_installed or {}
        table.insert(opts.ensure_installed, "http")
      end,
    },
    ft = { "http" },
    config = function()
      require("config.keymaps").setup_rest_keymaps()
    end,
  },
}
