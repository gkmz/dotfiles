return {
  {
    "uga-rosa/translate.nvim",
    event = "BufRead",
    -- vscode = true,
    config = function()
      require("config.keymaps").setup_translate_keymaps()
    end,
  },
}
