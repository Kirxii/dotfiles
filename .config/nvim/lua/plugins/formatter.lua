---@param bufnr integer
---@param ... string
---@return string
local function first(bufnr, ...)
	local conform = require("conform")
	for i = 1, select("#", ...) do
		local formatter = select(i, ...)
		if conform.get_formatter_info(formatter, bufnr).available then
			return formatter
		end
	end
	return select(1, ...)
end

return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },

	---@module "conform"
	---@type conform.setupOpts
	opts = {
		formatter_by_ft = {
			lua = { "stylua" },
			javascript = function(bufnr)
				return { first(bufnr, "prettierd", "prettier") }
			end,
			typescript = function(bufnr)
				return { first(bufnr, "prettierd", "prettier") }
			end,
		},
		default_format_opts = {
			lsp_format = "fallback",
		},
		format_on_save = { timeout_ms = 500 },
	},
}
