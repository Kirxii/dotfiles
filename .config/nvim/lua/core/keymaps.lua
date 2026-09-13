local keyset = vim.keymap.set

local silent = function(desc)
	return { silent = true, remap = false, desc = desc }
end
local expr = function(desc)
	return { silent = true, expr = true, remap = false, desc = desc }
end

keyset("n", "<leader>;", "<cmd>Lazy<cr>")

-- Insert mode QoLs
keyset("i", "<cr>", function()
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

--- Smart entry into insert mode on blank lines
--- @param key string "i" or "a"
local function smart_insert(key)
	return function()
		local line = vim.api.nvim_get_current_line()
		if line:find("^%s*$") then
			return '"_cc'
		end
		return key
	end
end

-- Map 'i' and 'a' in normal mode to auto-indent blank lines
keyset("n", "i", smart_insert("i"), { expr = true, noremap = true, desc = "Smart insert with auto-indent" })
keyset("n", "a", smart_insert("a"), { expr = true, noremap = true, desc = "Smart append with auto-indent" })

--- Smart Tab handler compatible with tabout.nvim and completion plugins
keyset("i", "<tab>", function()
	local line = vim.api.nvim_get_current_line()
	local col = vim.api.nvim_win_get_cursor(0)[2]
	local before_cursor = line:sub(1, col)

	-- If the line is blank or only contains whitespace before cursor, indent properly
	if before_cursor:match("^$") then
		return "<C-f>" -- Triggers Neovim's auto-indent calculation for the line
	end

	return "<Plug>(Tabout)"
end, { expr = true, remap = false, desc = "Smart Tab / Tabout" })

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
