local get_lang = vim.treesitter.language.get_lang
local fn_modpath = vim.fn.fnamemodify

-- lazy.nvim
return {
  "rmagatti/auto-session",
  lazy = false,
  keys = {
    {
      "<leader>sb",
      "<cmd>AutoSession search<cr>",
      desc = "Browse sessions",
    },
    {
      "<leader>ss",
      "<cmd>AutoSession save ",
      desc = "Save session",
    },
    {
      "<leader>sx",
      "<cmd>AutoSession delete ",
      desc = "Delete session",
    },
    {
      "<leader>se",
      "<cmd>AutoSession enable",
      desc = "Enable auto-save",
    },
    {
      "<leader>sd",
      "<cmd>AutoSession disable",
      desc = "Disable auto-save",
    },
    {
      "<leader>st",
      "<cmd>AutoSession toggle",
      desc = "Toggle auto-save",
    },
  },

  dependencies = {
    "ibhagwan/fzf-lua",
  },

  ---@module "auto-session"
  ---@type AutoSession.Config
  opts = {
    auto_restore = false,
    bypass_save_filetypes = { "alpha", "dashboard", "snacks_dashboard" },
    suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },

    session_lens = {
      picker = "fzf",
      previewer = "active_buffer",
      -- previewer = function(session_name, session_filename, session_lines)
      --   local active_buffer_path, active_buffer_file_type
      --   for _, line in ipairs(session_lines) do
      --     local path = line:match("^edit%s+(.+)$")
      --     if path then
      --       active_buffer_path = fn_modpath(path, ":p")
      --       active_buffer_file_type = get_lang(fn_modpath(active_buffer_path, ":e"))
      --       break
      --     end
      --   end
      --
      --   local preview_lines = vim.fn.readfile(active_buffer_path)
      --   return vim.tbl_extend("force", {
      --     session_filename,
      --   }, preview_lines), "lua"
      -- end,
      load_on_startup = false,

      picker_opts = {
        width = 0.8,
        height = 0.7,
        border = "rounded",

        preview = {
          layout = "horizontal",
          horizontal = "right:70%",
        },
      },
    },
  },
}
