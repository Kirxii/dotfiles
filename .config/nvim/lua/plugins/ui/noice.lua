return {
	"folke/noice.nvim",
	lazy = false,
	event = "VeryLazy",
	keys = {
		{
			"<leader>nd",
			"<cmd>NoiceDismiss<cr>",
			desc = "Dismiss",
		},
		{
			"<leader>na",
			"<cmd>NoiceAll<cr>",
			desc = "See all notifications",
		},
		{
			"<leader>ne",
			"<cmd>NoiceError<cr>",
			desc = "See all errors",
		},
		{
			"<leader>nl",
			"<cmd>NoiceLog<cr>",
			desc = "See all logs",
		},
	},

	dependencies = {
		-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
		"MunifTanjim/nui.nvim",
		-- OPTIONAL:
		--   `nvim-notify` is only needed, if you want to use the notification view.
		--   If not available, we use `mini` as the fallback
		"rcarriga/nvim-notify",
	},

	opts = {
		lsp = {
			override = {
				-- Disable this if documentation lines are joining together
				["vim.lsp.util.convert_input_to_markdown_lines"] = false,
				["vim.lsp.util.stylize_markdown"] = false,
			},
		},
	},
}
