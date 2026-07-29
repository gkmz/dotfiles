return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      -- LazyVim 会合并该列表；这里只补充默认配置未包含的语言。
      ensure_installed = {
        "go",
        "http",
      },
    },
  },
}
