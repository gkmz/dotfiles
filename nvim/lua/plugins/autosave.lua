return {
  {
    "Pocco81/auto-save.nvim",
    enabled = false,
    event = "BufRead",
    vscode = true,
    config = function()
      require("auto-save").setup()
    end,
  },
}
