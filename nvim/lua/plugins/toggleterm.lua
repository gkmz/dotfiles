return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {
      size = function(term)
        if term.direction == "horizontal" then
          return 15
        elseif term.direction == "vertical" then
          return math.floor(vim.o.columns * 0.4)
        end
      end,
      open_mapping = nil, -- 由 keymaps 手动管理
      hide_numbers = true,
      shade_terminals = false,
      start_in_insert = true,
      insert_mappings = false,
      terminal_mappings = true,
      persist_size = true,
      persist_mode = true,
      direction = "horizontal", -- 默认底部水平分屏
      close_on_exit = true,
      shell = vim.o.shell,
      float_opts = {
        border = "curved",
        winblend = 3,
      },
    },
    config = function(_, opts)
      require("toggleterm").setup(opts)

      -- 在终端模式下，<Esc><Esc> 退出到 normal 模式
      function _G.set_terminal_keymaps()
        local map = vim.api.nvim_buf_set_keymap
        local o = { noremap = true }
        map(0, "t", "<Esc><Esc>", "<C-\\><C-n>", o)
        map(0, "t", "<C-h>", "<C-\\><C-n><C-w>h", o)
        map(0, "t", "<C-j>", "<C-\\><C-n><C-w>j", o)
        map(0, "t", "<C-k>", "<C-\\><C-n><C-w>k", o)
        map(0, "t", "<C-l>", "<C-\\><C-n><C-w>l", o)
      end

      vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
    end,
  },
}
