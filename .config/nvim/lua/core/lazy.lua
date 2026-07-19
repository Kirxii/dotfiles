require("core.utils")
require("core.options")
require("core.autocmds")
require("core.keymaps")

-- NOTE: This makes sure that LazyVim is able to run
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system { "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- NOTE: LazyVim configurations
require("lazy").setup({
  spec = {
    { import = "themes" },
    { import = "plugins" },
    { import = "plugins.lsp" },
    { import = "plugins.text-editing" },
    { import = "plugins.ui" },
  },

  defaults = {
    lazy = false,
    version = false,
  },

  install = { colorscheme = { "catppuccin" } },
  checker = { enabled = true },
  performance = {},

  change_detection = { enabled = false },
}, {
  install = {
    colorscheme = {
      "catppuccin",
    },
  },
})
