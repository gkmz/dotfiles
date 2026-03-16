return {
  {
    "mfussenegger/nvim-jdtls",
    opts = {
      settings = {
        java = {
          inlayHints = {
            parameterNames = { enabled = "all" },
          },
          configuration = {
            updateBuildConfiguration = "automatic",
          },
          codeGeneration = {
            toString = {
              template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
            },
          },
          completion = { enabled = true },
          signatureHelp = { enabled = true },
        },
      },
      dap = {
        hotcodereplace = "auto",
        config_overrides = {},
      },
      dap_main = {},
      test = true,
    },
  },
}
