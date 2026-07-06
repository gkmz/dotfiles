local function python_code_action(only)
  vim.lsp.buf.code_action({
    apply = true,
    context = {
      only = { only },
      diagnostics = {},
    },
  })
end

local function ruff_fix_all()
  -- Ruff 通过 LSP code action 暴露 fixAll，适合一键清理 AI 生成代码的常见 lint 问题。
  python_code_action("source.fixAll.ruff")
end

local function ruff_format()
  -- 统一走 conform，保持和 LazyVim 格式化管线一致。
  require("conform").format({ bufnr = 0, async = true, lsp_fallback = true })
end

return {
  {
    "linux-cultist/venv-selector.nvim",
    optional = true,
    keys = {
      { "<leader>lpv", "<cmd>VenvSelect<cr>", desc = "Select Python venv", ft = "python" },
      { "<leader>cv", false },
    },
  },
  {
    "neovim/nvim-lspconfig",
    optional = true,
    keys = {
      { "<leader>lpr", ruff_fix_all, desc = "Ruff fix all", ft = "python" },
      { "<leader>lpf", ruff_format, desc = "Ruff format", ft = "python" },
    },
  },
  {
    "nvim-neotest/neotest",
    optional = true,
    keys = {
      {
        "<leader>lpt",
        function()
          require("neotest").run.run()
        end,
        desc = "Run nearest Python test",
        ft = "python",
      },
    },
  },
  {
    "mfussenegger/nvim-dap-python",
    optional = true,
    keys = {
      {
        "<leader>lpd",
        function()
          require("dap-python").test_method()
        end,
        desc = "Debug nearest Python test",
        ft = "python",
      },
      { "<leader>dPt", false },
      { "<leader>dPc", false },
    },
  },
}
