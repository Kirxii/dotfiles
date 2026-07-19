-- NOTE: Input mode escape more smooth with no delay
return {
  "max397574/better-escape.nvim",
  event = "InsertEnter",

  opts = {
    timeout = vim.o.timeoutlen,
    mappings = {
      i = {
        j = {
          j = "<esc>",
          k = "<esc>",
        },
        k = {
          j = "<esc>",
          k = "<esc>",
        },
      },
      t = {
        j = {
          j = false,
          k = false,
          h = "<C-\\><C-n>",
        },
      },
      v = {
        j = {
          k = false,
        },
        k = {
          j = false,
        },
      },
    },
  },
  config = function(_, opts)
    local keymap = vim.keymap.set

    require("better_escape").setup(opts)

    keymap("n", "<leader><tab>", "@p")
  end,
}
