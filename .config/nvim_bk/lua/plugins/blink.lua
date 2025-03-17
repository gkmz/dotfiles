return {
  {
    "saghen/blink.cmp",
    dependencies = { "L3MON4D3/LuaSnip", version = "v2.*" },
    opts = {
      -- 'default' for mappings similar to built-in completion
      -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
      -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
      -- See the full "keymap" documentation for information on defining your own keymap.
      keymap = {
        -- set to 'none' to disable the 'default' preset
        preset = "enter",

        ["<M-Tab>"] = { "select_prev", "fallback" },
        ["<Tab>"] = { "select_next", "fallback" },

        -- disable a keymap from the preset
        -- ["<C-e>"] = {},

        -- show with a list of providers
        ["<C-space>"] = {
          function(cmp)
            cmp.show({ providers = { "snippets" } })
          end,
        },
      },
      snippets = { preset = "luasnip" },
      -- ensure you have the `snippets` source (enabled by default)
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
    },
  },
}
