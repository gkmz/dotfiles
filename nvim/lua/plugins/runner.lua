return {
  {
    "CRAG666/code_runner.nvim",
    cmd = { "RunCode", "RunFile", "RunProject", "RunClose", "CRFiletype", "CRProjects" },
    keys = {
      { "<leader>Rc", "<cmd>RunCode<cr>", desc = "Run code" },
      { "<leader>RC", "<cmd>RunCode tab<cr>", desc = "Run code in tab" },
      { "<leader>Rf", "<cmd>RunFile<cr>", desc = "Run file" },
      { "<leader>RF", "<cmd>RunFile tab<cr>", desc = "Run file in tab" },
      { "<leader>Rm", "<cmd>RunCode<cr>", desc = "Run main (Go)" },
      { "<leader>Rp", "<cmd>RunProject<cr>", desc = "Run project" },
      { "<leader>Rx", "<cmd>RunClose<cr>", desc = "Run close" },
      { "<leader>Rt", "<cmd>CRFiletype<cr>", desc = "Run file type" },
      { "<leader>Rs", "<cmd>CRProjects<cr>", desc = "Run projects" },
    },
    opts = {
      -- 修复：使用终端模式并自动进入插入模式
      mode = "term",
      startinsert = true,
      -- Default runner configuration
      filetype = {
        java = "cd $dir && javac $fileName && java $fileNameWithoutExt",
        python = "python3 -u",
        typescript = "deno run",
        javascript = "node",
        -- 运行当前目录下的 Go 主程序（会向上查找 go.mod）
        go = "cd $dir && go run $fileName",
      },
    },
  },
}
