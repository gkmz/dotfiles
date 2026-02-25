return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    { "j-hui/fidget.nvim", opts = {} },
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    require("codecompanion").setup({
      strategies = {
        chat = { adapter = "copilot" }, -- 或 "openai"
        inline = { adapter = "copilot" },
      },
      adapters = {
        anthropic = function()
          return require("codecompanion.adapters").extend("anthropic", {
            env = {
              -- ⚠️ 建议将 Key 放在环境变量 ANTHROPIC_API_KEY 中，不要硬编码
              api_key = "cmd:echo $ANTHROPIC_API_KEY",
            },
          })
        end,
        openai = function()
          return require("codecompanion.adapters").extend("openai", {
            env = {
              -- ⚠️ 建议将 Key 放在环境变量 ANTHROPIC_API_KEY 中，不要硬编码
              api_key = "cmd:echo $OPENAI_API_KEY",
            },
          })
        end,
        gemini = function()
          return require("codecompanion.adapters").extend("gemini", {
            env = {
              -- ⚠️ 建议将 Key 放在环境变量 ANTHROPIC_API_KEY 中，不要硬编码
              api_key = "cmd:echo $GEMINI_API_KEY",
            },
          })
        end,
      },
    })
  end,
  -- 快捷键配置 (Lazy 风格)
  keys = {
    { "<C-a>", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "CodeCompanion Actions" },
    { "<leader>a", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" }, desc = "Toggle AI Chat" },
    { "ga", "<cmd>CodeCompanionChat Add<cr>", mode = "v", desc = "Add selection to AI Chat" },
  },
}
