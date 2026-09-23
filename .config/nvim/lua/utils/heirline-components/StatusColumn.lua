local hl = require("utils.highlights")
local something = require("utils.string")

local function set_hl()
	for i = 1, 10 do
		local green_hl = hl.dec_to_rgb(COLORS.violet)
		local line_nr_hl = hl.dec_to_rgb(COLORS.line_nr)
		local color = hl.blend_colors(green_hl, line_nr_hl, i / 12)
		color = hl.rgb_to_dec(color)

		vim.api.nvim_set_hl(0, "LineNr" .. i, { fg = color })
	end
end
set_hl()

--[[ vim.api.nvim_create_autocmd("ColorScheme", {
  callback = set_hl(),
}) ]]

local StatusColumnNumber = {
	provider = function(self)
		local text = ""
		local highlight = ""

		local diagnostic = vim.diagnostic.get(0, { lnum = self.lnum - 1 })

		if diagnostic[1] then
			highlight = self.SEVERITY_HIGHLIGHT[diagnostic[1].severity]
		elseif self.is_current then
			highlight = "%#RainbowDelimiterViolet#"
		elseif self.relnum <= 10 then
			highlight = string.format("%%#LineNr%s#", self.relnum)
		end
		text = string.format("%%=%s%3s", highlight, self.num)

		return text
	end,
}

-- NOTE: Contains both the Separater line and Git state
local StatusColumnBorder = {
	provider = function(self)
		local highlight = ""

		local diagnostic = vim.diagnostic.get(0, { lnum = self.lnum - 1 })

		if diagnostic[1] then
			highlight = self.SEVERITY_HIGHLIGHT[diagnostic[1].severity]
		elseif self.is_current then
			highlight = "%#RainbowDelimiterViolet#"
		elseif self.relnum <= 10 then
			highlight = string.format("%%#LineNr%s#", self.relnum)
		end

		return highlight .. self.SEPARATOR .. " "
	end,
}

-- NOTE: Contains Dianostic Icons, Folds, and Marks
local StatusColumnSigns = {
	provider = function(self)
		--[[ function()
        local function format_text(t, k)
          local txt = (t and t[k]) and t[k]:gsub("%s", "") or ""
          if #txt < 1 then
            return
          end
          t[k] = txt
          return t
        end
        local function get_extmark_signs(buf, lnum)
          lnum = lnum - 1
          local signs = vim.api.nvim_buf_get_extmarks(
            buf,
            -1,
            { lnum, 0 },
            { lnum, -1 },
            { details = true, type = "sign" }
          )

          local sns = vim
            .iter(signs)
            :map(function(item)
              return format_text(item[4], "sign_text")
            end)
            :fold({ git = {}, other = {} }, function(acc, item)
              vim.print(item)
              local txt, hl = item.sign_text, item.sign_hl_group
              local is_git = hl:match("^Git")
              local target = is_git and acc.git or acc.other
              table.insert(target, { txt, hl })
              return acc
            end)
          if #sns.git == 0 then
            sns.git = { " " }
          end
          return sns.git, sns.other
        end

        vim.print(get_extmark_signs(0, vim.v.lnum))
      end ]]
		local function get_line_git_status(lnum)
			lnum = lnum or vim.fn.line(".")

			-- Retrieve all hunks for the current buffer
			local hunks = require("gitsigns").get_hunks()
			if not hunks then
				return "unc"
			end

			for _, hunk in ipairs(hunks) do
				-- For added or modified lines, check if the line falls within the hunk's range
				if lnum >= hunk.added.start and lnum <= (hunk.added.start + hunk.added.count - 1) then
					return hunk.type -- Returns "add" or "change"
				end

				-- Handles deleted lines immediately after or topdelete scenarios
				if hunk.type == "delete" and lnum == hunk.added.start then
					return "delete"
				end
			end

			return "unc"
		end

		return string.format("%%=%6s", get_line_git_status(self.lnum))
	end,
}

