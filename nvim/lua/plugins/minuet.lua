return {
  {
    "milanglacier/minuet-ai.nvim",
    event = "InsertEnter",
    init = function()
      -- 提前注册 provider 切换命令，默认模式下不加载未认证的 Windsurf。
      require("utils.ai_completion").setup()
    end,
    opts = {
      provider = "openai",
      -- 通用聊天接口需要控制上下文和候选数量，否则很难达到行内补全所需的延迟。
      context_window = 2048,
      n_completions = 1,
      request_timeout = 8,
      throttle = 500,
      debounce = 150,
      virtualtext = {
        -- 自动触发由 AICompletion 统一管理，避免和 Windsurf 同时显示幽灵文本。
        auto_trigger_ft = {},
        show_on_completion_menu = true,
        keymap = {
          next = false,
          prev = false,
          accept = false,
          accept_line = false,
          dismiss = false,
        },
      },
      provider_options = {
        openai = {
          model = vim.env.MINUET_MODEL or "gpt-5.6-luna",
          end_point = (vim.env.OPENAI_BASE_URL or ""):gsub("/+$", "") .. "/chat/completions",
          -- 当前 provider 的 SSE 响应不兼容 Minuet，非流式请求才能稳定解析候选。
          stream = false,
          -- 只传递环境变量名称，避免将 API key 写入 Neovim 配置或 Git。
          api_key = "OPENAI_API_KEY",
          optional = {
            max_tokens = 96,
            reasoning_effort = "none",
          },
        },
      },
    },
    config = function(_, opts)
      if vim.env.OPENAI_API_KEY == nil or vim.env.OPENAI_API_KEY == "" or vim.env.OPENAI_BASE_URL == nil then
        vim.notify("Minuet 未启用：请设置 OPENAI_API_KEY 和 OPENAI_BASE_URL。", vim.log.levels.WARN)
        return
      end

      require("minuet").setup(opts)
    end,
  },
}
