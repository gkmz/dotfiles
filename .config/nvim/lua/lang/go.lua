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
    opts = {
      -- dap_configurations = {
      --   {
      --     type = "go",
      --     name = "Debug Package Args",
      --     request = "launch",
      --     program = "${fileDirname}",
      --     args = function()
      --       local input = vim.fn.input("Args (e.g., -c conf.yml): ")
      --       if input == "" then
      --         return {}
      --       end
      --       return vim.split(input, " ")
      --     end,
      --     -- 配置了该选项才可以在dap ui中看到控制台输出
      --     -- local（默认）：Delve 直接将输出写入调试器的终端（例如 Neovim 的终端缓冲区），但不会通过 DAP 协议转发给客户端（nvim-dap）。
      --     -- remote：Delve 将输出通过 DAP 协议的 output 事件发送给客户端（nvim-dap），然后由 DAP UI 或其他监听器捕获并显示。
      --     outputMode = "remote",
      --     cwd = "${workspaceFolder}",
      --     -- 内部console
      --     -- console = "internalConsole",
      --     -- nvim内部终端
      --     -- console = "integratedTerminal",
      --   },
      --   {
      --     type = "go",
      --     name = "Debug Package Api (dev)",
      --     request = "launch",
      --     program = "${workspaceFolder}/cmd/api",
      --     args = { "-c", "${workspaceFolder}/cmd/api/conf/dev.yml" },
      --     outputMode = "remote",
      --     cwd = "${workspaceFolder}",
      --   },
      --   {
      --     type = "go",
      --     name = "Debug Package Job (dev)",
      --     request = "launch",
      --     program = "${workspaceFolder}/cmd/job",
      --     args = { "-c", "${workspaceFolder}/cmd/job/conf/dev.yml" },
      --     outputMode = "remote",
      --     cwd = "${workspaceFolder}",
      --   },
      -- },
    },
    config = function(_, opts)
      -- 增加自定义配置
      require("dap").configurations.go = {
        {
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
          -- 配置了该选项才可以在dap ui中看到控制台输出
          -- local（默认）：Delve 直接将输出写入调试器的终端（例如 Neovim 的终端缓冲区），但不会通过 DAP 协议转发给客户端（nvim-dap）。
          -- remote：Delve 将输出通过 DAP 协议的 output 事件发送给客户端（nvim-dap），然后由 DAP UI 或其他监听器捕获并显示。
          outputMode = "remote",
          cwd = "${workspaceFolder}",
          -- 内部console
          -- console = "internalConsole",
          -- nvim内部终端
          -- console = "integratedTerminal",
        },
      }
      -- 安装dap-go
      require("dap-go").setup() -- 初始化 nvim-dap-go
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
      require("go").setup()
    end,
    event = { "CmdlineEnter" },
    ft = { "go", "gomod" },
    build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
  },
  {
    "olexsmir/gopher.nvim",
    event = "VeryLazy",
    ft = "go",
    config = function()
      require("config.keymaps").setup_go_keymaps()
    end,
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
  {
    "andythigpen/nvim-coverage",
    ft = { "go" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      -- https://github.com/andythigpen/nvim-coverage/blob/main/doc/nvim-coverage.txt
      auto_reload = true,
      lang = {
        go = {
          coverage_file = vim.fn.getcwd() .. "/coverage.out",
        },
      },
    },
  },
}
