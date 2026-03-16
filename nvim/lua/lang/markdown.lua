
return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
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
