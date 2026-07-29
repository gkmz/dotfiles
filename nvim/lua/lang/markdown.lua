
return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "AgenticChat" },
    opts = function(_, opts)
      -- Agentic 使用自定义 filetype，需要同时加入渲染白名单和 Lazy 加载条件。
      opts.file_types = opts.file_types or { "markdown" }
      if not vim.tbl_contains(opts.file_types, "AgenticChat") then
        table.insert(opts.file_types, "AgenticChat")
      end
      return opts
    end,
    keys = {
      {
        "<leader>uM",
        function()
          local m = require("render-markdown")
          local enabled = require("render-markdown.state").enabled
          if enabled then
            m.disable()
            vim.opt_local.conceallevel = 0
          else
            m.enable()
            vim.opt_local.conceallevel = 2
          end
        end,
        desc = "Toggle Markdown Render",
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters = {
        markdownlint = {
          args = { "--disable", "MD013", "--" },
        },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        ["markdown"] = { "prettier", "markdownlint-cli2", "markdown-toc" },
      },
    },
  },
}
