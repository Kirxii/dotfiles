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
		-- Automatically adjust to the previous line's indent level
		"vidocqh/auto-indent.nvim",
		event = "BufReadPre",

		opts = {
			lightmode = true,
			ignore_filetype = {},
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
