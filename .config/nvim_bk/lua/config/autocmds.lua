-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- vim.api.nvim_set_hl(0, "Comment", { fg = "#828bb8", underline = false, bold = false })
-- vim.api.nvim_set_hl(0, "Comment", { fg = "#7ca1f2", underline = false, bold = false })
-- change color of diagnostic unnecessary tips
vim.api.nvim_set_hl(0, "DiagnosticUnnecessary", { fg = "#7a7f8c", underline = true, bold = false, italic = true })
vim.api.nvim_set_hl( 0, "LspInlayHint", { fg = "#7a7f8c", bg = "#262c40", underline = false, bold = false, italic = false })
vim.api.nvim_set_hl( 0, "@string.documentation.python", { fg = "#a9b1d6", underline = false, bold = false, italic = false })

-- already enabled in lazyvim
-- local _border = "rounded"
-- vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
--   border = _border,
-- })
-- vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
--   border = _border,
-- })
-- vim.diagnostic.config({
--   float = { border = _border },
-- })
