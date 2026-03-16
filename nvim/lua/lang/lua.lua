return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      {
        "jbyuki/one-small-step-for-vimkind",
        -- stylua: ignore
        config = function()
          local dap = require("dap")
          dap.adapters.nlua = function(callback, conf)
            local adapter = {
              type = "server",
              host = conf.host or "127.0.0.1",
              port = conf.port or 8086,
            }
            if conf.start_neovim then
              local osv = require("osv")
              osv.run_this()
            end
            callback(adapter)
          end
          dap.configurations.lua = {
            {
              type = "nlua",
              request = "attach",
              name = "Run this file",
              start_neovim = {},
            },
            {
              type = "nlua",
              request = "attach",
              name = "Attach to running Neovim instance (port = 8086)",
              port = 8086,
            },
          }
        end,
      },
    },
  },
}
