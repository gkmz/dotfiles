return {
  {
    "CRAG666/code_runner.nvim",
    event = "BufEnter",
    enable = true,
    lazy = true,
    dependencies = {
      "CRAG666/betterTerm.nvim",
    },
    config = function()
      require("code_runner").setup({
        -- mode = "float",
        -- mode = "better_term",
        mode = "tab",
        focus = true,
        float = {
          border = "single",
        },
        filetype = {
          java = {
            "cd $dir &&",
            "javac $fileName &&",
            "java $fileNameWithoutExt",
          },
          python = "python3 -u",
          typescript = "deno run",
          rust = {
            "cd $dir &&",
            "rustc $fileName &&",
            "$dir/$fileNameWithoutExt",
          },
        },
      })
    end,
    keys = require("config.keymaps").setup_code_runner_keymaps(),
  },
}
