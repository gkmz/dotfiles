return {
  {
    "uga-rosa/translate.nvim",
    event = "BufRead",
    keys = {
      { "<leader>ute", ":Translate EN<CR>", desc = "Translate to English" },
      { "<leader>utz", ":Translate ZH<CR>", desc = "Translate to Chinese" },
      { "<leader>utw", "viw:Translate ZH<CR>", desc = "Translate word to Chinese" },
      { "<leader>utz", ":Translate ZH<CR>", mode = "v", desc = "Translate selection to Chinese" },
    },
    config = function()
      require("translate").setup({})
    end,
  },
}
