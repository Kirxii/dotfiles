return {
	"SuperBo/fugit2.nvim",
	build = false,
	cmd = { "Fugit2", "Fugit2Diff", "Fugit2Graph", "Fugit2Rebase" },
	keys = {
		{ "<leader>f", mode = "n", "<cmd>Fugit2<cr>" },
	},

	dependencies = {
		"MunifTanjim/nui.nvim",
		"nvim-tree/nvim-web-devicons",
		"nvim-lua/plenary.nvim",
		{
			"chrisgrieser/nvim-tinygit", -- optional: for Github PR view
			dependencies = { "stevearc/dressing.nvim" },
		},
	},

	opts = {
		width = 100,
	},
}
