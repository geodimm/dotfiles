function Trunc10(s)
    local result = string.sub(s, 0, 10)
    if string.len(s) > 10 then result = result .. "…" end
    return result
end

local diff_colours = require('tokyonight.colors').setup()

require('lualine').setup({
    options = {
        theme = 'tokyonight',
        section_separators = {'', ''},
        component_separators = {'', ''},
        icons_enabled = true
    },
    sections = {
        lualine_a = {{'mode', upper = true}},
        lualine_b = {
            {
                'diff',
                right_padding = 0,
                color_added = diff_colours.green,
                color_modified = diff_colours.yellow,
                color_removed = diff_colours.red
            }, {'branch', icon = '', format = Trunc10}
        },
        lualine_c = {
            {'filename', file_status = true},
            {'diagnostics', sources = {'nvim_lsp'}, padding = 0}
        },
        lualine_x = {'filetype'},
        lualine_y = {{'encoding', right_padding = 0}, 'fileformat'},
        lualine_z = {
            {'progress', right_padding = 0}, {'location', left_padding = 0}
        }
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {{'filename', file_status = true, path = 1}},
        lualine_x = {'filetype'},
        lualine_y = {{'encoding', right_padding = 0}, 'fileformat'},
        lualine_z = {
            {'progress', right_padding = 0}, {'location', left_padding = 0}
        }
    },
    extensions = {'fzf', 'nvim-tree', 'fugitive', 'quickfix'}
})
