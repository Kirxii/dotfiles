return {
	{
		-- The presentation of the indentation, even with blanklines
		"lukas-reineke/indent-blankline.nvim",
		event = "BufReadPre",
		main = "ibl",

		---@module "ibl"
		---@type ibl.config
		opts = {
			scope = { enabled = false },
			indent = {
				char = "│",
				highlight = "LineNr",
				priority = 10000,
				smart_indent_cap = true,
			},
			exclude = {
				filetypes = {
					"dashboard",
				},
			},
		},
	},
	{
		-- Smartly guess the indent style and adjust the tabbing
		"nmac427/guess-indent.nvim",
		event = "BufReadPre",

		opts = {},
	},
	{
		"qwavies/smart-backspace.nvim",
		event = { "InsertEnter", "CmdlineEnter" },

		opts = {},
	},
}
