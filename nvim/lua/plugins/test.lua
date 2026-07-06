local function run_go_race_tests()
  if vim.bo.filetype ~= "go" then
    vim.notify("Go race test only runs in Go buffers", vim.log.levels.WARN)
    return
  end

  -- 使用真实终端运行全量 race 测试，便于保留长输出和失败上下文。
  vim.cmd("botright 15split")
  vim.cmd("terminal go test -race ./...")
  vim.cmd("startinsert")
end

return {
  {
    "nvim-neotest/neotest",
    optional = true,
    keys = {
      {
        "<leader>ta",
        function()
          require("neotest").run.run(vim.uv.cwd())
        end,
        desc = "Run all tests",
      },
      {
        "<leader>td",
        function()
          require("neotest").run.run({ strategy = "dap" })
        end,
        desc = "Debug nearest test",
      },
      {
        "<leader>tf",
        function()
          require("neotest").run.run(vim.fn.expand("%"))
        end,
        desc = "Run file tests",
      },
      {
        "<leader>tl",
        function()
          require("neotest").run.run_last()
        end,
        desc = "Run last test",
      },
      {
        "<leader>tn",
        function()
          require("neotest").run.run()
        end,
        desc = "Run nearest test",
      },
      {
        "<leader>to",
        function()
          require("neotest").output.open({ enter = true, auto_close = true })
        end,
        desc = "Open test output",
      },
      { "<leader>tr", run_go_race_tests, desc = "Run Go race tests" },
      {
        "<leader>ts",
        function()
          require("neotest").summary.toggle()
        end,
        desc = "Toggle test summary",
      },

      -- 关闭 LazyVim 默认测试键位，只保留任务导向的新分组。
      { "<leader>tt", false },
      { "<leader>tT", false },
      { "<leader>tO", false },
      { "<leader>tS", false },
      { "<leader>tw", false },
    },
  },
}
