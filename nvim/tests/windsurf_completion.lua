local ok, err = xpcall(function()
  local lazy_config = require("lazy.core.config")
  local lazy_plugin = require("lazy.core.plugin")
  local plugin = lazy_config.plugins["windsurf.nvim"]

  assert(plugin, "Windsurf plugin is not configured")

  local opts = lazy_plugin.values(plugin, "opts", false)
  assert(plugin.cmd == "Codeium", "Windsurf is not lazy-loaded by its command")
  assert(opts.enable_cmp_source == false, "Windsurf must not register a duplicate completion-menu source")
  assert(opts.virtual_text.enabled == true, "Windsurf virtual text is not enabled")
  assert(opts.virtual_text.idle_delay == 75, "Windsurf completion delay is unexpected")
  assert(opts.virtual_text.map_keys == false, "Windsurf keymaps must be managed by AICompletion")
  assert(opts.virtual_text.default_filetype_enabled == false, "Windsurf is enabled for unreviewed filetypes")

  local completion = require("utils.ai_completion")
  assert(type(completion.setup) == "function", "AI completion setup is missing")
  assert(type(completion.set_provider) == "function", "AI completion provider switch is missing")

  vim.g.ai_completion_provider = nil
  assert(completion.get_provider() == "minuet", "Minuet is not the default completion provider")
  assert(type(LazyVim.cmp.actions.ai_accept) == "function", "AI completion is not integrated with LazyVim Tab")
  assert(vim.fn.maparg("<M-]>", "i") ~= "", "Next AI suggestion keymap is missing")
  assert(vim.fn.maparg("<M-[>", "i") ~= "", "Previous AI suggestion keymap is missing")
  assert(vim.fn.exists(":MinuetModel") == 2, "Minuet model selection command is missing")
  assert(vim.fn.maparg("<leader>am", "n") ~= "", "Minuet model selection keymap is missing")
  for _, key in ipairs({ "<A-y>", "<A-a>", "<A-l>", "<A-e>" }) do
    assert(vim.fn.maparg(key, "i") == "", "Legacy AI completion keymap is still registered: " .. key)
  end
end, debug.traceback)

if not ok then
  print(err)
  vim.cmd("cquit 1")
end

print("OK: Windsurf completion configuration is valid")
vim.cmd("qa!")