local StatusColumnModule = {
	init = function(self)
		self.lnum = vim.v.lnum
		self.relnum = vim.v.relnum
		self.is_current = self.relnum == 0
		self.is_in_range = self.relnum <= self.HIGHLIGHT_RANGE
		self.num = self.is_current and self.lnum or self.relnum

		function self.surround_hl(highlight)
			return string.format("%%#%s#", highlight)
		end

		function self.format_text(t, k)
			local txt = (t and t[k]) and t[k]:gsub("%s", "") or ""
			if #txt < 1 then
				return
			end
			t[k] = txt
			return t
		end
		function self.get_extmark_signs(buf, lnum)
			lnum = lnum - 1
			local signs = vim.api.nvim_buf_get_extmarks(
				buf,
				-1,
				{ lnum, 0 },
				{ lnum, -1 },
				{ details = true, type = "sign" }
			)

			local sns = vim.iter()
				:map(function(item)
					return self.format_text(item[4], "sign_text")
				end)
				:fold({ git = {}, other = {} }, function(acc, item)
					local text, highlight = item.sign_text, item.sign_hl_group
					local is_git = highlight:match("^Git")
					local target = is_git and acc.git or acc.other
					table.insert(target, { text, highlight })
					return acc
				end)
			if #sns.git == 0 then
				sns.git = { " " }
			end
			return sns.git, sns.other
		end
	end,
	static = {
		SEPARATOR = "╎",

		ACCENT_HIGHLIGHT = "RainbowDelimiterViolet",
		HIGHLIGHT_RANGE = 10,
		SEVERITY_HIGHLIGHT = {
			[1] = "%#DiagnosticSignError#",
			[2] = "%#DiagnosticSignWarn#",
			[3] = "%#DiagnosticSignInfo#",
			[4] = "%#DiagnosticSignHint#",
		},
	},

	StatusColumnNumber,
	-- StatusColumnSigns,
	StatusColumnBorder,
}

--[[ -- Helper to inspect signs on a specific line
-- Custom StatusColumn Component
M.custom_statuscol = {
  provider = function()
    local win = vim.g.statusline_winid or 0
    local buf = vim.api.nvim_win_get_buf(win)
    local lnum = vim.v.lnum
    local relnum = vim.v.relnum
    local is_current = (relnum == 0)

    -----------------------------------------------------------------------------
    -- 1. Combined Column (Git + Marks + Folds in 1 single column)
    -----------------------------------------------------------------------------
    local git_sign, mark_sign, fold_sign = get_line_signs(win, buf, lnum)
    local combined_symbol = " "
    local combined_hl = "LineNr"

    -- Determine displayed symbol & highlight priorities
    if mark_sign then
      combined_symbol = mark_sign.sign_text or "m"
      combined_hl = mark_sign.sign_hl_group or "DiagnosticSignInfo"
    elseif fold_sign then
      combined_symbol = fold_sign
      combined_hl = "FoldColumn"
    elseif git_sign then
      combined_symbol = git_sign.sign_text or "│"
      combined_hl = git_sign.sign_hl_group
    end

    -- Overlap override: If Git sign exists, override the symbol color with Git color
    if git_sign and (mark_sign or fold_sign) then
      combined_hl = git_sign.sign_hl_group
    end

    local combined_col = string.format("%%#%s#%s%%*", combined_hl, combined_symbol)

    -----------------------------------------------------------------------------
    -- 2. Right-Aligned Line Numbers (Absolute on current line, Relative on others)
    -----------------------------------------------------------------------------
    local num_str = is_current and tostring(lnum) or tostring(relnum)
    local num_hl = is_current and "CursorLineNr" or "LineNr"

    -- Right align to 3 spaces width (adjust width as needed)
    local num_col = string.format("%%#%s#%3s%%*", num_hl, num_str)

    -----------------------------------------------------------------------------
    -- 3. Sign Column (Highlighted by Line Number instead of icons)
    -----------------------------------------------------------------------------
    local sign_col_hl = is_current and "CursorLineNr" or "LineNr"
    local sign_col = string.format("%%#%s#▌%%*", sign_col_hl)

    return table.concat {
      combined_col, -- Git / Mark / Fold combined column
      " ",
      num_col, -- Right-aligned number line
      " ",
      sign_col, -- Sign column block highlight
      " ",
    }
  end,
}

function M.get_line_signs(win, buf, lnum)
  local git_sign, mark_sign, fold_sign = nil, nil, nil

  -- Fetch extmarks/placed signs for the line
  local extmarks = vim.api.nvim_buf_get_extmarks(
    buf,
    -1,
    { lnum - 1, 0 },
    { lnum - 1, -1 },
    { details = true }
  )

  for _, extmark in ipairs(extmarks) do
    local details = extmark[4]
    if details then
      -- Detect GitSigns
      if details.sign_hl_group and details.sign_hl_group:find("GitSigns") then
        git_sign = details
      -- Detect Marks
      elseif details.sign_text and details.sign_hl_group and details.sign_hl_group:find("Mark") then
        mark_sign = details
      end
    end
  end

  -- Detect Fold status
  if vim.fn.foldlevel(lnum) > vim.fn.foldlevel(lnum - 1) then
    fold_sign = " "
  end

  return git_sign, mark_sign, fold_sign
end ]]

return StatusColumnModule
