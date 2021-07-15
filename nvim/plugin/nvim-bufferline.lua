local lsp_icons = {hint = "", info = "", warning = "", error = ""}

require'bufferline'.setup {
    options = {
        diagnostics = 'nvim_lsp',
        max_name_length = 20,
        diagnostics_indicator = function(count, level)
            return " " .. lsp_icons[level] .. " " .. count
        end
    }
}

-- These commands will navigate through buffers in order regardless of which mode you are using
--  e.g. if you change the order of buffers :bnext and :bprevious will not respect the custom ordering
vim.api.nvim_set_keymap('n', '<silent>[b', ':BufferLineCyclePrev<CR>',
                        {noremap = true})
vim.api.nvim_set_keymap('n', '<silent>]b', ':BufferLineCycleNext<CR>',
                        {noremap = true})
