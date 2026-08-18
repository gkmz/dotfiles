local M = {}

local supported_filetypes = {
  go = true,
  lua = true,
  python = true,
  javascript = true,
  typescript = true,
  javascriptreact = true,
  typescriptreact = true,
}

local providers = {
  windsurf = true,
  minuet = true,
  off = true,
}

local function minuet_enabled_for_buffer(bufnr)
  return vim.g.ai_completion_provider == "minuet" and supported_filetypes[vim.bo[bufnr].filetype] == true
end

local function update_minuet_buffers()
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(bufnr) then
      vim.b[bufnr].minuet_virtual_text_auto_trigger = minuet_enabled_for_buffer(bufnr)
    end
  end
end

local function clear_suggestions()
  local minuet = package.loaded["minuet.virtualtext"]
  if minuet then
    minuet.action.dismiss()
  end

  local windsurf = package.loaded["codeium.virtual_text"]
  if windsurf then
    windsurf.clear()
  end
end

local function feed_windsurf_keys(keys)
  if keys == nil or keys == "" then
    return
  end

  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), "n", false)
end

local function current_provider()
  return vim.g.ai_completion_provider or "minuet"
end

---返回当前 Neovim 会话选择的自动代码补全 provider。
---@return "windsurf"|"minuet"|"off" provider
function M.get_provider()
  return current_provider()
end

---切换当前 Neovim 会话使用的自动代码补全 provider。
---@param provider "windsurf"|"minuet"|"off"
---@return boolean success
function M.set_provider(provider)
  if not providers[provider] then
    vim.notify("未知的代码补全 provider: " .. provider, vim.log.levels.ERROR)
    return false
  end

  if provider == "minuet" then
    if vim.env.OPENAI_API_KEY == nil or vim.env.OPENAI_API_KEY == "" or vim.env.OPENAI_BASE_URL == nil then
      vim.notify("Minuet 需要 OPENAI_API_KEY 和 OPENAI_BASE_URL。", vim.log.levels.ERROR)
      return false
    end
  end

  clear_suggestions()
  vim.g.ai_completion_provider = provider
  update_minuet_buffers()

  -- Windsurf 只在用户明确切换时加载，避免无 token 时后台启动语言服务器。
  if provider == "windsurf" then
    require("lazy").load({ plugins = { "windsurf.nvim" } })
    local codeium = require("codeium")
    codeium.enable()
  else
    local codeium = package.loaded["codeium"]
    if codeium and codeium.s then
      codeium.disable()
    end
  end

  vim.notify("自动代码补全已切换为: " .. provider, vim.log.levels.INFO)
  return true
end

local function minuet_action(name)
  require("minuet.virtualtext").action[name]()
end

local function windsurf_action(name, ...)
  local result = require("codeium.virtual_text")[name](...)
  if type(result) == "string" then
    feed_windsurf_keys(result)
  end
end

local function run_action(minuet_name, windsurf_name, ...)
  local provider = current_provider()
  if provider == "minuet" then
    minuet_action(minuet_name)
  elseif provider == "windsurf" then
    windsurf_action(windsurf_name, ...)
  end
end

local function accept_suggestion()
  local provider = current_provider()
  if provider == "minuet" then
    local virtualtext = package.loaded["minuet.virtualtext"]
    if virtualtext and virtualtext.action.is_visible() then
      LazyVim.create_undo()
      virtualtext.action.accept()
      return true
    end
  elseif provider == "windsurf" then
    local virtualtext = package.loaded["codeium.virtual_text"]
    if virtualtext and virtualtext.get_current_completion_item() then
      LazyVim.create_undo()
      feed_windsurf_keys(virtualtext.accept())
      return true
    end
  end
end

---注册 provider 切换命令、缓冲区同步和统一补全快捷键。
function M.setup()
  if vim.g.ai_completion_setup_done then
    return
  end
  vim.g.ai_completion_setup_done = true
  vim.g.ai_completion_provider = current_provider()

  vim.api.nvim_create_user_command("AICompletion", function(args)
    if args.args == "status" then
      vim.notify("当前自动代码补全 provider: " .. current_provider(), vim.log.levels.INFO)
      return
    end
    M.set_provider(args.args)
  end, {
    nargs = 1,
    complete = function()
      return { "windsurf", "minuet", "off", "status" }
    end,
    desc = "切换自动代码补全 provider",
  })

  local group = vim.api.nvim_create_augroup("dotfiles_ai_completion", { clear = true })
  vim.api.nvim_create_autocmd({ "BufEnter", "FileType" }, {
    group = group,
    callback = function(event)
      vim.b[event.buf].minuet_virtual_text_auto_trigger = minuet_enabled_for_buffer(event.buf)
    end,
    desc = "同步 Minuet 自动补全状态",
  })

  -- 接入 LazyVim 的 Blink 扩展点：Tab 优先处理片段，其次接受 AI，最后保持原行为。
  LazyVim.cmp.actions.ai_accept = accept_suggestion

  -- 候选切换沿用 LazyVim Copilot 的默认键位；没有候选时，向 provider 发起手动请求。
  vim.keymap.set("i", "<M-]>", function()
    run_action("next", "cycle_or_complete")
  end, { desc = "Next AI Suggestion" })
  vim.keymap.set("i", "<M-[>", function()
    run_action("prev", "cycle_completions", -1)
  end, { desc = "Previous AI Suggestion" })

  -- 默认使用可控的 OpenAI 兼容 provider；环境变量缺失时保持关闭，避免 Windsurf 未认证仍反复启动。
  if not M.set_provider(current_provider()) then
    M.set_provider("off")
  end
end

return M
