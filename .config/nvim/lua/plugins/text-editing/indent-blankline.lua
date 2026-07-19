return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  opts = {
    indent = {
      char = "│",
      highlight = "LineNr",
      smart_indent_cap = true,
    },
    scope = { enabled = false },
    exclude = {
      filetypes = {
        "dashboard",
      },
    },
  },
}
