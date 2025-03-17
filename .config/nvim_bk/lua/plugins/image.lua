return {
  -- {
  --   "edluffy/hologram.nvim",
  --   -- ft = "image",
  --   config = function()
  --     require("hologram").setup({ auto_display = true })
  --   end,
  -- },
  {
    "3rd/image.nvim",
    event = "VeryLazy",
    config = function()
      require("image").setup()
    end,
  },
  {
    "adelarsq/image_preview.nvim",
    event = "VeryLazy",
    config = function()
      require("image_preview").setup()
    end,
  },
}
