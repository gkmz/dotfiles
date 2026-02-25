vim.api.nvim_create_autocmd("FileType", {
  pattern = { "go", "gomod", "gowork", "gotmpl" },
  callback = function()
    -- set go specific options
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.colorcolumn = "120"
  end,
})

return {
  {
    "leoluz/nvim-dap-go",
    ft = { "go", "gomod" },
    opts = function(_, opts)
      -- Use opts for dap_configurations if possible, or handle in config
      -- The original user config overwrote the whole config function.
    end,
    config = function(_, opts)
      require("dap-go").setup(opts)
      -- Add custom configs to dap.configurations.go
      -- This ensures we don't wipe out what dap-go setup did, if anything, 
      -- although dap-go setup usually just registers the adapter.
      local dap = require("dap")
      dap.configurations.go = dap.configurations.go or {}
      table.insert(dap.configurations.go, {
          type = "go",
          name = "Debug Package Args",
          request = "launch",
          program = "${fileDirname}",
          args = function()
            local input = vim.fn.input("Args (e.g., -c conf.yml): ")
            if input == "" then
              return {}
            end
            return vim.split(input, " ")
          end,
          outputMode = "remote",
          cwd = "${workspaceFolder}",
      })
    end,
  },
  {
    "ray-x/go.nvim",
    dependencies = { -- optional packages
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      -- disable lsp_cfg to avoid conflict with LazyVim's lspconfig
      require("go").setup({ lsp_cfg = false })
    end,
    event = { "CmdlineEnter" },
    ft = { "go", "gomod" },
    build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
  },
  {
    "nvim-neotest/neotest",
    ft = { "go" },
    dependencies = {
      {
        "fredrikaverpil/neotest-golang",
      },
    },
    opts = function(_, opts)
      opts.adapters = opts.adapters or {}
      opts.adapters["neotest-golang"] = {
        go_test_args = {
          "-v",
          "-count=1",
          "-race",
          "-coverprofile=" .. vim.fn.getcwd() .. "/coverage.out",
          -- "-p=1",
          "-parallel=1",
        },

        -- experimental
        dev_notifications = true,
        runner = "gotestsum",
        gotestsum_args = { "--format=standard-verbose" },
        -- testify_enabled = true,
      }
    end,
  },
}
