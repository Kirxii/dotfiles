-- Helper functions
local helper = require("utils.heirline")
local hl = require("utils.highlights")

-- Highlights
local background = hl.dec_to_rgb(COLORS.pmenu)
local contrast = hl.dec_to_rgb(0xFFFFFF)
local surface = hl.rgb_to_dec(hl.blend_colors(background, contrast, 0.02))

-- Component's parts
local FileIcon = helper.surround({
  -- TODO: Make a helper function for making delimiters easier
  -------- Preferably the parameters should be in the order (shared, overrides)
  -------- shared: { delimiter, highlight }
  -------- overrides: { left?: shared, right?: shared }
  left = {
    delimiter = "rounded",
    highlight = function(self)
      return { fg = self.file_icon_color, bg = "none" }
    end,
  },
  right = {
    delimiter = "rounded",
    highlight = function(self)
      return { fg = self.file_icon_color }
    end,
  },
}, function(self)
  return {
    fg = COLORS.pmenu,
    bg = self.file_icon_color,
  }
end, {
  provider = function(self)
    return self.file_icon .. " "
  end,
})

local FileName = {
  provider = function(self)
    -- TODO: Figure out if it is possible to know the source of a nameless
    -------- buffer to see if I can have more information than "unknown"
    if self.file_name == "" then
      return " unknown"
    end

    return " " .. self.file_name
  end,
}

local FileModule = {
  init = function(self)
    -- File name
    self.file_path = vim.api.nvim_buf_get_name(0)
    self.file_name = vim.fn.fnamemodify(self.file_path, ":t")
    self.file_directory = vim.fn.fnamemodify(self.file_path, ":h")
    self.file_extension = vim.fn.fnamemodify(self.file_path, ":e")

    -- File metadata
    self.file_size = vim.fn.getfsize(self.file_path)
    self.file_icon, self.file_icon_color = require("nvim-web-devicons").get_icon_color(
      self.file_name,
      self.file_extension,
      { default = true }
    )

    -- Buffer/File state
    self.file_modified = vim.bo.modified
    self.file_readonly = not vim.bo.modifiable or vim.bo.readonly
  end,

  FileIcon,
  FileName,
}

FileModule = helper.surround({
  left = {
    delimiter = "none",
  },
  right = {
    delimiter = "rounded",
    highlight = { fg = surface },
  },
}, {
  fg = COLORS.normal,
  bg = surface,
}, FileModule)

return FileModule
