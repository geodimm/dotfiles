let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

command! -bang -nargs=* FZFGGrep
  \ call fzf#vim#grep(
  \   'git grep --line-number '.shellescape(<q-args>) . ' -- ":!vendor/*"', 0,
  \   fzf#vim#with_preview({'dir': systemlist('git rev-parse --show-toplevel')[0]}), <bang>0)

command! -bang -nargs=* FZFRGrep
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case --follow --glob "!vendor/*" '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview(), <bang>0)

let g:fzf_layout = { 'window': { 'width': 0.90, 'height': 0.75, 'border': 'sharp', 'highlight': 'Normal' } }

function! s:file_to_qf(key, val)
    let fname = fnameescape(a:val)
    return {'filename': fname, 'lnum': 1, 'text': system('head -n 1 ' . expand(fname))}
endfunction

function! s:populate_quickfix(lines)
    let list = map(a:lines, function('s:file_to_qf'))
    if len(list) > 1
        call setqflist(list)
        copen
        wincmd p
        cfirst
    endif
endfunction

let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit',
  \ 'ctrl-l': function('s:populate_quickfix')
  \ }

nnoremap <silent> <leader>ff  :<C-u>Files<CR>
nnoremap <silent> <leader>fgf :<C-u>GFiles<CR>
nnoremap <silent> <leader>fgs :<C-u>GFiles?<CR>
nnoremap <silent> <leader>fgb :<C-u>BCommits<CR>
nnoremap <silent> <leader>fgc :<C-u>Commits<CR>
nnoremap <silent> <leader>f/  :<C-u>Lines<CR>
nnoremap <silent> <leader>f*  :<C-u>Lines <C-r>=expand('<cword>')<CR><CR>
nnoremap <silent> <leader>fb  :<C-u>Buffers<CR>
nnoremap <silent> <leader>fs  :<C-u>FZFGGrep<CR>
nnoremap <silent> <leader>fa  :<C-u>FZFRGrep<CR>
nnoremap <silent> <leader>fv  :<C-u>Vista finder<CR>
nnoremap <silent> <leader>fm  :<C-u>Maps<CR>
