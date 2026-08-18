local ok, err = xpcall(function()
  local lazy_config = require("lazy.core.config")
  local lazy_plugin = require("lazy.core.plugin")
  local plugin = lazy_config.plugins["minuet-ai.nvim"]

  assert(plugin, "Minuet plugin is not configured")

  local opts = lazy_plugin.values(plugin, "opts", false)
  assert(opts.provider == "openai", "Minuet does not use the OpenAI provider")
  assert(opts.provider_options.openai.api_key == "OPENAI_API_KEY", "Minuet does not read OPENAI_API_KEY")
  assert(opts.provider_options.openai.model == "gpt-5.6-luna", "Minuet uses an unexpected OpenAI model")
  assert(opts.provider_options.openai.end_point:match("/chat/completions$"), "Minuet endpoint is invalid")
  assert(opts.provider_options.openai.stream == false, "Minuet uses incompatible streaming responses")
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

print("OK: Minuet OpenAI completion configuration is valid")
vim.cmd("qa!")
