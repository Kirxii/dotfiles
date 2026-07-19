-- Keymap related settings
vim.g.mapleader = " "

-- Neovide configurations - Unused
vim.o.guifont = "JetBrainsMono Nerd Font Mono,Twemoji Mozilla:h9"
vim.g.neovide_scale_factor = 0.75
vim.g.neovide_transparency = 1
vim.g.neovide_fullscreen = false
vim.g.neovide_hide_mouse_when_typing = true
vim.g.neovide_padding_bottom = 1
vim.g.neovide_position_animation_length = 0.2
vim.g.neovide_position_animation_length = 0.1
vim.g.neovide_scroll_animation_far_lines = 1
vim.g.neovide_refresh_rate_idle = 5
vim.g.neovide_blink_animation_length = 0.05
vim.g.neovide_blink_trail_size = 0.4
vim.g.neovide_blink_antialiasing = false
vim.g.neovide_blink_animate_command_line = true
vim.g.neovide_blink_smooth_blink = true

-- Scrolloff
vim.opt.scrolloff = 999

-- Unsorted stuff
vim.opt.ignorecase = true
vim.opt.termguicolors = true
vim.opt.autochdir = true

-- Visual mode
vim.opt.virtualedit = "block"

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Line wrap
vim.opt.wrap = true
vim.opt.breakindent = true
vim.opt.linebreak = true
vim.opt.showbreak = "╎ "

-- Indentations
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2

-- End of buffer
vim.opt.fillchars:append({ eob = " " })

-- Diagnostics virtual text prefix
-- local signs = { Error = "", Warn = "", Hint = "󱠂", Info = "" }
-- for type, icon in pairs(signs) do
--   local hl = "DiagnosticSign" .. type
--   vim.(hl, { text = icon, texthl = hl, numhl = hl })
-- end

-- local sign = { ERROR = "", WARN = "", HINT = "󱠂", INFO = "" }
-- vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
--   virtual_text = {
--     prefix = function(diagnostic)
--       return sign[vim.diagnostic.severity[diagnostic.severity]]
--     end,
--   },
-- })
