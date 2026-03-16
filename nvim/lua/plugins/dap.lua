return {
  {
    "mfussenegger/nvim-dap",
    keys = {
      { "<F8>", function() require("dap").step_over() end, desc = "Step Over" },
      { "<F7>", function() require("dap").step_into() end, desc = "Step Into" },
      { "<F9>", function() require("dap").step_out() end, desc = "Step Out" },
      { "<F10>", function() require("dap").continue() end, desc = "Continue" },
    },
  },
}
