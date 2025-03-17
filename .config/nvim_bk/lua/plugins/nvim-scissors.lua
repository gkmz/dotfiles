return {
  {
    -- snippets管理插件
    "chrisgrieser/nvim-scissors",
    event = "VeryLazy",
    dependencies = "nvim-telescope/telescope.nvim", -- optional
    config = function()
      local snippetsDir = "~/.config/nvim/snippets/"
      require("luasnip.loaders.from_vscode").lazy_load({ paths = { snippetsDir } })
      require("scissors").setup({
        snippetDir = snippetsDir,
      })
      require("config.keymaps").setup_scissor_keymaps()
    end,
  },
}
