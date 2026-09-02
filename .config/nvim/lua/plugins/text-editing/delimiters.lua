return {
	{
		"windwp/nvim-autopairs",
		event = { "BufReadPre", "BufNewFile" },

		opts = {
			map_bs = true,
		},
		config = function(_, opts)
			local npairs = require("nvim-autopairs")
			npairs.setup(opts)

			-- endwise combatibility
			npairs.add_rules(require("nvim-autopairs.rules.endwise-elixir"))
			npairs.add_rules(require("nvim-autopairs.rules.endwise-lua"))
			npairs.add_rules(require("nvim-autopairs.rules.endwise-ruby"))
		end,
	},
	{
		"windwp/nvim-ts-autotag",
		event = { "BufReadPre", "BufNewFile" },

		opts = {},
	},
	{
		"HiPhish/rainbow-delimiters.nvim",
		event = { "BufReadPre", "BufNewFile" },
	},
}
