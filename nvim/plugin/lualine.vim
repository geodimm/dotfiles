if PlugLoaded('lualine.nvim')
lua <<EOF
function trunc10(s)
    local result = string.sub(s, 0, 10)
    if string.len(s) > 10 then
        result = result .. "…"
    end
    return result
end

require'lualine'.setup{
    options = {
      theme = vim.g.colors_name,
      section_separators = {'', ''},
      component_separators = {'', ''},
      icons_enabled = true,
    },
    sections = {
      lualine_a = {{'mode', upper = true}},
      lualine_b = {{'diff', right_padding = 0}, {'branch', icon = '', format = trunc10}},
      lualine_c = {{'filename', file_status = true}, {'diagnostics', sources = {'coc'}, padding = 0}},
      lualine_x = {'filetype'},
      lualine_y = {{'encoding', right_padding = 0}, 'fileformat'},
      lualine_z = {{'progress', right_padding = 0}, {'location', left_padding = 0}},
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {{'filename', file_status = true, full_path = true}},
      lualine_x = {'filetype'},
      lualine_y = {{'encoding', right_padding = 0}, 'fileformat'},
      lualine_z = {{'progress', right_padding = 0}, {'location', left_padding = 0}},
    },
    extensions = { 'fzf' },
}
EOF
endif
