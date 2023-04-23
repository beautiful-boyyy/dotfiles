vim.cmd("colorscheme  nightfox")
require('lualine').setup({
  sections = {
    lualine_a = {
      {
        'fileformat',
        symbols = {
          unix = '', -- e712
          dos = '', -- e70f
          mac = '', -- e711
        }
      }
    }
  }
})
