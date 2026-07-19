-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- Neovim and Wezterm colorschemes syncing
-- Saved Neovim colorschemes between sessions
vim.api.nvim_create_autocmd("ColorScheme", {
	group = vim.api.nvim_create_augroup("wezterm_colorscheme", { clear = true }),
	callback = function(args)
		local colorschemes = {
			["default"] = "",
			["catppuccin-frappe"] = "Catppuccin Frappe",
			["catppuccin-latte"] = "Catppuccin Latte",
			["catppuccin-macchiato"] = "Catppuccin Macchiato",
			["catppuccin-mocha"] = "Catppuccin Mocha",
			["dayfox"] = "dayfox",
			["dawnfox"] = "dawnfox",
			["carbonfox"] = "carbonfox",
			["nordfox"] = "nordfox",
			["nightfox"] = "nightfox",
			["duskfox"] = "duskfox",
			["terafox"] = "terafox",
			["monochrome"] = "Mono (terminal.sexy)",
			["rose-pine-main"] = "rose-pine",
			["rose-pine-moon"] = "rose-pine-moon",
			["rose-pine-dawn"] = "rose-pine-dawn",
			["github_light"] = "Github",
			["github_dark"] = "Github Dark",
			["dracula"] = "Dracula (Official)",
			["dracula-soft"] = "Dracula (Official)",
			["oxocarbon"] = "Oxocarbon Dark (Gogh)",
			["onedark"] = "One Dark (Gogh)",
			["everblush"] = "Everblush",
		}

		local colorscheme = colorschemes[args.match]
		if not colorscheme then
			return
		end

		local neovim_dir = vim.fn.stdpath("config") .. "/lua/core/colorscheme"
		local neovim_file = require("KUtilities").read_file(neovim_dir)
		local neovim_colorscheme = string.gsub(neovim_file, "[%l%p]+$", args.match)
		neovim_colorscheme = string.gsub(neovim_colorscheme, "^\n+", "")

		local neovim_write = io.open(neovim_dir, "w")
		if neovim_write then
			neovim_write:write(neovim_colorscheme)
			neovim_write:close()
		end

		local wezterm_dir = vim.fn.expand("~/.wezterm.lua")
		local wezterm_read = io.open(wezterm_dir, "r")
		local config
		if wezterm_read then
			config = string.gsub(
				wezterm_read:read("*a"),
				'config%.color_scheme = ".-"',
				'config%.color_scheme = "' .. colorscheme .. '"'
			)
			wezterm_read:close()
		end

		local wezterm_write = io.open(wezterm_dir, "w")
		if wezterm_write then
			wezterm_write:write(config)
			wezterm_write:close()
		end
	end,
})

vim.api.nvim_create_autocmd({ "BufEnter" }, {
	callback = function(event)
		if vim.fn.executable("wezterm") == 1 then
			local title = "NVIM"
			if event.file ~= "" then
				title = string.format("NVIM: %s", vim.fs.basename(event.file))
			end

			vim.fn.system({ "wezterm", "cli", "set-tab-title", title })
		end
	end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "md" },
	callback = function()
		require("ufo").detach()
	end,
})
