-- NOTE: This is for global highlight creation or modification
vim.api.nvim_set_hl(0, "DiagnosticError", {
	fg = 0xdb4b4b,
	bold = true,
})
vim.api.nvim_set_hl(0, "DiagnosticWarn", {
	fg = 0xe0af68,
	bold = true,
})
vim.api.nvim_set_hl(0, "DiagnosticHint", {
	fg = 0x1abc9c,
	bold = true,
})
vim.api.nvim_set_hl(0, "DiagnosticInfo", {
	fg = 0x0db9d7,
	bold = true,
})
