local title = [[
 竹杖芒鞋轻胜马，一蓑烟雨任平生
]]

local header = require("utils.ascii_pic").random_logo()
local image_preview = require("utils.image_preview")

local function get_sections()
  local sections = {}
  if header.type == "line" then
    sections = {
      {
        pane = 1,
        section = "header",
      },
      { pane = 1, section = "keys", gap = 1, padding = 1 },
      { pane = 1, section = "startup", padding = 1 },
    }
  elseif header.type == "image" then
    local lines = vim.split(header.text, "\n", { trimempty = true })
    local top = math.floor(#lines / 2) - 10

    if top <= 0 then
      sections = {
        { pane = 1, section = "header" },
        { pane = 2, section = "keys", gap = 1, padding = 1 },
        { pane = 2, section = "startup", padding = 1 },
      }
    elseif top > 10 then
      sections = {
        { pane = 2, section = "startup", padding = 1 },
        { pane = 1, section = "header" },
        { pane = 2, icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
        { pane = 2, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
        { pane = 2, section = "keys", gap = 1, padding = 1, align = "left" },
      }
    elseif top > 5 then
      sections = {
        { pane = 2, section = "startup", padding = 1 },
        { pane = 1, section = "header" },
        { pane = 2, icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
        { pane = 2, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
        { pane = 2, section = "keys", gap = 1, padding = 1, align = "left" },
      }
    elseif top > 0 then
      sections = {
        { pane = 2, section = "startup", padding = 1 },
        { pane = 1, section = "header" },
        { pane = 2, icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
        { pane = 2, section = "keys", gap = 1, padding = 1, align = "left", height = 100 },
      }
    end
  end
  return sections
end

return {
  {
    "folke/snacks.nvim",
    ---@type snacks.Config
    opts = {
      dashboard = {
        preset = {
          header = header.text .. "\n" .. title,
        },
        sections = get_sections(),
      },
      picker = {
        enabled = true,
        sources = {
          files = {
            ignored = true,
            hidden = true,
          },
          explorer = {
            ignored = true,
            hidden = true,
            actions = {
              explorer_confirm = function(picker, item, action)
                if not item then
                  return
                elseif picker.input.filter.meta.searching then
                  require("snacks.explorer.actions").update(picker, { target = item.file })
                elseif item.dir then
                  require("snacks.explorer.tree"):toggle(item.file)
                  require("snacks.explorer.actions").update(picker, { refresh = true })
                elseif image_preview.is_supported(item.file) then
                  image_preview.open(item.file)
                else
                  Snacks.picker.actions.jump(picker, item, action)
                end
              end,
            },
            win = {
              list = {
                keys = {
                  ["<CR>"] = "explorer_confirm",
                  ["l"] = "explorer_confirm",
                },
              },
            },
          },
        },
      },
      explorer = {
        enabled = true,
      },
      words = {
        enabled = true,
      },
    },
    keys = {
      { "<leader>;", "<cmd>Dashboard<CR>", desc = "Dashboard" },
    },
  },
}
