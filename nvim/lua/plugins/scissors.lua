return {
  {
    "chrisgrieser/nvim-scissors",
    dependencies = "nvim-telescope/telescope.nvim", 
    opts = {
      snippetDir = vim.fn.stdpath("config") .. "/snippets",
    },
    keys = {
      { "<leader>pa", function() require("scissors").addNewSnippet() end, desc = "Add New Snippet" },
      { "<leader>pe", function() require("scissors").editSnippet() end, desc = "Edit Snippet" },
      { "<leader>pA", ":'<,'>ScissorsAddNewSnippet<cr>", mode = "v", desc = "Add New Visual Snippet" },
    },
  },
}
