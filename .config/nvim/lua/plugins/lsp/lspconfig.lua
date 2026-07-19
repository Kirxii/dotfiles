return {
	"neovim/nvim-lspconfig",
	lazy = false,
	dependencies = {
		"saghen/blink.cmp",
	},

	config = function()
		-- Your LSP settings here
		local capabilities = require("blink.cmp").get_lsp_capabilities()
		local lspconfig = vim.lsp.config

		lspconfig("clangd", {
			capabilities = capabilities,
			on_attach = function()
				vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = 0 })
			end,
		})
	end,
}
