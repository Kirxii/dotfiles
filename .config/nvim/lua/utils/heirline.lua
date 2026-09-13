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

function M.surround(delimiters_name, highlight_color, component, half)
  local delims = M.get_delimiters(delimiters_name)
  local swap = M.swap_hl

  local surrounded_component = {}
  if half ~= "tail" then
    table.insert(surrounded_component, {
      provider = delims.left,
      hl = function(self)
        local highlight =
          swap((type(highlight_color) == "function" and highlight_color(self)) or highlight_color)
        return highlight
      end,
    })
  end
  table.insert(surrounded_component, {
    hl = function(self)
      local highlight = (type(highlight_color) == "function" and highlight_color(self))
        or highlight_color
      return highlight
    end,
    component,
  })
  if half ~= "head" then
    table.insert(surrounded_component, {
      provider = delims.right,
      hl = function(self)
        local highlight =
          swap((type(highlight_color) == "function" and highlight_color(self)) or highlight_color)
        return highlight
      end,
    })
  end

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
