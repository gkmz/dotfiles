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
        chat = { adapter = "gemini" },
        inline = { adapter = "gemini" },
      },
      display = {
        chat = {
          window = {
            layout = "vertical", -- 垂直布局
            position = "right", -- 显示在右侧
          },
        },
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
            schema = {
              model = {
                default = "gemini-2.0-flash", -- 使用最新的 Gemini 2.0 Flash
              },
            },
            env = {
              api_key = "cmd:echo $GEMINI_API_KEY",
            },
          })
        end,
      },
    },
    keys = {
      { "<C-a>", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" }, desc = "Toggle AI Chat" },
      { "<leader>aa", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" }, desc = "Toggle AI Chat" },
      { "<leader>a", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "CodeCompanion Actions" },
      { "ga", "<cmd>CodeCompanionChat Add<cr>", mode = "v", desc = "Add selection to AI Chat" },
      {
        "<leader>ac",
        function()
          Snacks.terminal.open("claude", {
            win = {
              position = "float",
              border = "rounded",
              width = 0.8,
              height = 0.8,
            },
            interactive = true,
          })
        end,
        desc = "Open ClaudeCode",
      },
    },
  },
}
