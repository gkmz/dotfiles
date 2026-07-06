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
      { "<leader>a", group = "AI", icon = "󰚩" },
      { "<leader>d", group = "Debug", icon = "" },
      { "<leader>g", group = "Git", icon = "󰊢" },
      { "<leader>h", group = "Http/Rest", icon = "󰌷" },
      { "<leader>l", group = "Language", icon = "󰅩" },
      { "<leader>lg", group = "Go", icon = "" },
      { "<leader>lp", group = "Python", icon = "" },
      { "<leader>o", group = "Obsidian", icon = "󱓧" },
      { "<leader>r", group = "Run", icon = "" },
      { "<leader>t", group = "Test", icon = "󰙨" },
      { "<leader>T", group = "Terminal / Agent", icon = "" },
      { "<leader>u", group = "UI / Utilities", icon = "󰕮" },
      { "<leader>ut", group = "Translate", icon = "󰗊" },
    },
  },
}
