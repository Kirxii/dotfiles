return {
	"folke/snacks.nvim",
	lazy = false,
	keys = {
		{
			"<leader>gg",
			function()
				Snacks.lazygit()
			end,
			desc = "Lazygit",
		},
	},

	---@type snacks.Config
	opts = {
		-- dashboard = require("snacks-configs.dashboard"),
		indent = require("snacks-configs.indent"),
		lazygit = require("snacks-configs.lazygit"),
		picker = require("snacks-configs.picker"),
		quickfile = require("snacks-configs.quickfile"),
	},
}
