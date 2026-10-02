return {
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
