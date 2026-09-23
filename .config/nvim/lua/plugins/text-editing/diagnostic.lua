return {
	"rachartier/tiny-inline-diagnostic.nvim",
	event = "VeryLazy",
	keys = {
		{
			"<leader>dt",
			"<cmd>TinyInlineDiag toggle<cr>",
			desc = "Toggle diagnostics (all)",
		},
		{
			"<leader>dT",
			"<cmd>TinyInlineDiag toggle_cursor<cr>",
			desc = "Toggle diagnostics (cursor)",
		},
	},

	opts = {
		transparent_bg = false,
		transparent_cursorline = true,

		hi = {
			arrow = "CursorLineNr",
			background = "Normal",
		},

		options = {
			set_arrow_to_diag_color = false,
			add_message = {
				messages = true,
				display_count = true,
				use_max_severity = true,
				show_multiple_glyphs = true,
			},
			multilines = {
				enabled = true,
			},
		},
	},
	config = function(_, opts)
		require("tiny-inline-diagnostic").setup(opts)
		vim.diagnostic.config({ virtual_text = false }) -- Disable Neovim's default virtual text diagnostics
	end,
}
