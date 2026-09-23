local M = {}

-- Delimiters and Surround functions
M.delimiters = {
	powerline = { left = "", right = "" },
	powerline_thin = { left = "", right = "" },
	rounded = { left = "", right = "" },
	slant = { left = "", right = "" },
	slant_upper = { left = "", right = "" },
	trap = { left = "", right = "" },
	block = { left = "█", right = "█" },
	none = { left = "", right = "" },
}

--- Select a delimiter set by key or return custom fallback
---@param name string Name of the preset (e.g., 'rounded', 'powerline')
---@return table { left: string, right: string }
function M.get_delimiters(name)
	return M.delimiters[name] or M.delimiters.none
end

function M.validate_spec(spec)
	vim.validate({
		spec = { spec, "table" },
	})

	-- Validate base highlight
	if spec.highlight ~= nil then
		local hl_type = type(spec.highlight)
		if hl_type ~= "table" and hl_type ~= "string" and hl_type ~= "function" then
			error("`highlight` must be a table, string, or function, got: " .. hl_type, 2)
		end
	end

	-- Helper to validate delimiter field
	local function validate_delimiter_field(delim, field_path)
		if delim == nil then
			return
		end
		local d_type = type(delim)

		if d_type == "table" then
			if type(delim.left) ~= "string" or type(delim.right) ~= "string" then
				error(field_path .. " table must contain 'left' and 'right' string fields", 2)
			end
		elseif d_type ~= "string" and d_type ~= "function" then
			error(field_path .. " must be a table, string, or function, got: " .. d_type, 2)
		end
	end

	-- Helper to validate side override delimiter field (string or function only)
	local function validate_side_delimiter_field(delim, field_path)
		if delim == nil then
			return
		end
		local d_type = type(delim)

		if d_type ~= "string" and d_type ~= "function" then
			error(field_path .. " must be a string or function, got: " .. d_type, 2)
		end
	end

	validate_delimiter_field(spec.delimiter, "`delimeter`")

	-- Validate side overrides (left / right)
	for _, side in ipairs({ "left", "right" }) do
		if spec[side] ~= nil then
			if type(spec[side]) ~= "table" then
				error("`" .. side .. "` override must be a table", 2)
			end
			if spec[side].highlight ~= nil then
				local hl_type = type(spec[side].highlight)
				if hl_type ~= "table" and hl_type ~= "string" and hl_type ~= "function" then
					error("`" .. side .. ".highlight` must be a table, string, or function", 2)
				end
			end
			validate_side_delimiter_field(spec[side].delimiter, "`" .. side .. ".delimiter`")
		end
	end
end

--[[ -- Helper: Unwrap functions
local function eval(val, context)
  if type(val) == "function" then
    return val(context)
  end
  return val
end

--- Resolves any spec variant into a consistent, concrete structure:
--- { left = { delimiter = string, highlight = table|string }, right = { ... } }
--- @param raw_spec table
--- @param context table|nil Context data passed to function-based values
--- @return table resolved
function M.resolve_spec(raw_spec, context)
  -- Step 1: Validate input
  M.validate_spec(raw_spec)

  context = context or {}

  -- Helper: Resolve delimiter specs into { left = "...", right = "..." }
  local function resolve_delimiter_pair(delim)
    delim = eval(delim, context)
    if type(delim) == "table" then
      return { left = delim.left, right = delim.right }
    elseif type(delim) == "string" then
      -- Preset keyword check
      if M.delimiters[delim] then
        return M.delimiters[delim]
      end
      -- Fallback: repeat string on both sides
      return { left = delim, right = delim }
    end
    return { left = "", right = "" }
  end

  -- Base resolution
  local base_hl = eval(raw_spec.highlight, context)
  local base_delims = resolve_delimiter_pair(raw_spec.delimiter)

  -- Resolve Left
  local left_hl = base_hl
  local left_delim = base_delims.left

  if raw_spec.left then
    if raw_spec.left.highlight ~= nil then
      -- Pass the side table or main table depending on your scope design
      left_hl = eval(raw_spec.left.highlight, context)
    end
    if raw_spec.left.delimiter ~= nil then
      left_delim = eval(raw_spec.left.delimiter, context)
    end
  end

  -- Resolve Right
  local right_hl = base_hl
  local right_delim = base_delims.right

  if raw_spec.right then
    if raw_spec.right.highlight ~= nil then
      right_hl = eval(raw_spec.right.highlight, context)
    end
    if raw_spec.right.delimiter ~= nil then
      right_delim = eval(raw_spec.right.delimiter, context)
    end
  end

  return {
    left = { delimiter = left_delim, highlight = left_hl },
    right = { delimiter = right_delim, highlight = right_hl },
  }
end ]]

local function eval(val, self)
	if type(val) == "function" then
		return val(self)
	end
	return val
end

function M.surround(delimiters, highlight, component)
	-- delimiters = M.resolve_spec(delimiters, context)
	local surrounded_component = {}

	table.insert(surrounded_component, {
		provider = M.get_delimiters(delimiters.left.delimiter).left,
		hl = function(self)
			local color = eval(delimiters.left.highlight, self)
			if color then
				return color
			end
		end,
	})

	table.insert(surrounded_component, {
		component,
		hl = function(self)
			local color = eval(highlight, self)
			if color then
				return color
			end
		end,
	})

	table.insert(surrounded_component, {
		provider = M.get_delimiters(delimiters.right.delimiter).right,
		hl = function(self)
			local color = eval(delimiters.right.highlight, self)
			if color then
				return color
			end
		end,
	})

	return surrounded_component
end

-- Color utility function
-- Might seperate this if I have more plugins utilizing this

--- Swap the foreground and the background of a highlight table
---@param hl table Neovim's highlight color table
---@return table { bg: string, fg: string, ... }
function M.swap_hl(hl)
	local swapped_hl = { fg = hl.bg or "", bg = hl.fg or "" }
	return vim.tbl_deep_extend("force", {}, hl, swapped_hl)
end

return M
