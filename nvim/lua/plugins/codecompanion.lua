return {
  -- CodeCompanion with custom keys from env
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      { "j-hui/fidget.nvim", opts = {} },
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      strategies = {
        chat = { adapter = "anthropic" },
        inline = { adapter = "anthropic" },
      },
      adapters = {
        anthropic = function()
          return require("codecompanion.adapters").extend("anthropic", {
            env = {
              api_key = "cmd:echo $ANTHROPIC_API_KEY",
            },
          })
        end,
        gemini = function()
          return require("codecompanion.adapters").extend("gemini", {
            env = {
              api_key = "cmd:echo $GEMINI_API_KEY",
            },
          })
        end,
      },
    },
    keys = {
      { "<C-a>", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "CodeCompanion Actions" },
      { "<leader>a", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" }, desc = "Toggle AI Chat" },
      { "ga", "<cmd>CodeCompanionChat Add<cr>", mode = "v", desc = "Add selection to AI Chat" },
      {
        "<leader>ac",
        function()
          Snacks.terminal.open("claudecode", { interactive = true, side = "right", width = 0.4 })
        end,
        desc = "Open ClaudeCode",
      },
    },
  },
}
