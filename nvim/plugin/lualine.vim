if PlugLoaded('lualine.nvim')
    let g:lualine = {
        \'options': {
        \  'theme': g:colors_name,
        \  'section_separators': ['', ''],
        \  'component_separators': ['', ''],
        \  'icons_enabled': v:true,
        \},
        \'sections': {
        \  'lualine_a': [['mode', {'upper': v:true}]],
        \  'lualine_b': [['diff', {'right_padding': 0}], ['branch', {'icon': ''}]],
        \  'lualine_c': [['filename', {'file_status': v:true}], ['diagnostics', {'sources': ['coc'], 'padding': 0}]],
        \  'lualine_x': ['filetype'],
        \  'lualine_y': [['encoding', {'right_padding': 0}], 'fileformat'],
        \  'lualine_z': [['progress',{'right_padding': 0}], 'location'],
        \},
        \'inactive_sections': {
        \  'lualine_a': [],
        \  'lualine_b': [],
        \  'lualine_c': [ ['filename', {'file_status': v:true, 'full_path': v:true}]],
        \  'lualine_x': ['filetype'],
        \  'lualine_y': [['encoding', {'right_padding': 0}], 'fileformat'],
        \  'lualine_z': [['progress',{'right_padding': 0}], 'location'],
        \},
        \'extensions': ['fzf'],
        \}
    lua require("lualine").status()
endif
