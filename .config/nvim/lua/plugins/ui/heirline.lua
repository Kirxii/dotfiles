-- NOTE: lsp-saga has heirline as its dependencies so there's no error on startup

---@class HL
---@field fg string Foreground highlight color
---@field bg string Background highlight color
---@field sp string Underline/Undercurl highlight color
---@field bold boolean Does the provider have bold format
---@field underline boolean Does the provider have underline format
---@field force boolean Should the parent's hl field override the child's hl field

---@alias DELIMITERS { [1]: string, [2]: string }

return {
	"rebelot/heirline.nvim",

	dependencies = {
		{
			"linrongbin16/commons.nvim",
			commit = "592432b",
		},
	},

	opts = function()
		-- Snippets
		local align = { provider = "%=" }
		local space = { provider = " " }
		local round = { "", "" }
		local half = { opening = { provider = "▐" }, closing = { provider = "▌" } }
		local full = { opening = { provider = "█" }, closing = { provider = "█" } }

		-- Utils
		local utils = require("heirline.utils")
		local conditions = require("heirline.conditions")
		local bit = require("bit")

		local hl = require("commons.color.hl")
		local nil_highl = hl.get_hl
		local fal_highl = hl.get_hl_with_fallback
		local nil_color = hl.get_color
		local fal_color = hl.get_color_with_fallback

		local get_hi = utils.get_highlight
		local setup_colors = function()
			local colors = {
				-- stylua: ignore start
				background    = nil_color("Normal", "bg"),
				color_column  = get_hi("ColorColumn").bg,
				pmenu         = get_hi("PMenu").bg,
				normal        = get_hi("Normal").fg,
				tabline       = get_hi("TabLine").bg,
				statusline    = get_hi("StatusLine").bg,

				string        = fal_color({ "String", "Normal" }, "fg"),
				func          = fal_color({ "Function", "Normal" }, "fg"),
				type          = fal_color({ "Type", "Normal" }, "fg"),
				debug         = fal_color({ "Debug", "Normal" }, "fg"),
				comment       = fal_color({ "Comment", "Normal" }, "fg"),
				directory     = fal_color({ "Directory", "Normal" }, "fg"),
				constant      = fal_color({ "Constant", "Normal" }, "fg"),
				statement     = fal_color({ "Statement", "Normal" }, "fg"),
				special       = fal_color({ "Special", "Normal" }, "fg"),
				tabline_sel   = fal_color({ "TabLineSel", "Visual" }, "bg"),

				diag_warn_fg  = fal_color({ "DiagnosticVirtualTextWarn", "Normal" }, "fg"),
				diag_warn_bg  = fal_color({ "DiagnosticVirtualTextWarn", "Normal" }, "bg"),
				diag_error_fg = fal_color({ "DiagnosticVirtualTextError", "Normal" }, "fg"),
				diag_error_bg = fal_color({ "DiagnosticVirtualTextError", "Normal" }, "bg"),
				diag_hint_fg  = fal_color({ "DiagnosticVirtualTextHint", "Normal" }, "fg"),
				diag_hint_bg  = fal_color({ "DiagnosticVirtualTextHint", "Normal" }, "bg"),
				diag_info_fg  = fal_color({ "DiagnosticVirtualTextInfo", "Normal" }, "fg"),
				diag_info_bg  = fal_color({ "DiagnosticVirtualTextInfo", "Normal" }, "bg"),
				diag_ok_fg    = fal_color({ "DiagnosticVirtualTextOk", "Normal" }, "fg"),
				diag_ok_bg    = fal_color({ "DiagnosticVirtualTextOk", "Normal" }, "bg"),

				git_del       = get_hi("GitsignsDelete").fg or get_hi("DiffRemoved").fg or get_hi("DiffDelete").bg,
				git_add       = get_hi("GitsignsAdd").fg or get_hi("DiffAdded").fg or get_hi("DiffAdded").bg,
				git_change    = get_hi("GitsignsChange").fg or get_hi("DiffChange").fg or get_hi("DiffChange").bg,

				-- NOTE: HiPhish/rainbow-delimiters.nvim dependency
				red           = fal_color("RainbowDelimiterRed", "fg", "#ff0000"),
				orange        = fal_color("RainbowDelimiterOrange", "fg", "#ff8800"),
				yellow        = fal_color("RainbowDelimiterYellow", "fg", "#ffff00"),
				green         = fal_color("RainbowDelimiterGreen", "fg", "#00ff00"),
				cyan          = fal_color("RainbowDelimiterCyan", "fg", "#00ffff"),
				blue          = fal_color("RainbowDelimiterBlue", "fg", "#0000ff"),
				violet        = fal_color("RainbowDelimiterViolet", "fg", "#ff00ff"),
				-- stylua: ignore end
			}

			return colors
		end

		utils.on_colorscheme(setup_colors)
		vim.api.nvim_create_augroup("Heirline", { clear = true })
		vim.api.nvim_create_autocmd("ColorScheme", {
			callback = function()
				utils.on_colorscheme(setup_colors)
			end,
			group = "Heirline",
		})

		--- Convert a hex colour string (“#RRGGBB”) to its numeric RGB components.
		---@param hex string The colour, e.g. "#ff8800"
		---@return number r, number g, number b   Values in the range 0‑255
		local function hex_to_rgb(hex)
			-- Strip the leading “#” if present
			hex = hex:gsub("^#", "")
			assert(#hex == 6, "hex colour must be 6 digits")
			local r = tonumber(hex:sub(1, 2), 16)
			local g = tonumber(hex:sub(3, 4), 16)
			local b = tonumber(hex:sub(5, 6), 16)
			return r, g, b
		end

		--- Compute the relative luminance of an sRGB colour.
		--- Uses the ITU‑BT.709 formula (the same one browsers use for contrast).
		---@param r number Red   0‑255
		---@param g number Green 0‑255
		---@param b number Blue  0‑255
		---@return number luminance 0‑1
		local function luminance(r, g, b)
			-- Normalise to 0‑1 and linearise each channel
			local function linear(c)
				c = c / 255
				return (c <= 0.03928) and (c / 12.92) or ((c + 0.055) / 1.055) ^ 2.4
			end
			r, g, b = linear(r), linear(g), linear(b)
			return 0.2126 * r + 0.7152 * g + 0.0722 * b
		end

		--- Return either black (“#000000”) or white (“#ffffff”) depending on which
		--- provides better contrast against the supplied background colour.
		---@param bg_hex string Background colour as “#RRGGBB”
		---@return string fg_hex Contrasting colour as “#RRGGBB”
		local function contrasting_color(bg_hex)
			local r, g, b = hex_to_rgb(bg_hex)
			local lum = luminance(r, g, b)

			-- WCAG recommends a threshold of 0.179 for black vs. white contrast.
			-- Below that we pick white, otherwise black.
			if lum > 0.179 then
				return "#000000" -- dark text on light bg
			else
				return "#ffffff" -- light text on dark bg
			end
		end

		-- Conditions
		local is_file_buffer = function(buffer)
			return not conditions.buffer_matches({
				buftype = { "nofile", "prompt", "help", "quickfix" },
			}, buffer or 0)
		end
		local is_active_buffer = conditions.is_active
		local has_repo_buffer = conditions.is_git_repo
		local has_diagnostic_buffer = conditions.has_diagnostics
		local has_lsp_buffer = conditions.lsp_attached

		-- Components
		local ModeName = {
			-- stylua: ignore start
			["n"]     = "Normal",
			["no"]    = "O-Pending",
			["nov"]   = "O-Pending",
			["noV"]   = "O-Pending",
			["no\22"] = "O-Pending",
			["niI"]   = "Normal",
			["niR"]   = "Normal",
			["niV"]   = "Normal",
			["nt"]    = "Normal",
			["ntT"]   = "Normal",
			["v"]     = "Visual",
			["vs"]    = "Visual",
			["V"]     = "V-Line",
			["Vs"]    = "V-Line",
			["\22"]   = "V-Block",
			["\22s"]  = "V-Block",
			["s"]     = "Select",
			["S"]     = "S-Line",
			["\19"]   = "S-Block",
			["i"]     = "Insert",
			["ic"]    = "Insert",
			["ix"]    = "Insert",
			["R"]     = "Replace",
			["Rc"]    = "Replace",
			["Rx"]    = "Replace",
			["Rv"]    = "V-Replace",
			["Rvc"]   = "V-Replace",
			["Rvx"]   = "V-Replace",
			["c"]     = "Command",
			["cv"]    = "Ex",
			["ce"]    = "Ex",
			["r"]     = "Replace",
			["rm"]    = "More",
			["r?"]    = "Confirm",
			["!"]     = "Shell",
			["t"]     = "Terminal",
			-- stylua: ignore end
		}

		local ModeColors = {
			-- stylua: ignore start
			["n"]   = "blue",
			["i"]   = "green",
			["v"]   = "cyan",
			["V"]   = "cyan",
			["\22"] = "cyan",
			["c"]   = "yellow",
			["s"]   = "orange",
			["S"]   = "orange",
			["\19"] = "orange",
			["R"]   = "red",
			["r"]   = "red",
			["!"]   = "red",
			["t"]   = "blue",
			-- stylua: ignore end
		}

		local ModeDisplay = {
			provider = function(self)
				local mode = self.mode
				return "󰻂 " .. ModeName[mode]
			end,
			hl = function(self)
				local modeShort = self.mode:sub(1, 1)
				return {
					fg = "background",
					bg = ModeColors[modeShort],
					bold = true,
				}
			end,
		}

		local Mode = {
			init = function(self)
				self.mode = vim.fn.mode(1)
			end,

			update = {
				"ModeChanged",
				pattern = "*:*",
				callback = vim.schedule_wrap(function()
					vim.cmd("redrawstatus")
				end),
			},

			round["opening"],
			ModeDisplay,
			round["closing"],
			space,

			hl = function(self)
				local modeShort = self.mode:sub(1, 1)
				return {
					fg = ModeColors[modeShort],
					bg = "background",
				}
			end,
		}

		local FileIcon = {
			init = function(self)
				self.icon, self.iconColor =
					require("nvim-web-devicons").get_icon_color(self.filename, self.fileextension, { default = true })
				if self.filename == "" then
					self.icon = ""
				end
			end,

			{
				hl = function(self)
					return { fg = self.iconColor, bg = "background" }
				end,
				provider = round[1],
			},
			{
				hl = function(self)
					return { fg = contrasting_color(self.iconColor), bg = self.iconColor, bold = true }
				end,

				{
					provider = function(self)
						return self.icon
					end,
				},
				{
					provider = function(self)
						local filesize = self.filesize
						local suffixes = { "B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB" } -- Good luck surpassing TB

						if type(filesize) ~= "number" or filesize <= 0 then
							return ""
						end

						local suffix = 1
						while filesize > 1024 do
							filesize = filesize / 1024
							suffix = suffix + 1
						end
						filesize = tonumber(string.format("%.1f", filesize))

						return " " .. filesize .. suffixes[suffix]
					end,
					condition = function(self)
						return type(self.filesize) == "number"
					end,
				},
			},
			{
				hl = function(self)
					return { fg = self.iconColor, bg = "color_column" }
				end,
				provider = round[2],
			},
		}

		local FileName = {
			provider = function(self)
				if self.filename == "" then
					return "Unnamed File"
				end

				return self.filename
			end,
			hl = function(self)
				if self.modified or self.unmodifiable then
					return { fg = "yellow", bg = "color_column" }
				else
					return { fg = "normal", bg = "color_column" }
				end
			end,
		}

		local FileSavedFlag = {
			condition = function(self)
				return not self.modified
			end,

			provider = " ",

			hl = { fg = "green", bg = "color_column" },
		}

		local FileModifiedFlag = {
			condition = function(self)
				return self.modified
			end,

			provider = " ",

			hl = { fg = "yellow", bg = "color_column" },
		}

		local FileUnmodifiableFlag = {
			condition = function(self)
				return self.unmodifiable
			end,

			provider = " ",

			hl = { fg = "red", bg = "color_column" },
		}

		local FileModule = {
			init = function(self)
				self.filepath = vim.api.nvim_buf_get_name(0)
				self.filename = vim.fn.fnamemodify(self.filepath, ":t")
				self.filedirectory = vim.fn.fnamemodify(self.filepath, ":h")
				self.fileextension = vim.fn.fnamemodify(self.filepath, ":e")

				self.filesize = vim.fn.getfsize(self.filepath)

				self.modified = vim.bo.modified
				self.unmodifiable = not vim.bo.modifiable or vim.bo.readonly
			end,

			hl = { fg = "color_column", bg = "background" },

			FileIcon,
			{ hl = { bg = "color_column" }, space },
			FileName,
			FileSavedFlag,
			FileModifiedFlag,
			FileUnmodifiableFlag,
			{ provider = round[2] },
			space,
		}

		local GitBranch = {
			provider = function(self)
				return " " .. self.status_dict.head
			end,
			hl = { fg = "normal", bold = true },
		}

		local GitAdd = {
			provider = function(self)
				local count = self.status_dict.added or 0
				return count > 0 and ("  " .. count)
			end,
			hl = { fg = "git_add" },
		}

		local GitChange = {
			provider = function(self)
				local count = self.status_dict.changed or 0
				return count > 0 and ("  " .. count)
			end,
			hl = { fg = "git_change" },
		}

		local GitDelete = {
			provider = function(self)
				local count = self.status_dict.removed or 0
				return count > 0 and ("  " .. count)
			end,
			hl = { fg = "git_del" },
		}

		local Git = {
			condition = has_repo_buffer,

			init = function(self)
				self.status_dict = vim.b.gitsigns_status_dict
				self.has_changes = self.status_dict.added ~= 0
					or self.status_dict.removed ~= 0
					or self.status_dict.changed ~= 0
			end,

			static = {
				add = " ",
				change = " ",
				delete = " ",
			},

			hl = { fg = "color_column", bg = "background" },

			round["opening"],
			{
				hl = { fg = "normal", bg = "color_column" },

				GitBranch,
				GitAdd,
				GitChange,
				GitDelete,
			},
			round["closing"],
			space,
		}

		local DiagnosticsError = {
			provider = function(self)
				-- 0 is just another output, we can decide to print it or not!
				local error_icon = vim.fn.sign_getdefined("DiagnosticSignError")[1].text
				return self.errors > 0 and (error_icon .. self.errors .. " ")
			end,
			hl = { fg = "red" },
		}

		local DiagnosticsWarn = {
			provider = function(self)
				local warn_icon = vim.fn.sign_getdefined("DiagnosticSignWarn")[1].text
				return self.warnings > 0 and (warn_icon .. self.warnings .. " ")
			end,
			hl = { fg = "yellow" },
		}

		local DiagnosticsInfo = {
			provider = function(self)
				local info_icon = vim.fn.sign_getdefined("DiagnosticSignInfo")[1].text
				return self.info > 0 and (info_icon .. self.info .. " ")
			end,
			hl = { fg = "blue" },
		}

		local DiagnosticsHint = {
			provider = function(self)
				local hint_icon = vim.fn.sign_getdefined("DiagnosticSignHint")[1].text
				return self.hints > 0 and (hint_icon .. self.hints .. " ")
			end,
			hl = { fg = "cyan" },
		}

		local Diagnostics = {
			condition = has_diagnostic_buffer,

			init = function(self)
				self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
				self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
				self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
				self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
			end,

			DiagnosticsError,
			DiagnosticsWarn,
			DiagnosticsInfo,
			DiagnosticsHint,
		}

		local FileEncodingIcon = {
			static = {
				icon = {
					["utf-8"] = "󰉿",
					["utf-16"] = "󰊀",
					["utf-32"] = "󰊁",
					["utf-8mb4"] = "󰊂",
					["utf-16le"] = "󰊃",
					["utf-16be"] = "󰊄",
				},
			},

			provider = function(self)
				return self.icon[self.encoding] .. " "
			end,

			hl = { fg = "normal", bg = "color_column" },
		}

		local FileEncodingValue = {
			provider = function(self)
				return self.encoding:upper()
			end,

			hl = { fg = "normal", bg = "color_column" },
		}

		local FileEncoding = {
			init = function(self)
				self.encoding = (vim.bo.fenc ~= "" and vim.bo.fenc) or vim.o.enc
			end,

			hl = { fg = "color_column", bg = "background" },

			round["opening"],
			FileEncodingIcon,
			FileEncodingValue,
			round["closing"],
		}

		local Breadcrumb = {
			condition = function()
				return is_file_buffer()
			end,

			update = { "CursorMoved", "CursorMovedI" },

			provider = function()
				local content = require("lspsaga.symbol.winbar").get_bar()
				return (content or "LSP not found") .. "%="
			end,
			hl = { bg = "background" },
		}

		local FileStatusline = {
			condition = function()
				return is_file_buffer()
			end,

			hl = { bg = "background" },

			-- Mode,
			FileModule,
			-- Git,
			-- align,
			-- Diagnostics,
			-- FileEncoding,
		}

		local OthersStatusline = {}

		local Statusline = {
			FileStatusline,
			OthersStatusline,
		}

		return {
			-- NOTE: %C is the fold column
			-- %l is the line number (absolute)
			-- %r is the line number (relative)

			statusline = Statusline,
			winbar = { Breadcrumb },
			tabline = {},
			statuscolumn = {
				{
					condition = function()
						return is_active_buffer()
					end,

					provider = "%=%{v:virtnum < 1 ? (v:relnum ? v:relnum : v:lnum < 10 ? v:lnum . ' ' : v:lnum) : ''}%=%s",
				},
			},

			opts = {
				disable_winbar_cb = function(args)
					return not is_file_buffer(args.buf)
				end,
			},
		}
	end,

	config = function(_, opts)
		vim.opt.showcmdloc = "statusline"

		require("heirline").setup(opts)
	end,
}
