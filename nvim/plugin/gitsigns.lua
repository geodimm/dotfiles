require('gitsigns').setup({
    signs = {
        add = {text = '▌'},
        change = {text = '▌'},
        delete = {text = '▌'},
        topdelete = {text = '▌'},
        changedelete = {text = '▌'}
    },
    diff_opts = {internal = true},
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
    end,
    on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']c', "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'",
            {expr = true})
        map('n', '[c', "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'",
            {expr = true})

        -- Actions
        map({'n', 'v'}, '<leader>hs', ':Gitsigns stage_hunk<CR>')
        map({'n', 'v'}, '<leader>hr', ':Gitsigns reset_hunk<CR>')
        map('n', '<leader>hS', gs.stage_buffer)
        map('n', '<leader>hu', gs.undo_stage_hunk)
        map('n', '<leader>hR', gs.reset_buffer)
        map('n', '<leader>hp', gs.preview_hunk)
        map('n', '<leader>hb', function() gs.blame_line {full = true} end)
        map('n', '<leader>hd', gs.diffthis)
        map('n', '<leader>htd', gs.toggle_deleted)

        -- Text object
        map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
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
        d = "Diff this",
        p = "Preview hunk",
        r = "Reset hunk",
        s = "Stage hunk",
        u = "Undo stage hunk",
        td = "Toggle deleted"
    }
})
wk.register({
    ["<leader>h"] = {name = "+gitsigns", r = "reset hunk", s = "stage hunk"}
}, {mode = "v"})
