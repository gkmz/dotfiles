return {
  {
    "Exafunction/windsurf.nvim",
    cmd = "Codeium",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {
      -- 只使用虚拟文本，避免把 AI 候选混入 blink.cmp 的符号补全列表。
      enable_cmp_source = false,
      enable_chat = false,
      virtual_text = {
        enabled = true,
        idle_delay = 75,
        map_keys = false,
        accept_fallback = "",
        default_filetype_enabled = false,
        filetypes = {
          go = true,
          lua = true,
          python = true,
          javascript = true,
          typescript = true,
          javascriptreact = true,
          typescriptreact = true,
        },
      },
    },
    config = function(_, opts)
      require("codeium").setup(opts)
    end,
  },
}
