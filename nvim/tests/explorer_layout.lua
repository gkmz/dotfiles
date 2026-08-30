local ok, err = xpcall(function()
  local lazy_config = require("lazy.core.config")
  local lazy_plugin = require("lazy.core.plugin")
  local plugin = lazy_config.plugins["snacks.nvim"]
  assert(plugin, "Snacks plugin is not configured")

  local opts = lazy_plugin.values(plugin, "opts", false)
  local layout = opts.picker.sources.explorer.layout
  assert(layout.layout.position == "float", "Explorer must use a floating layout")
  assert(layout.layout.width == 28, "Explorer floating width must be 28 columns")
end, debug.traceback)

if not ok then
  print(err)
  vim.cmd("cquit 1")
end

print("OK: explorer uses a 28-column floating layout")
vim.cmd("qa!")
