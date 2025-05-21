vim.api.nvim_create_autocmd("FileType", {
  pattern = { "proto" },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab = false

    vim.opt_local.colorcolumn = "120" -- TODO: what does the buf formatter use?
  end,
})

return {
  {
    "stevearc/conform.nvim",
    dependencies = {
      {
        "williamboman/mason.nvim",
        opts = function(_, opts)
          opts.ensure_installed = opts.ensure_installed or {}
          vim.list_extend(opts.ensure_installed, { "buf" })
        end,
      },
    },
    opts = {
      formatters_by_ft = {
        proto = { "buf" },
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
          {
            "williamboman/mason.nvim",
          },
        },
        opts = function(_, opts)
          opts.ensure_installed = opts.ensure_installed or {}
          vim.list_extend(opts.ensure_installed, { "buf_ls" })
        end,
      },
    },
    opts = {
      servers = {
        ---@type vim.lsp.Config
        buf_ls = {
          -- lsp: https://github.com/bufbuild/buf
          -- ref: https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/configs/protols.lua
          cmd = { "buf", "beta", "lsp", "--timeout=0", "--log-format=text" },
          filetypes = { "proto" },
          root_markers = { "buf.yaml", "buf.yml", ".git" },
          settings = {
            buf_ls = {},
          },
        },
      },
    },
  },
}
