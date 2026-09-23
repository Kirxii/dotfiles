return {
	"saghen/blink.cmp",
	version = "1.*",

	dependencies = {
		"onsails/lspkind.nvim",
	},

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

			["<Tab>"] = { "fallback" },
			["<S-Tab>"] = { "fallback" },

			["<c-h>"] = { "select_next", "fallback" },
			["<c-l>"] = { "select_prev", "fallback" },
			["<c-g>"] = { "scroll_documentation_up", "fallback" },
			["<c-s>"] = { "scroll_documentation_down", "fallback" },
			["<CR>"] = { "accept", "fallback" },
		},

		-- (Default) Only show the documentation popup when manually triggered
		completion = {
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 500,
				window = { border = "rounded" },

				--[[ draw = function()
          local item = require("blink.cmp").get_selected_item()

          if item and item.client_id then
            local client = vim.lsp.get_client_by_id(item.client_id)

            ---@diagnostic disable-next-line
            if client and client.supports_method("completionItem/resolve") then
              -- Send request to LSP to fetch unresolved item documentation
              ---@diagnostic disable-next-line
              client.request("completionItem/resolve", item, function(err, result)
                if err or not result then
                  return
                end

                -- Extract raw documentation string or LSP MarkupContent
                local doc = result.documentation
                local raw_text = type(doc) == table and doc.value or doc or ""

                local lines = vim.split(raw_text, "\n", { plain = true })
                return true
              end)
            end
          end
        end, ]]
			},
			ghost_text = { enabled = true },
			keyword = { range = "full" },
			list = {
				selection = { preselect = false, auto_insert = false },
			},
			menu = {
				border = "rounded",
				draw = {
					align_to = "label",
					padding = 1,
					snippet_indicator = "~",
					treesitter = { "lsp" },

					columns = {
						{ "kind_icon" },
						{ "label", "label_description", gap = 1 },
						{ "source_name" },
					},
					components = {
						kind_icon = {
							ellipsis = false,
							text = function(ctx)
								local icon = ctx.kind_icon
								if vim.tbl_contains({ "Path" }, ctx.source_name) then
									local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
									if dev_icon then
										icon = dev_icon
									end
								else
									icon = require("lspkind").symbol_map[ctx.kind] or ""
								end

								return icon .. ctx.icon_gap
							end,

							-- Optionally, use the highlight groups from nvim-web-devicons
							-- You can also add the same function for `kind.highlight` if you want to
							-- keep the highlight groups in sync with the icons.
							highlight = function(ctx)
								local hl = ctx.kind_hl
								if vim.tbl_contains({ "Path" }, ctx.source_name) then
									local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
									if dev_icon then
										hl = dev_hl
									end
								end
								return hl
							end,
						},

						kind = {
							ellipsis = false,
							width = { fill = true },
							text = function(ctx)
								return ctx.kind
							end,
							highlight = function(ctx)
								return ctx.kind_hl
							end,
						},

						label = {
							width = { fill = true, max = 45 },
							text = function(ctx)
								return ctx.label
							end,
							highlight = function(ctx)
								-- label and label details
								local highlights = {
									{
										0,
										#ctx.label,
										group = ctx.deprecated and "BlinkCmpLabelDeprecated" or "BlinkCmpLabel",
									},
								}
								if ctx.label_detail then
									table.insert(
										highlights,
										{ #ctx.label, #ctx.label + #ctx.label_detail, group = "BlinkCmpLabelDetail" }
									)
								end

								-- characters matched on the label by the fuzzy matcher
								for _, idx in ipairs(ctx.label_matched_indices) do
									table.insert(highlights, { idx, idx + 1, group = "BlinkCmpLabelMatch" })
								end

								return highlights
							end,
						},

						label_description = {
							width = { max = 30 },
							text = function(ctx)
								return ctx.label_description
							end,
							highlight = "BlinkCmpLabelDescription",
						},

						source_name = {
							width = { max = 30 },
							text = function(ctx)
								return ctx.source_name
							end,
							highlight = "BlinkCmpSource",
						},

						source_id = {
							width = { max = 30 },
							text = function(ctx)
								return ctx.source_id
							end,
							highlight = "BlinkCmpSource",
						},
					},
				},
			},
			trigger = {
				show_on_keyword = true,
				show_on_trigger_character = true,
				show_on_insert_on_trigger_character = true,
				show_on_accept_on_trigger_character = true,
			},
		},

		-- Default list of enabled providers defined so that you can extend it
		-- elsewhere in your config, without redefining it, due to `opts_extend`
		sources = {
			default = { "lsp", "path", "snippets", "buffer" },

			providers = {
				lsp = {
					enabled = true,
					-- NOTE: Make specifically `lua_ls` get its documentation from scratch, unprocessed
					-------- In order to make them able to have retained new lines instead of being folded
					transform_items = function(context, items)
						for _, item in ipairs(items) do
							local blink_item = require("blink.cmp").get_selected_item()

							if not (blink_item and blink_item.client_id) then
								goto continue
							end

							local client = vim.lsp.get_client_by_id(blink_item.client_id)

							if
								not (
									client
									and client.name == "lua_ls"
									and client:supports_method("completionItem/resolve")
								)
							then
								goto continue
							end

							-- Send request to LSP to fetch unresolved item documentation
							client:request("completionItem/resolve", blink_item, function(err, result)
								if err or not result then
									return
								end

								-- Extract raw documentation string or LSP MarkupContent
								local doc = result.documentation
								local raw_text = type(doc) == "table" and doc.value or doc or ""

								if item.documentation then
									item.documentation.value =
										raw_text:gsub("^```.-```%s*%-*%s*", "", 1):gsub("\n ", "\n"):gsub("  ", " ")
								end
							end)

							::continue::
						end

						return items
					end,
				},
			},
		},

		-- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
		-- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
		-- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
		--
		-- See the fuzzy documentation for more information
		fuzzy = { implementation = "prefer_rust_with_warning" },
	},
}
