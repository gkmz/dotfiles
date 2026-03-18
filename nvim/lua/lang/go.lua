
return {
  {
    "leoluz/nvim-dap-go",
    opts = {}, -- Extra handles the rest
    keys = {
      { "<leader>Gd", function() require("dap-go").debug_test() end, desc = "Debug Test" },
    },
  },
  {
    "ray-x/go.nvim",
    keys = {
      { "<leader>Gi", "<cmd>GoInstallDeps<Cr>", desc = "Install Go Dependencies" },
      { "<leader>Gt", "<cmd>GoMod tidy<cr>", desc = "Tidy" },
      { "<leader>Ga", "<cmd>GoTestAdd<Cr>", desc = "Add Test" },
      { "<leader>GA", "<cmd>GoTestsAll<Cr>", desc = "Add All Tests" },
      { "<leader>Ge", "<cmd>GoTestsExp<Cr>", desc = "Add Exported Tests" },
      { "<leader>Gg", "<cmd>GoGenerate<Cr>", desc = "Go Generate" },
      { "<leader>GG", "<cmd>GoGenerate %<Cr>", desc = "Go Generate File" },
      { "<leader>Gc", "<cmd>GoCmt<Cr>", desc = "Generate Comment" },
      { "<leader>GI", "<cmd>GoImpl<Cr>", desc = "Implements Interface" },
    },
    opts = {
      lsp_cfg = false, -- avoid conflict with LazyVim's lspconfig
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "go", "gomod", "gowork", "gotmpl" })
    end,
  },
  {
    "nvim-neotest/neotest",
    optional = true,
    opts = {
      adapters = {
        ["neotest-golang"] = {
          go_test_args = { "-v", "-count=1", "-race", "-parallel=1" },
          runner = "gotestsum",
        },
      },
    },
  },
}
