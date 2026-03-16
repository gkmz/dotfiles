return {
  {
    "uga-rosa/translate.nvim",
    event = "BufRead",
    keys = {
      { "te", ":Translate EN<CR>", desc = "Translate EN" },
      { "tz", ":Translate ZH<CR>", desc = "Translate ZH" },
      { "tw", "viw:Translate ZH<CR>", desc = "Translate Word ZH" },
      { "tz", ":Translate ZH<CR>", mode = "v", desc = "Translate ZH (Visual)" },
    },
    config = function()
      require("translate").setup({})
    end,
  },
}
