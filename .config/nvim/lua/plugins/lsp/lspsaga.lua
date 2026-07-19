return {
	"nvimdev/lspsaga.nvim",
	keys = {
		{ "K", ":Lspsaga hover_doc<cr>", desc = "Hover Documentation", silent = true },
	},

	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
	},

	opts = {
		symbol_in_winbar = {
			folder_level = 2,
		},
		lightbulb = {
			enabled = true,
			sign = false,
			virtual_text = true,
		},
		ui = {
			code_action = " 󱐋",
		},
	},
}
