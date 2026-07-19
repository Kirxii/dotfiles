return {
  "folke/noice.nvim",
  event = "VeryLazy",
  keys = {
    { "<leader>nd", "<cmd>NoiceDismiss<cr>", desc = "Dismiss notifications" },
  },

  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  },

  opts = {
    views = {
      cmdline_popup = {
        border = {
          style = "rounded",
          padding = { 0, 2 },
        },
      },
    },
  },
  -- opts = {
  --   -- Configurations for the command line and its changes during certain commands
  --   cmdline = {
  --     enabled = true,
  --     view = "cmdline_popup",
  --     opts = {},
  --     format = {
  --       cmdline = { pattern = "^:", icon = "󰘳", lang = "vim", title = " Command " },
  --       replace_current = {
  --         pattern = "^:%s*s%s*/",
  --         icon = "",
  --         lang = "regex",
  --         title = " Replace Current Line ",
  --       },
  --       replace_all = { pattern = "^:%s*%%s%s*/", icon = "", lang = "regex", title = " Replace All Lines " },
  --       filter = { pattern = "^:%s*!", icon = "", lang = "bash", title = " Filter " },
  --       lua = {
  --         pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" },
  --         icon = "",
  --         lang = "lua",
  --         title = " Lua ",
  --       },
  --       help = { pattern = "^:%s*he?l?p?%s+", icon = "", title = " Help " },
  --       search_telescope = {
  --         kind = "search",
  --         pattern = "^:%s*Telescope%s+",
  --         icon = "󰭎",
  --         title = " Telescope ",
  --       },
  --       search_down = {
  --         kind = "search",
  --         pattern = "^/",
  --         icon = "",
  --         lang = "regex",
  --         title = " Search Down ",
  --       },
  --       search_up = { kind = "search", pattern = "^?", icon = "", lang = "regex", title = " Search Up " },
  --       input = {},
  --       set = { pattern = "^:%s*set%s+", icon = "", lang = "vim", title = " Set " },
  --       highlight = {
  --         kind = "highlight",
  --         pattern = "^:%s*hig?h?l?i?g?h?t?%s+",
  --         icon = "",
  --         lang = "vim",
  --         title = " Highlight ",
  --       },
  --     },
  --   },
  --
  --   messages = {
  --     enabled = true,
  --     view = "notify",
  --     view_error = "notify",
  --     view_warn = "notify",
  --     view_history = "messages",
  --     view_search = "virtualtext",
  --   },
  --
  --   -- Disable hrsh7th/cmp-cmdline to actually use the popupmenu
  --   popupmenu = {
  --     enabled = true,
  --     view = "popupmenu",
  --     backend = "nui",
  --     kind_icons = {},
  --   },
  --
  --   redirect = {
  --     view = "popup",
  --     filter = { event = "msg_show" },
  --   },
  --
  --   presets = {
  --     bottom_search = false, -- use a classic bottom cmdline for search
  --     command_palette = false, -- position the cmdline and popupmenu together
  --     long_message_to_split = true, -- long messages will be sent to a split
  --     inc_rename = false, -- enables an input dialog for inc-rename.nvim
  --     lsp_doc_border = true, -- add a border to hover docs and signature help
  --   },
  --
  --   throttle = 1000 / 30,
  --
  --   views = {
  --     cmdline_popup = {
  --       position = {
  --         row = 2,
  --         col = "50%",
  --       },
  --       size = {
  --         width = 80,
  --         height = "auto",
  --       },
  --     },
  --     popupmenu = {
  --       relative = "editor",
  --       position = {
  --         row = 5,
  --         col = "50%",
  --       },
  --       size = {
  --         width = 80,
  --         height = "auto",
  --         max_height = 20,
  --       },
  --       border = {
  --         style = "rounded",
  --         padding = { 0, 1 },
  --       },
  --       win_options = {
  --         winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
  --       },
  --     },
  --   },
  --
  --   routes = {
  --     {
  --       filter = {
  --         event = "msg_show",
  --         find = "written",
  --       },
  --       opts = { skip = true },
  --     },
  --     {
  --       filter = {
  --         event = "lsp",
  --         find = "Checking",
  --       },
  --       opts = { skip = true },
  --     },
  --   },
  -- },
  config = function(_, opts)
    local hl = vim.api.nvim_set_hl

    require("noice").setup(opts)

    -- Highlight
    hl(0, "NoiceCmdlinePopupBorderHighlight", { link = "RainbowDelimiterRed" })
    hl(0, "NoiceCmdlinePopupTitleHighlight", { link = "RainbowDelimiterRed" })
    hl(0, "NoiceCmdlineIconHighlight", { link = "RainbowDelimiterRed" })
  end,
}
