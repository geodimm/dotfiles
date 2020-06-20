let g:coc_fzf_opts = ["--layout=reverse"]
let g:coc_fzf_preview = "right:50%"

nmap <silent> <leader>fcl :<C-u>CocFzfList<CR>
nmap <silent> <leader>fca :<C-u>CocFzfList actions<CR>
nmap <silent> <leader>fcc :<C-u>CocFzfList commands<CR>
nmap <silent> <leader>fcd :<C-u>CocFzfList diagnostics --current-buf<CR>
nmap <silent> <leader>fcy :<C-u>CocFzfList yank<CR>
