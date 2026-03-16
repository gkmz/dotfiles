return {
  {
    "CRAG7/nvim-code-runner",
    cmd = { "RunCode", "RunFile", "RunProject", "RunClose", "CRFiletype", "CRProjects" },
    keys = {
      { "<leader>R", group = "Code Runner" },
      { "<leader>Rc", "<cmd>RunCode<cr>", desc = "Run code" },
      { "<leader>RC", "<cmd>RunCode tab<cr>", desc = "Run code in tab" },
      { "<leader>Rf", "<cmd>RunFile<cr>", desc = "Run file" },
      { "<leader>RF", "<cmd>RunFile tab<cr>", desc = "Run file in tab" },
      { "<leader>Rp", "<cmd>RunProject<cr>", desc = "Run project" },
      { "<leader>Rx", "<cmd>RunClose<cr>", desc = "Run close" },
      { "<leader>Rt", "<cmd>CRFiletype<cr>", desc = "Run file type" },
      { "<leader>Rs", "<cmd>CRProjects<cr>", desc = "Run projects" },
    },
    opts = {
      -- Default runner configuration
      filetype = {
        java = "cd $dir && javac $fileName && java $fileNameWithoutExt",
        python = "python3 -u",
        typescript = "deno run",
        javascript = "node",
      },
    },
  },
}
