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

local function select_minuet_model(profile_name)
  require("lazy").load({ plugins = { "minuet-ai.nvim" } })
  local minuet = require("minuet")
  local profiles = minuet.config.model_profiles or {}
  if profile_name and profiles[profile_name] then
    minuet.config.provider_options.openai.model = profiles[profile_name].model
    vim.g.ai_completion_model = profiles[profile_name].model
    vim.notify("Minuet 模型已切换为: " .. profiles[profile_name].model, vim.log.levels.INFO)
    return
  end
  local names, by_name = {}, {}
  for name, profile in pairs(profiles) do
    local label = profile.label or name
    names[#names + 1] = string.format("%s (%s)", label, profile.model)
    by_name[names[#names]] = profile.model
  end
  table.sort(names)
  vim.ui.select(names, { prompt = "选择 Minuet 模型:" }, function(choice)
    local model = choice and by_name[choice]
    if model then
      minuet.config.provider_options.openai.model = model
      vim.g.ai_completion_model = model
      vim.notify("Minuet 模型已切换为: " .. model, vim.log.levels.INFO)
    end
  end)
end

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
    if vim.env.DEEPSEEK_API_KEY == nil or vim.env.DEEPSEEK_API_KEY == "" then
      vim.notify("Minuet 需要 DEEPSEEK_API_KEY。", vim.log.levels.ERROR)
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

  vim.api.nvim_create_user_command("MinuetModel", function(args)
    select_minuet_model(args.args ~= "" and args.args or nil)
  end, {
    nargs = "?",
    complete = function()
      local minuet = package.loaded["minuet"]
      local profiles = minuet and minuet.config.model_profiles or {}
      local names = {}
      for name in pairs(profiles) do
        names[#names + 1] = name
      end
      return names
    end,
    desc = "选择 Minuet 模型",
  })
  vim.keymap.set("n", "<leader>am", select_minuet_model, { desc = "Select Minuet Model" })

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

  -- 默认使用 DeepSeek provider；环境变量缺失时保持关闭，避免后台请求失败。
  if not M.set_provider(current_provider()) then
    M.set_provider("off")
  end
end

return M
