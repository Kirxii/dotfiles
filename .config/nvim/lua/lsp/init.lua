local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local methods = vim.lsp.protocol.Methods
local virtual_lines_enabled = false

-- Configures the LSP servers with (optionally) their configuration and keybinds
autocmd({ "BufReadPre", "BufNewFile" }, {
	once = true,
	callback = function()
		local servers = {
			clangd = {},
			lua_ls = require("lsp.servers.lua_ls"),
			css_ls = {},
			tailwindcss = {},
			vtsls = {},
			rust_analyzer = {},

			stylua = {},
			clang_format = {},
		}

		for server, config in pairs(servers) do
			if config then
				vim.lsp.config(server, config)
				if config.keys then
					for _, key in ipairs(config.keys) do
						vim.keymap.set("n", key[1], key[2], { desc = key.desc })
					end
				end
			end
		end

		local server_names = {}
		for server, _ in pairs(servers) do
			table.insert(server_names, server)
		end
		vim.lsp.enable(server_names)
	end,
})
