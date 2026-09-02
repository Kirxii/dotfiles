local keyset = vim.keymap.set

local silent = function(desc)
	return { silent = true, remap = false, desc = desc }
end
local expr = function(desc)
	return { silent = true, expr = true, remap = false, desc = desc }
end

vim.keymap.set("i", "<cr>", function()
	-- Get the current line text and cursor position
	local line = vim.api.nvim_get_current_line()
	local col = vim.api.nvim_win_get_cursor(0)[2]

	-- Fetch comment string for the current buffer
	local commentstring = vim.bo.commentstring
	if commentstring and commentstring ~= "" then
		-- Clean the template (e.g., convert "/* %s */" or "# %s" to literal text pattern)
		local cleaned_comment = commentstring:gsub("%%s", ""):gsub("%s+", "")
		-- Escape magic characters for lua pattern matching
		local pattern = "^%s*" .. cleaned_comment:gsub("([^%w])", "%%%1") .. "%s*$"

		-- If line matches an empty comment, clear line and move down
		if string.match(line, pattern) and col <= #line then
			return "<C-u>"
		end
	end

	-- Fallback to default Enter behavior
	return "<CR>"
end, { expr = true, replace_keycodes = true, desc = "Clear empty comment on Enter" })

-- Marks
keyset("n", "<leader>m", "`", silent("Marks"))

-- Wrapping movements
keyset({ "n", "v" }, "j", "(v:count == 0 ? 'gj' : 'j')", expr())
keyset({ "n", "v" }, "k", "(v:count == 0 ? 'gk' : 'k')", expr())
keyset({ "n", "v" }, "<DOWN>", "(v:count == 0 ? 'gj' : 'j')", expr())
keyset({ "n", "v" }, "<UP>", "(v:count == 0 ? 'gk' : 'k')", expr())
keyset({ "n", "v" }, "^", "(v:count == 0 ? 'g^' : '^')", expr())
keyset({ "n", "v" }, "0", "(v:count == 0 ? 'g0' : '0')", expr())
keyset({ "n", "v" }, "$", "(v:count == 0 ? 'g$' : '$')", expr())

-- Window movement
keyset("n", "<c-h>", "<c-w>h", silent())
keyset("n", "<c-j>", "<c-w>j", silent())
keyset("n", "<c-k>", "<c-w>k", silent())
keyset("n", "<c-l>", "<c-w>l", silent())

keyset("n", "<leader>qq", ":qa<CR>", silent("Quit Neovim"))
keyset("t", "<esc>", "<c-\\><c-n>", silent())

-- Command mode navigation
keyset("c", "<c-h>", "<left>")
keyset("c", "<c-l>", "<right>")
