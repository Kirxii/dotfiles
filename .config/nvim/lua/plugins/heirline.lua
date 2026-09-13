return {
	"rebelot/heirline.nvim",
	event = { "VeryLazy" },

	dependencies = {
			"nvim-tree/nvim-web-devicons",
	},

	config = function()
		local conditions = require("heirline.conditions")
		local utils = require("heirline.utils")

		local function hl_swap(hl)
			if type(hl) ~= table then
				return "Nothing"
			end
		end

		local File = require("utils.heirline-components.File")

		require("heirline").setup({
			statusline = { File },
			winbar = {},
			tabline = {},
			statuscolumn = {},
		})
	end,
}
