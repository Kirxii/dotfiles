return {
	"rachartier/tiny-inline-diagnostic.nvim",
	event = "VeryLazy",
	priority = 1000,

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
