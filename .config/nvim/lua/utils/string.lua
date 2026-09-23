local M = {}

--- comment
---
---
--- new line
function M.insert(str, ...)
	for _, value in ipairs({ ... }) do
		str = str .. value
	end
	return str
end

local str = "Hello"
string.insert = M.insert

return M
