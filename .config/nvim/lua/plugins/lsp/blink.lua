local lazydev = require("plugins.lsp.lazydev")
local function inside_comment_block()
	if vim.api.nvim_get_mode().mode ~= "i" then
		return false
	end
	local node_under_cursor = vim.treesitter.get_node()
	local parser = vim.treesitter.get_parser(nil, nil, { error = false })
	local query = vim.treesitter.query.get(vim.bo.filetype, "highlights")
	if not parser or not node_under_cursor or not query then
		return false
	end
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	row = row - 1
	for id, node, _ in query:iter_captures(node_under_cursor, 0, row, row + 1) do
		if query.captures[id]:find("comment") then
			local start_row, start_col, end_row, end_col = node:range()
			if start_row <= row and row <= end_row then
				if start_row == row and end_row == row then
					if start_col <= col and col <= end_col then
						return true
					end
				elseif start_row == row then
					if start_col <= col then
						return true
					end
				elseif end_row == row then
					if col <= end_col then
						return true
					end
				else
					return true
				end
			end
		end
	end
	return false
end

return {
	{
		"saghen/blink.compat",
		version = "2.*",
		lazy = true,

		opts = {},
	},
	{
		"saghen/blink.cmp",
		-- optional: provides snippets for the snippet source
		dependencies = {
			"moyiz/blink-emoji.nvim",
			"MahanRahmati/blink-nerdfont.nvim",
			"junkblocker/blink-cmp-wezterm",
			{
				"Kaiser-Yang/blink-cmp-dictionary",
				dependencies = { "nvim-lua/plenary.nvim" },
			},
		},

		-- use a release tag to download pre-built binaries
		version = "1.*",
		-- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
		-- build = 'cargo build --release',
		-- If you use nix, you can build from source using latest nightly rust with:
		-- build = 'nix run .#build-plugin',

		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			-- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
			-- 'super-tab' for mappings similar to vscode (tab to accept)
			-- 'enter' for enter to accept
			-- 'none' for no mappings
			--
			-- All presets have the following mappings:
			-- C-space: Open menu or open docs if already open
			-- C-n/C-p or Up/Down: Select next/previous item
			-- C-e: Hide menu
			-- C-k: Toggle signature help (if signature.enabled = true)
			--
			-- See :h blink-cmp-config-keymap for defining your own keymap
			keymap = {
				preset = "default",

				["<c-y>"] = false,
				["<c-n>"] = false,
				["<c-p>"] = false,
				["<c-j>"] = { "select_next", "fallback" },
				["<c-k>"] = { "select_prev", "fallback" },
				["<f2>"] = { "select_and_accept", "fallback" }, -- Wezterm remaps <S-CR> to <F2>
				["<f3>"] = { "select_and_accept", "fallback" }, -- Wezterm remaps <C-CR> to <F3>
				["<A-1>"] = {
					function(cmp)
						cmp.accept({ index = 1 })
					end,
				},
				["<A-2>"] = {
					function(cmp)
						cmp.accept({ index = 2 })
					end,
				},
				["<A-3>"] = {
					function(cmp)
						cmp.accept({ index = 3 })
					end,
				},
				["<A-4>"] = {
					function(cmp)
						cmp.accept({ index = 4 })
					end,
				},
				["<A-5>"] = {
					function(cmp)
						cmp.accept({ index = 5 })
					end,
				},
				["<A-6>"] = {
					function(cmp)
						cmp.accept({ index = 6 })
					end,
				},
				["<A-7>"] = {
					function(cmp)
						cmp.accept({ index = 7 })
					end,
				},
				["<A-8>"] = {
					function(cmp)
						cmp.accept({ index = 8 })
					end,
				},
				["<A-9>"] = {
					function(cmp)
						cmp.accept({ index = 9 })
					end,
				},
				["<A-0>"] = {
					function(cmp)
						cmp.accept({ index = 10 })
					end,
				},
			},

			appearance = {
				-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
				-- Adjusts spacing to ensure icons are aligned
				nerd_font_variant = "mono",
			},

			-- (Default) Only show the documentation popup when manually triggered
			completion = {
				list = { selection = { preselect = true, auto_insert = false } },
				ghost_text = { enabled = true },
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 500,
					window = { border = "single" },
				},
				menu = {
					border = "single",
					draw = {
						columns = {
							{ "item_idx" },
							{ "kind_icon" },
							{ "label", "label_description", gap = 1 },
							{ "[", "kind", "]" },
						},
						components = {
							item_idx = {
								text = function(ctx)
									return ctx.idx == 10 and "0" or ctx.idx >= 10 and "" or tostring(ctx.idx)
								end,
								highlight = "BlinkCmpItemIdx",
							},
							["["] = {
								text = function()
									return "["
								end,
								highlight = function(ctx)
									return ctx.kind_hl
								end,
							},
							["]"] = {
								text = function()
									return "]"
								end,
								highlight = function(ctx)
									return ctx.kind_hl
								end,
							},
						},
					},
				},
			},

			-- Default list of enabled providers defined so that you can extend it
			-- elsewhere in your config, without redefining it, due to `opts_extend`
			sources = {
				default = function()
					local result = {
						"lazydev",
						"lsp",
						"path",
						"snippets",
						"buffer",
						"wezterm",
					}
					local comment_sources = {
						"emoji",
						"nerdfont",
						"dictionary",
					}
					if vim.tbl_contains({ "markdown", "text" }, vim.bo.filetype) or inside_comment_block() then
						for _, value in ipairs(comment_sources) do
							table.insert(result, value)
						end
					end
					return result
				end,
				providers = {
					lazydev = {
						name = "LazyDev",
						module = "lazydev.integrations.blink",
						score_offset = 100,
					},
					lsp = {
						name = "LSP",
						score_offset = 100,
					},
					emoji = {
						name = "Emoji",
						module = "blink-emoji",
						score_offset = 15,
						opts = {
							insert = true, -- Insert emoji (default) or complete its name
							---@type string|table|fun():table
							trigger = function()
								return { ":" }
							end,
						},
						should_show_items = function()
							return vim.tbl_contains(
								-- Enable emoji completion only for git commits and markdown.
								-- By default, enabled for all file-types.
								{ "gitcommit", "markdown" },
								vim.o.filetype
							)
						end,
					},
					nerdfont = {
						name = "NF",
						module = "blink-nerdfont",
						score_offset = 15,
						opts = { insert = true }, -- Insert nerdfont icon (default) or complete its name
					},
					dictionary = {
						name = "Dict",
						module = "blink-cmp-dictionary",
						score_offset = 15,
						max_items = 10,
						min_keyword_length = 3,
						opts = {
							get_command = "rg",
							get_command_args = function(prefix, _)
								return {
									"--color=never",
									"--no-line-number",
									"--no-messages",
									"--no-filename",
									"--ignore-case",
									"--",
									prefix,
									vim.fn.expand("~/AppData/Local/nvim/dictionaries"),
								}
							end,
							documentation = {
								enable = true,
								get_command = "wn",
								get_command_args = function(prefix, _)
									return {
										"$color",
										"-over",
									}
								end,
							},
						},
					},
					wezterm = {
						name = "wezterm",
						module = "blink-cmp-wezterm",
						opts = {
							all_panes = false,
							capture_history = false,
							-- only suggest completions from `wezterm` if the `trigger_chars` are
							-- used
							triggered_only = false,
							trigger_chars = { "." },
						},
					},
				},
			},

			-- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
			-- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
			-- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
			--
			-- See the fuzzy documentation for more information
			fuzzy = {
				implementation = "lua",
				sorts = {
					function(a, b)
						local sort = require("blink.cmp.fuzzy.sort")
						if a.source_id == "spell" and b.source_id == "spell" then
							return sort.label(a, b)
						end
					end,
					-- This is the normal default order, which we fall back to
					"score",
					"kind",
					"label",
				},
			},

			cmdline = {
				completion = {
					list = { selection = { preselect = false, auto_insert = true } },
					ghost_text = { enabled = true },
				},
			},
		},
		opts_extend = { "sources.default" },
	},
}
