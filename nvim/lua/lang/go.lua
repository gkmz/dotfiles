return {
  {
    "leoluz/nvim-dap-go",
    opts = {}, -- Extra handles the rest
    keys = {
      {
        "<leader>lgd",
        function()
          require("dap-go").debug_test()
        end,
        desc = "Debug Go test",
      },
    },
  },
  {
    "ray-x/go.nvim",
    keys = {
      { "<leader>lgi", "<cmd>GoInstallDeps<Cr>", desc = "Install Go dependencies" },
      { "<leader>lgm", "<cmd>GoMod tidy<cr>", desc = "Go mod tidy" },
      { "<leader>lga", "<cmd>GoTestAdd<Cr>", desc = "Add Go test" },
      { "<leader>lgA", "<cmd>GoTestsAll<Cr>", desc = "Add all Go tests" },
      { "<leader>lge", "<cmd>GoTestsExp<Cr>", desc = "Add exported Go tests" },
      { "<leader>lgg", "<cmd>GoGenerate<Cr>", desc = "Go generate" },
      { "<leader>lgG", "<cmd>GoGenerate %<Cr>", desc = "Go generate file" },
      { "<leader>lgc", "<cmd>GoCmt<Cr>", desc = "Generate Go comment" },
      { "<leader>lgI", "<cmd>GoImpl<Cr>", desc = "Implement Go interface" },
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
          -- Keep runner on "go" for compatibility with the current neotest stack.
          runner = "go",
        },
      },
    },
  },
}
