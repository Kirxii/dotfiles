return {
	{
		"windwp/nvim-autopairs",
		event = { "BufReadPre", "BufNewFile" },

		opts = {
			map_bs = false,
		},
	},
	{
		"fell-z/nvim-treesitter-endwise",
		event = { "BufReadPre", "BufNewFile" },
	},
	{
		"windwp/nvim-ts-autotag",
		event = { "BufReadPre", "BufNewFile" },

		opts = {},
	},
	{
		"kylechui/nvim-surround",
		version = "^4.0.0", -- Use for stability; omit to use `main` branch for the latest features
		event = { "BufReadPre", "BufNewFile" },

		opts = {},
	},
	{
		"HiPhish/rainbow-delimiters.nvim",
		event = { "BufReadPre", "BufNewFile" },
	},
	{
		-- Allows tab to exit out of parenthesises
		"abecodes/tabout.nvim",
		event = { "InsertEnter" },

		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},

		opts = {
			tabkey = "<Tab>",
			backwards_tabkey = "<S-Tab>",
			act_as_tab = true,
			act_as_shift_tab = true,
			default_tab = "<C-t>",
			default_shift_tab = "<C-d>",
			enable_backwards = true,
			completion = true,
			tabouts = {
				{ open = "'", close = "'" },
				{ open = '"', close = '"' },
				{ open = "`", close = "`" },
				{ open = "(", close = ")" },
				{ open = "[", close = "]" },
				{ open = "{", close = "}" },
				{ open = "<", close = ">" },
			},
			ignore_beginning = false,
			exclude = {},
		},
	},
}
