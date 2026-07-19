return {
	"nvimdev/dashboard-nvim",
	event = "VimEnter",

	dependencies = { "nvim-tree/nvim-web-devicons" },

	opts = {
		config = {
			project = {
				enable = true,
				limit = 8,
				label = "Projects",
				action = "FzfLua files cwd=",
			},
		},
	},
}
