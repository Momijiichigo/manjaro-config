require('lualine').setup {
  sections = {
    lualine_c = {{
      'filename',
      path = 1,
    }},
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {{
      'filename',
      path = 1,
    }},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {},
    lualine_z = {}
  },
}

