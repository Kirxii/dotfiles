return {
	{ "neovim/nvim-lspconfig" },
	{
		"mason-org/mason.nvim",
		build = ":MasonUpdate",
		event = "VeryLazy",
		keys = {
			{ "<leader>:", "<cmd>Mason<cr>", desc = "Mason" },
		},

		opts = {
			ui = { border = "single" },
			ensure_installed = {
				"js-debug-adapter",
				"black",
				"gofumpt",
				"stylua",
			},
			ui_select = function(opts, items)
				return vim.tbl_deep_extend("force", opts, {
					actions = {
						["default"] = function(selected, select_opts)
							-- 1. Execute fzf-lua's native default select action first
							require("fzf-lua").actions.file_edit(selected, select_opts)

							-- 2. Force Neovim to look for the open Mason window and focus it
							vim.schedule(function()
								for _, win in ipairs(vim.api.nvim_list_wins()) do
									local buf = vim.api.nvim_win_get_buf(win)
									if vim.bo[buf].filetype == "mason" then
										vim.api.nvim_set_current_win(win)
										break
									end
								end
							end)
						end,
					},
				})
			end,
		},
		config = function(_, opts)
			require("mason").setup(opts)
			local mr = require("mason-registry")

			mr:on("package:install:success", function()
				vim.defer_fn(function()
					-- trigger FileType event to possibly load this newly installed LSP server
					require("lazy.core.handler.event").trigger({
						event = "FileType",
						buf = vim.api.nvim_get_current_buf(),
					})
				end, 100)
			end)

			mr.refresh(function()
				for _, tool in ipairs(opts.ensure_installed) do
					local p = mr.get_package(tool)
					if not p:is_installed() then
						p:install()
					end
				end
			end)
		end,
	},
	{
		"mason-org/mason-lspconfig.nvim",
		event = "VeryLazy",
		opts = {
			ensure_installed = {
				"lua_ls",
			},

			automatic_installation = true,
			automatic_enable = false,
		},
	},
	{
		"nvimdev/lspsaga.nvim",
		dependencies = {
			"nvim-treesitter/nvim-treesitter", -- optional
			"nvim-tree/nvim-web-devicons", -- optional
		},

		opts = {
			ui = {
				code_action = "󰯪",
			},
			lightbulb = {
				sign = false,
			},
		},
	},
	{
		"onsails/lspkind.nvim",

		opts = {},
	},
}
