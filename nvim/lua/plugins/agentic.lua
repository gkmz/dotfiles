return {
  {
    "carlos-algms/agentic.nvim",
    opts = {
      -- 使用已安装并复用 Codex CLI 认证的 ACP provider。
      provider = "codex-acp",
      windows = {
        position = "right",
        width = "40%",
      },
      diff_preview = {
        enabled = true,
        layout = "split",
      },
    },
    keys = {
      -- Agentic 负责结构化上下文；原生 CLI 快捷键仍由终端模块负责。
      {
        "<leader>aa",
        function()
          require("agentic").toggle()
        end,
        mode = { "n", "v", "i" },
        desc = "Toggle Agentic Chat",
      },
      {
        "ga",
        function()
          require("agentic").add_selection_or_file_to_context()
        end,
        mode = { "n", "v" },
        desc = "Add File or Selection to Agentic",
      },
      {
        "<leader>ad",
        function()
          require("agentic").add_buffer_diagnostics()
        end,
        mode = { "n" },
        desc = "Add Buffer Diagnostics to Agentic",
      },
      {
        "<leader>an",
        function()
          require("agentic").new_session()
        end,
        mode = { "n", "v", "i" },
        desc = "New Agentic Session",
      },
      {
        "<leader>ar",
        function()
          require("agentic").restore_session()
        end,
        mode = { "n", "v", "i" },
        desc = "Restore Agentic Session",
      },
    },
  },
}
