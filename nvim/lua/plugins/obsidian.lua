return {
  "epwalsh/obsidian.nvim",
  version = "*", -- recommended, use latest release instead of latest commit
  lazy = true,
  ft = "markdown",
  -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
  -- event = {
  --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
  --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
  --   -- refer to `:h file-pattern` for more examples
  --   "BufReadPre path/to/my-vault/*.md",
  --   "BufNewFile path/to/my-vault/*.md",
  -- },
  dependencies = {
    -- Required.
    "nvim-lua/plenary.nvim",

    -- see below for full list of optional dependencies 👇
  },
  opts = {
    workspaces = {
      {
        name = "personal",
        path = "~/workspace/mine/vaults/",
        -- Optional, override certain settings.
        overrides = {
          notes_subdir = "notes",
        },
      },
    },
  },
  keys = {
    { "<leader>os", "<cmd>ObsidianSearch<cr>", desc = "[N]otes: [s]earch text" },
    { "<leader>of", "<cmd>ObsidianQuickSwitch<cr>", desc = "[N]otes: search [f]ilenames" },
    { "<leader>on", "<cmd>ObsidianNew<cr>", desc = "[N]otes: [n]new" },
    { "<leader>ol", "<cmd>ObsidianQuickSwitch Learning.md<cr><cr>", desc = "[N]otes: [l]earning" },
    { "<leader>og", "<cmd>ObsidianQuickSwitch Go.md<cr><cr>", desc = "[N]otes: [g]olang learning" },
    { "<leader>ov", "<cmd>ObsidianQuickSwitch Neovim config.md<cr><cr>", desc = "[N]otes: Neo[v]im todo" },
  },
}
