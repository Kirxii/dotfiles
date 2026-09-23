local M = {}

-- NOTE: Color format conversions
function M.dec_to_rgb(dec_color)
	-- Strict type checking
	local type = type(dec_color)
	if type ~= "number" then
		local msg = string.format("`color` type expected `number`, got `%s` instead", type)
		error(msg, 2)
	end

	local rgb = {}
	rgb.r = math.floor(dec_color / 0x10000) % 256
	rgb.g = math.floor(dec_color / 0x100) % 256
	rgb.b = dec_color % 256

	return rgb
end

function M.rgb_to_dec(rgb_color)
	-- Strict type checking
	local type = type(rgb_color)
	if type ~= "table" then
		local msg = string.format("`color` type expected `table`, got `%s` instead", type)
		error(msg, 2)
	end

	local dec = rgb_color.r * 0x10000 + rgb_color.g * 0x100 + rgb_color.b

	return dec
end

-- NOTE: Color transformations
function M.blend_colors(color1, color2, percentage)
	-- Clamp percentage between 0 and 1
	local t = math.max(0, math.min(1, percentage))

	-- Linear interpolation formula: a + (b - a) * t
	-- 1. Square the values to convert to linear space
	-- 2. Interpolate
	-- 3. Take the square root to convert back to gamma space
	-- 4. Round the number to the nearest integer
	local rgb = {}
	rgb.r = math.floor(math.sqrt((color1.r ^ 2) + ((color2.r ^ 2) - (color1.r ^ 2)) * t) + 0.5)
	rgb.g = math.floor(math.sqrt((color1.g ^ 2) + ((color2.g ^ 2) - (color1.g ^ 2)) * t) + 0.5)
	rgb.b = math.floor(math.sqrt((color1.b ^ 2) + ((color2.b ^ 2) - (color1.b ^ 2)) * t) + 0.5)

	return rgb
end

return M

-- NOTE: Type Definitions

---@alias Color string|integer|table # string to hex color code, color alias defined by heirline.load_colors() or fallback to vim standard color name; integer to 24-bit color.

---@class highlight
---@field fg? Color  The foreground color
---@field bg? Color  The background color
---@field sp? Color  The underline/undercurl color, if any
---@field bold? boolean
---@field italic? boolean
---@field reverse? boolean
---@field inverse? boolean
---@field standout? boolean
---@field underline? boolean
---@field undercurl? boolean
---@field underdouble? boolean
---@field underdotted? boolean
---@field underdashed? boolean
---@field strikethrough? boolean
---@field altfont? boolean
---@field nocombine? boolean
---@field ctermfg? HeirlineCtermColor  The foreground color
---@field ctermbg? HeirlineCtermColor  The background color
---@field cterm? HeirlineCtermStyle  The special style for cterm
---@field force? boolean  Control whether the parent's hl fields will override child's hl
