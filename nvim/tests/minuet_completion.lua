local ok, err = xpcall(function()
  local lazy_config = require("lazy.core.config")
  local lazy_plugin = require("lazy.core.plugin")
  local plugin = lazy_config.plugins["minuet-ai.nvim"]

  assert(plugin, "Minuet plugin is not configured")

  local opts = lazy_plugin.values(plugin, "opts", false)
  assert(opts.provider == "openai", "Minuet does not use the OpenAI-compatible provider")
  assert(opts.provider_options.openai.api_key == "DEEPSEEK_API_KEY", "Minuet does not read DEEPSEEK_API_KEY")
  assert(opts.provider_options.openai.model == "deepseek-v4-flash", "Minuet does not default to DeepSeek V4 Flash")
  assert(opts.provider_options.openai.end_point:match("/chat/completions$"), "Minuet endpoint is invalid")
  assert(opts.provider_options.openai.stream == false, "Minuet uses incompatible streaming responses")
  assert(type(opts.model_profiles) == "table", "Minuet model profiles are missing")
  assert(opts.model_profiles.flash.model == "deepseek-v4-flash", "DeepSeek V4 Flash profile is missing")
  assert(opts.model_profiles.reasoner.model == "deepseek-reasoner", "DeepSeek reasoner profile is missing")
  assert(opts.request_timeout == 8, "Minuet request timeout is too short for the configured provider")
  assert(opts.context_window == 2048, "Minuet context window is too large for inline completion")
  assert(opts.n_completions == 1, "Minuet requests too many completion candidates")

  local auto_trigger_ft = opts.virtualtext.auto_trigger_ft
  assert(#auto_trigger_ft == 0, "Minuet auto-trigger must be managed by AICompletion")
  assert(opts.virtualtext.show_on_completion_menu == true, "Minuet is hidden while the completion menu is visible")
end, debug.traceback)

if not ok then
  print(err)
  vim.cmd("cquit 1")
end

print("OK: Minuet DeepSeek completion configuration is valid")
vim.cmd("qa!")
