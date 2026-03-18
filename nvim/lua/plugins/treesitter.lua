return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    opts = function(_, opts)
      -- 0. 强制指定安装目录，并置于搜索路径最前端，彻底屏蔽 site/parser 冲突
      local parser_install_dir = vim.fn.stdpath("data") .. "/lazy/nvim-treesitter/parser"
      vim.opt.runtimepath:prepend(parser_install_dir)
      opts.parser_install_dir = parser_install_dir

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

      -- 2. 结构化跳转配置 (通过 opts 合并)
      opts.textobjects = opts.textobjects or {}
      opts.textobjects.move = vim.tbl_deep_extend("force", opts.textobjects.move or {}, {
        enable = true,
        set_jumps = true,
        goto_next_start = {
          ["]f"] = "@function.outer",
        },
        goto_previous_start = {
          ["[f"] = "@function.outer",
        },
      })
    end,
  },
}
