vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "md" },
  callback = function()
    -- 设置自动换行的宽度，避免lint出现警告
    vim.opt.textwidth = 80
    vim.opt.formatoptions:append("t")
  end,
})

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
