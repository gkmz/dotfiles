return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- 1. 解析器列表
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "go",
        "lua",
        "python",
        "http",
        "json",
        "markdown",
        "markdown_inline",
        "bash",
      })

      -- 2. 结构化跳转配置
      -- opts.textobjects = opts.textobjects or {}
      -- opts.textobjects.move = vim.tbl_deep_extend("force", opts.textobjects.move or {}, {
      --   enable = true,
      --   set_jumps = true,
      --   goto_next_start = {
      --     ["]f"] = "@function.outer",
      --   },
      --   goto_previous_start = {
      --     ["[f"] = "@function.outer",
      --   },
      -- })
    end,
  },
}
