return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	build = ":TSUpdate",

	config = function(_, opts)
		local ts = require("nvim-treesitter")

		vim.api.nvim_create_autocmd("FileType", {
			pattern = "*",
			callback = function(args)
				local ft = vim.bo[args.buf].filetype
				local lang = vim.treesitter.language.get_lang(ft) or ft

				-- Check if Neovim already knows about / can load this parser
				if not vim.treesitter.language.add(lang) then
					local ts = require("nvim-treesitter")

					-- Verify the parser is actually supported by nvim-treesitter
					if vim.list_contains(ts.get_available(), lang) then
						-- Install it asynchronously
						ts.install(lang)
					end
				end

				-- Safely start treesitter highlighting once the parser attaches
				if vim.treesitter.language.add(lang) then
					vim.treesitter.start(args.buf, lang)
				end
			end,
			desc = "Auto-install Tree-sitter parser and enable highlighting for the filetype",
		})

		ts.install({
			"html",
			"css",
			"javascript",
			"jsx",
			"typescript",
			"tsx",
			"rust",
			"c",
			"cpp",
		})
	end,
}
