let g:vista_default_executive = 'nvim_lsp'
let g:vista_finder_alternative_executives = []
let g:vista_fzf_preview = ['right:50%:border:wrap']
let g:vista_echo_cursor_strategy = 'floating_win'

noremap <silent> <leader>v :<C-u>Vista!!<CR>
nnoremap <silent> <leader>fv :<C-u>Vista finder<CR>
