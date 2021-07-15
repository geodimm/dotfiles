require('gitsigns').setup {
    signs = {
        add = {hl = 'GitGutterAdd', text = '▌'},
        change = {hl = 'GitGutterChange', text = '▌'},
        delete = {hl = 'GitGutterDelete', text = '▌'},
        topdelete = {hl = 'GitGutterDelete', text = '▌'},
        changedelete = {hl = 'GitGutterChange', text = '▌'}
    },
    current_line_blame = true,
    current_line_blame_delay = 0
}

local wk = require("which-key")
wk.register({
    ["]c"] = {"Next hunk"},
    ["[c"] = {"Previous hunk"},
    ["<leader>h"] = {
        name = "+gitsigns",
        R = "Reset buffer",
        S = "Stage buffer",
        U = "Reset buffer index",
        b = "Blame line",
        p = "Preview hunk",
        r = "Reset hunk",
        s = "Stage hunk",
        u = "Undo stage hunk"
    }
})
wk.register({
    ["<leader>h"] = {name = "+gitsigns", r = "reset hunk", s = "stage hunk"}
}, {mode = "v"})
