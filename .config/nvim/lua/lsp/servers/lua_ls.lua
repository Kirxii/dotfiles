return {
	on_init = function(client)
		local path = client.workspace_folders[1].name

		-- If no proper project root is found, disable heavy workspace scanning
		if path == vim.fn.expand("%:p:h") or path == vim.fn.expand("$HOME") then
			client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
				workspace = {
					library = {}, -- Stop loading global libraries for single files
					checkThirdParty = false,
				},
				diagnostics = {
					enable = true,
				},
			})
			client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
		end
		return true
	end,
	settings = {
		Lua = {
			hint = { enable = true },
			hover = {
				expandAlias = true,
				viewString = true,
				viewStringMaxLength = 1000,
			},
			workspace = {
				checkThirdParty = false,
				library = {
					vim.env.VIMRUNTIME,
					vim.fn.stdpath("data") .. "/lazy",
				},
				ignoreDir = { "node_modules", ".git" },
			},
			telemetry = { enable = false },
			completion = { callSnippet = "Replace" },
			diagnostics = { globals = { "vim" } },
			format = {
				enable = false,
				-- https://github.com/CppCXY/EmmyLuaCodeStyle/blob/master/docs/format_config_EN.md
				--[[ defaultConfig = {
          indent_size = 4,
          tab_width = 4,
          quote_style = "double",
          call_arg_parentheses = "keep",
          trailing_table_separator = "smart",
          space_around_table_field_list = "false",
          space_before_attribute = false,
          space_inside_square_brackets = false,
          align_call_args = false,
          align_function_params = false,
          align_continuous_assign_statement = false,
          align_continuous_rect_table_field = false,
          align_if_branch = false,
          align_array_table = false,
        }, ]]
			},
		},
	},
}
