return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  vscode = true,
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,
  opts = {
    spec = {
      { "<leader>G", group = "Golang", icon = "" },
      { "<leader>T", group = "Terminal", icon = "" },
      { "<leader>o", group = "Obsidian", icon = "󱓧" },
      { "<leader>h", group = "Http/Rest", icon = "󰌷" },
      { "<leader>R", group = "Code Runner", icon = "" },
      { "<leader>p", group = "Snippets", icon = "✂" },
      { "<leader>gd", group = "Git Diff", icon = "" },
      { "<leader>N", group = "NeoTree Misc", icon = "󰙅" },
    },
  },
}
