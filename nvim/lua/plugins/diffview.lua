return {
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory", "DiffviewFocusFiles", "DiffviewToggleFiles" },
    keys = {
      { "<leader>gdc", ":DiffviewOpen origin/main...HEAD<CR>", desc = "Compare commits" },
      { "<leader>gdq", ":DiffviewClose<CR>", desc = "Close Diffview tab" },
      { "<leader>gdh", ":DiffviewFileHistory %<CR>", desc = "File history" },
      { "<leader>gdH", ":DiffviewFileHistory<CR>", desc = "Repo history" },
      { "<leader>gdm", ":DiffviewOpen<CR>", desc = "Solve merge conflicts" },
      { "<leader>gdo", ":DiffviewOpen main<CR>", desc = "DiffviewOpen main" },
      { "<leader>gdt", ":DiffviewOpen<CR>", desc = "DiffviewOpen this" },
      { "<leader>gdp", ":DiffviewOpen origin/main...HEAD --imply-local<CR>", desc = "Review current PR" },
      {
        "<leader>gdP",
        ":DiffviewFileHistory --range=origin/main...HEAD --right-only --no-merges --reverse<CR>",
        desc = "Review current PR (per commit)",
      },
    },
    opts = {},
  },
}
