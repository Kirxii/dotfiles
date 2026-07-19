return {
  "HiPhish/rainbow-delimiters.nvim",

  dependencies = {
    "Kirxii/KUtilities",
  },

  config = function()
    local hl = require("KUtilities")
    local get_color = hl.get_color

    Red = get_color("RainbowDelimiterRed", "fg")
    Orange = get_color("RainbowDelimiterOrange", "fg")
    Yellow = get_color("RainbowDelimiterYellow", "fg")
    Green = get_color("RainbowDelimiterGreen", "fg")
    Cyan = get_color("RainbowDelimiterCyan", "fg")
    Blue = get_color("RainbowDelimiterBlue", "fg")
  end,
}
