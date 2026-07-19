---@diagnostic disable: missing-fields

return {
	{
		-- Main pairing plugins
		"altermo/ultimate-autopair.nvim",
		event = { "InsertEnter", "CmdlineEnter" },
		branch = "v0.6",

		opts = {},
	},

	-- NOTE: Treesitter extension
	{
		-- Allows tab to exit out of parenthesises
		"abecodes/tabout.nvim",
		lazy = false,
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"hrsh7th/nvim-cmp",
		},

		opts = {
			tabkey = "<Tab>",
			backwards_tabkey = "<S-Tab>",
			act_as_tab = true,
			act_as_shift_tab = true,
			default_tab = "<C-t>",
			default_shift_tab = "<C-d>",
			enable_backwards = true,
			completion = false,
			tabouts = {
				{ open = "'", close = "'" },
				{ open = '"', close = '"' },
				{ open = "`", close = "`" },
				{ open = "(", close = ")" },
				{ open = "[", close = "]" },
				{ open = "{", close = "}" },
			},
			ignore_beginning = true,
			exclude = {},
		},
	},

	-- NOTE: Treesitter	extension
	{
		-- Editing HTML tags
		"windwp/nvim-ts-autotag",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},

		opts = {
			opts = {
				enable_close = true,
				enable_rename = true,
				enable_close_on_slash = true,
			},

			per_filetype = {},
			aliases = {},
		},
	},

	-- NOTE: Treesitter extension
	{
		-- Support for Lua, Ruby, Vimscript, etc "end" for functions, classes and more
		"RRethy/nvim-treesitter-endwise",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},

		config = function()
			-- require("nvim-treesitter.configs").setup({
			-- 	endwise = {
			-- 		enable = true,
			-- 	},
			-- })
		end,
	},

	{
		"kylechui/nvim-surround",
		version = "^3.0.0", -- Use for stability; omit to use `main` branch for the latest features
		event = "VeryLazy",

		opts = {},
	},
}
