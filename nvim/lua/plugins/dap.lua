return {
  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap = require("dap")
      -- 加载 VS Code 风格的 launch.json
      require("dap.ext.vscode").load_launchjs(nil, {
        delve = { "go" }, -- 明确指定 go 类型使用 delve 适配器
      })
    end,
    keys = {
      {
        "<F5>",
        function()
          require("dap").continue()
        end,
        desc = "Continue",
      },
      {
        "<F8>",
        function()
          require("dap").step_over()
        end,
        desc = "Step Over",
      },
      {
        "<F7>",
        function()
          require("dap").step_into()
        end,
        desc = "Step Into",
      },
      {
        "<F9>",
        function()
          require("dap").step_out()
        end,
        desc = "Step Out",
      },
      {
        "<F10>",
        function()
          require("dap").terminate()
        end,
        desc = "Terminate",
      },
      {
        "<leader>db",
        function()
          require("dap").toggle_breakpoint()
        end,
        desc = "Toggle Breakpoint",
      },
      {
        "<leader>dB",
        function()
          require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
        end,
        desc = "Conditional Breakpoint",
      },
      {
        "<leader>dc",
        function()
          require("dap").continue()
        end,
        desc = "Continue",
      },
      {
        "<leader>di",
        function()
          require("dap").step_into()
        end,
        desc = "Step Into",
      },
      {
        "<leader>do",
        function()
          require("dap").step_over()
        end,
        desc = "Step Over",
      },
      {
        "<leader>dO",
        function()
          require("dap").step_out()
        end,
        desc = "Step Out",
      },
      {
        "<leader>dt",
        function()
          require("dap").terminate()
        end,
        desc = "Terminate",
      },
    },
  },
  {
    "rcarriga/nvim-dap-ui",
    optional = true,
    keys = {
      {
        "<leader>du",
        function()
          require("dapui").toggle({})
        end,
        desc = "Toggle DAP UI",
      },
    },
  },
}
