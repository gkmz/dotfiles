return {
  {
    "Pocco81/auto-save.nvim",
    enabled = true,
    event = "BufRead",
    vscode = true,
    config = function()
      require("auto-save").setup()
    end,
  },
}
