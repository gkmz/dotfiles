return {
  {
    "milanglacier/minuet-ai.nvim",
    event = "InsertEnter",
    opts = {
      provider = "openai",
      request_timeout = 3,
      throttle = 1500,
      debounce = 600,
      virtualtext = {
        -- 仅在常用代码文件中自动请求，避免文档编辑触发不必要的 API 调用。
        auto_trigger_ft = {
          "go",
          "lua",
          "python",
          "javascript",
          "typescript",
          "javascriptreact",
          "typescriptreact",
        },
        keymap = {
          next = "<A-y>",
          prev = "<A-[>",
          accept = "<A-a>",
          accept_line = "<A-l>",
          dismiss = "<A-e>",
        },
      },
      provider_options = {
        openai = {
          model = "gpt-5.4-nano",
          -- 只传递环境变量名称，避免将 API key 写入 Neovim 配置或 Git。
          api_key = "OPENAI_API_KEY",
          optional = {
            max_completion_tokens = 128,
            reasoning_effort = "none",
          },
        },
      },
    },
    config = function(_, opts)
      if vim.env.OPENAI_API_KEY == nil or vim.env.OPENAI_API_KEY == "" then
        vim.notify("Minuet 未启用：当前 Neovim 进程未读取到 OPENAI_API_KEY。", vim.log.levels.WARN)
        return
      end

      require("minuet").setup(opts)
    end,
  },
}
