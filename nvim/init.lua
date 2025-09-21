require("compat")
require("options")
require("keymaps")

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none", "--branch=stable",
    "https://github.com/folke/lazy.nvim.git", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup("plugins")
require('lualine').setup({
  options = {
    theme = {
      normal = {
        a = { fg = '#ffffff', bg = '#1e3a8a', gui = 'bold' },  -- Dark blue with white text
        b = { fg = '#e5e7eb', bg = '#374151' },                -- Light gray on dark gray
        c = { fg = '#9ca3af', bg = '#1f2937' },                -- Medium gray on darker background
      },
      insert = {
        a = { fg = '#ffffff', bg = '#059669', gui = 'bold' },  -- Green
        b = { fg = '#e5e7eb', bg = '#374151' },
        c = { fg = '#9ca3af', bg = '#1f2937' },
      },
      visual = {
        a = { fg = '#ffffff', bg = '#7c3aed', gui = 'bold' },  -- Purple
        b = { fg = '#e5e7eb', bg = '#374151' },
        c = { fg = '#9ca3af', bg = '#1f2937' },
      },
      replace = {
        a = { fg = '#ffffff', bg = '#dc2626', gui = 'bold' },  -- Red
        b = { fg = '#e5e7eb', bg = '#374151' },
        c = { fg = '#9ca3af', bg = '#1f2937' },
      },
      command = {
        a = { fg = '#ffffff', bg = '#f59e0b', gui = 'bold' },  -- Orange
        b = { fg = '#e5e7eb', bg = '#374151' },
        c = { fg = '#9ca3af', bg = '#1f2937' },
      },
      inactive = {
        a = { fg = '#6b7280', bg = '#374151' },
        b = { fg = '#6b7280', bg = '#374151' },
        c = { fg = '#6b7280', bg = '#1f2937' },
      },
    },
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch', 'diff', 'diagnostics' },
    lualine_c = { 'filename' },
    lualine_x = { 'encoding', 'fileformat', 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = { 'location' }
  },
})
