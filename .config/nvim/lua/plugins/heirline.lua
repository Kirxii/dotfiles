return {
  "rebelot/heirline.nvim",
  event = { "VeryLazy" },

  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },

  config = function()
    -- Out of the box helper functions
    local conditions = require("heirline.conditions")
    local utils = require("heirline.utils")

    -- Colors, and lots of them!
    local get_hl = utils.get_highlight

    local setup_colors = function()
      local colors = {
				-- stylua: ignore start
				background    = get_hl("Normal").bg,
				color_column  = get_hl("ColorColumn").bg,
				pmenu         = get_hl("PMenu").bg,
				normal        = get_hl("Normal").fg,
				tabline       = get_hl("TabLine").bg,
				statusline    = get_hl("StatusLine").bg,
        -- stylua: ignore end
      }

      return colors
    end
    COLORS = setup_colors()

    vim.api.nvim_create_augroup("Heirline", { clear = true })
    vim.api.nvim_create_autocmd("ColorScheme", {
      group = "Heirline",
      callback = function()
        COLORS = setup_colors()
      end,
    })

    local File = require("utils.heirline-components.File")

    require("heirline").setup {
      statusline = { File },
      winbar = {},
      tabline = {},
      statuscolumn = {},

      opts = {
        disable_winbar_cb = function(args)
          -- Disable winbar on any floating/relative window
          local win_config = vim.api.nvim_win_get_config(0)
          if win_config.relative ~= "" then
            return true
          end

          -- Disable winbar on standard excluded buffer types
          return conditions.buffer_matches({
            buftype = { "nofile", "prompt", "help", "quickfix" },
            filetype = { "^gitcommit$", "^gitrebase$", "toggleterm" },
          }, args.buf)
        end,
      },
    }
  end,
}
