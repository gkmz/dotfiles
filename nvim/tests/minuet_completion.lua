local ok, err = xpcall(function()
  local lazy_config = require("lazy.core.config")
  local lazy_plugin = require("lazy.core.plugin")
  local plugin = lazy_config.plugins["minuet-ai.nvim"]

  assert(plugin, "Minuet plugin is not configured")

  local opts = lazy_plugin.values(plugin, "opts", false)
  assert(opts.provider == "openai", "Minuet does not use the OpenAI provider")
  assert(opts.provider_options.openai.api_key == "OPENAI_API_KEY", "Minuet does not read OPENAI_API_KEY")
  assert(opts.provider_options.openai.model == "gpt-5.4-nano", "Minuet uses an unexpected OpenAI model")

  local auto_trigger_ft = opts.virtualtext.auto_trigger_ft
  for _, filetype in ipairs({ "go", "lua", "python", "javascript", "typescript", "javascriptreact", "typescriptreact" }) do
    assert(vim.tbl_contains(auto_trigger_ft, filetype), "Minuet does not auto-trigger for " .. filetype)
  end

  assert(opts.virtualtext.keymap.next == "<A-y>", "Minuet manual trigger key is incorrect")
  assert(opts.virtualtext.keymap.accept == "<A-a>", "Minuet accept key is incorrect")
  assert(opts.virtualtext.keymap.accept_line == "<A-l>", "Minuet accept-line key is incorrect")
  assert(opts.virtualtext.keymap.dismiss == "<A-e>", "Minuet dismiss key is incorrect")
end, debug.traceback)

if not ok then
  print(err)
  vim.cmd("cquit 1")
end

print("OK: Minuet OpenAI completion configuration is valid")
vim.cmd("qa!")
