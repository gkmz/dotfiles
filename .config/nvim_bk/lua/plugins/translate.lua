return {
  {
    "uga-rosa/translate.nvim",
    event = "BufRead",
    config = function()
      require("config.keymaps").setup_translate_keymaps()
    end,
  },
}
