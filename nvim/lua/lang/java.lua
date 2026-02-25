return {
  {
    "mfussenegger/nvim-jdtls",
    opts = function(_, opts)
      -- Merge user settings into opts
      opts.settings = vim.tbl_deep_extend("force", opts.settings or {}, {
        java = {
          inlayHints = {
            parameterNames = {
              enabled = "all",
            },
          },
          -- 显式启用诊断
          configuration = {
            updateBuildConfiguration = "automatic",
          },
          codeGeneration = {
            toString = { template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}" },
          },
          completion = { enabled = true },
          signatureHelp = { enabled = true },
        },
      })
      
      -- Ensure DAP settings are preserved if needed, though LazyVim default is usually good
      opts.dap = vim.tbl_deep_extend("force", opts.dap or {}, { 
        hotcodereplace = "auto", 
        config_overrides = {} 
      })
      opts.dap_main = {}
      opts.test = true
    end,
  },
}
