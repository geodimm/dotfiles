require('gitsigns').setup({
    signs = {
        add = {text = '▌'},
        change = {text = '▌'},
        delete = {text = '▌'},
        topdelete = {text = '▌'},
        changedelete = {text = '▌'}
    },
    current_line_blame = true,
    current_line_blame_opts = {delay = 0},
    current_line_blame_formatter = function(name, blame_info)
        if blame_info.author == name then blame_info.author = 'You' end
        local text
        if blame_info.author == 'Not Committed Yet' then
            text = blame_info.author
        else
            text = string.format('%s, %s - %s', blame_info.author, os.date(
                                     '%Y-%m-%d',
                                     tonumber(blame_info['author_time'])),
                                 blame_info.summary)
        end
        return {{'   ' .. text, 'GitSignsCurrentLineBlame'}}
    end
})

local wk = require('which-key')
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
