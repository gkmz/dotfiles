local user_question_pattern = [[^## .* User\%( - .*\)\?$]]

local function jump_to_user_question(direction)
  local flags = direction < 0 and "bnW" or "nW"
  local position = vim.fn.searchpos(user_question_pattern, flags)
  if position[1] == 0 then
    return
  end

  -- 与 Agentic 原生标题导航一致，记录当前位置后再跳转，方便用两个单引号返回。
  vim.cmd("normal! m'")
  vim.api.nvim_win_set_cursor(0, { position[1], 0 })
end

local function setup_question_navigation(bufnr)
  vim.keymap.set("n", "[u", function()
    jump_to_user_question(-1)
  end, { buffer = bufnr, desc = "Previous Agentic User Question" })

  vim.keymap.set("n", "]u", function()
    jump_to_user_question(1)
  end, { buffer = bufnr, desc = "Next Agentic User Question" })
end

return {
  {
    "carlos-algms/agentic.nvim",
    init = function()
      local group = vim.api.nvim_create_augroup("dotfiles_agentic_question_navigation", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        group = group,
        pattern = "AgenticChat",
        callback = function(event)
          setup_question_navigation(event.buf)
        end,
      })
    end,
    opts = {
      -- 使用已安装并复用 Codex CLI 认证的 ACP provider。
      provider = "codex-acp",
      windows = {
        position = "right",
        width = "40%",
      },
      diff_preview = {
        enabled = true,
        layout = "split",
      },
    },
    keys = {
      -- Agentic 负责结构化上下文；原生 CLI 快捷键仍由终端模块负责。
      {
        "<leader>aa",
        function()
          require("agentic").toggle()
        end,
        mode = { "n", "v", "i" },
        desc = "Toggle Agentic Chat",
      },
      {
        "ga",
        function()
          require("agentic").add_selection_or_file_to_context()
        end,
        mode = { "n", "v" },
        desc = "Add File or Selection to Agentic",
      },
      {
        "<leader>ad",
        function()
          require("agentic").add_buffer_diagnostics()
        end,
        mode = { "n" },
        desc = "Add Buffer Diagnostics to Agentic",
      },
      {
        "<leader>an",
        function()
          require("agentic").new_session()
        end,
        mode = { "n", "v", "i" },
        desc = "New Agentic Session",
      },
      {
        "<leader>ar",
        function()
          require("agentic").restore_session()
        end,
        mode = { "n", "v", "i" },
        desc = "Restore Agentic Session",
      },
    },
  },
}
