local read_file = function(directory)
	local content = ""
	local lines = io.lines(directory)

	for line in lines do
		content = content .. line .. "\n"
	end
	string.gsub(content, "\n+$", "")

	return content
end

return {
	"catppuccin/nvim",
	priority = 999,

	config = function()
		local file = read_file(vim.fn.stdpath("config") .. "/lua/core/colorscheme")
		local colorscheme = string.match(file, "[%l%p]+$") or "catppuccin-mocha"
		vim.cmd("colorscheme " .. colorscheme)
	end
}
