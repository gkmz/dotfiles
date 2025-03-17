return {
  {
    "williamboman/mason.nvim",
    event = "VeryLazy",
    opts = {
      ui = {
        border = "rounded",
      },
      ensure_installed = {
        "html-lsp",
        "gopls",
        "json-lsp",
        "lua-language-server",
        "vue-language-server",
        "pyright",
        "yaml-language-server",
        "vtsls",
        "typescript-language-server",
        "bash-language-server",
      },
    },
  },
}
