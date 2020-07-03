" vim: foldmethod=marker

" coc.nvim {{{

let g:coc_global_extensions = [
    \'coc-marketplace',
    \'coc-explorer',
    \'coc-floaterm',
    \'coc-yank',
    \'coc-snippets',
    \'coc-git',
    \'coc-go',
    \'coc-java',
    \'coc-python',
    \'coc-sh',
    \'coc-vimlsp',
    \'coc-lua',
    \'coc-docker',
    \'coc-json',
    \'coc-yaml',
    \'coc-xml',
    \'coc-html',
    \'coc-css',
    \'coc-markdownlint',
    \'coc-swagger'
    \]

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Highlight symbol under cursor on CursorHold
augroup coc_nvim_hl
    autocmd!
    autocmd CursorHold * silent call CocActionAsync('highlight')
augroup end

" Organize imports on save
augroup coc_nvim_organize_imports
    autocmd!
    autocmd BufWritePre *.go call CocAction('runCommand', 'editor.action.organizeImport')
augroup end

" Use `[d` and `]d` to navigate diagnostics
nmap <silent> [d <Plug>(coc-diagnostic-prev)
nmap <silent> ]d <Plug>(coc-diagnostic-next)

" gotos
nmap <silent> <leader>gd <Plug>(coc-definition)
nmap <silent> <leader>gt <Plug>(coc-type-definition)
nmap <silent> <leader>gi <Plug>(coc-implementation)
nmap <silent> <leader>gr <Plug>(coc-references)
nmap <silent> <leader>cr <Plug>(coc-rename)
nmap <silent> <leader>cf <Plug>(coc-fix-current)
nmap <silent> <leader>ca <Plug>(coc-codeaction)
nmap <silent> <leader>cl <Plug>(coc-codelens-action)

" Use K to show documentation in preview window
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocActionAsync('doHover')
  endif
endfunction

nnoremap <silent> K :call <SID>show_documentation()<CR>

" Introduce function text object
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

highlight CocHintHighlight gui=none
highlight CocInfoHighlight gui=none
highlight CocWarningHighlight gui=none
highlight CocErrorHighlight gui=none

"}}}

" Extensions {{{

" coc-explorer {{{

noremap <silent> <leader>fe :<C-u>CocCommand explorer --toggle<CR>
hi CocExplorerNormalFloatBorder guifg=8 guibg=1
hi CocExplorerNormalFloat guibg=1

" }}}
" coc-actions {{{

noremap <silent> <leader>a :<C-u>CocCommand actions.open<CR>

" }}}
" coc-git {{{

" navigate chunks of current buffer
nmap [c <Plug>(coc-git-prevchunk)
nmap ]c <Plug>(coc-git-nextchunk)

" show current commit
nmap <silent> <leader>gc <Plug>(coc-git-commit)

" show chunk diff at current position
nmap <silent> <leader>gi <Plug>(coc-git-chunkinfo)

" stage current chunk
nmap <silent> <leader>gs :<C-u>CocCommand git.chunkStage<CR>

" undo current chunk
nmap <silent> <leader>gu :<C-u>CocCommand git.chunkUndo<CR>

" create text object for git chunks
omap ig <Plug>(coc-git-chunk-inner)
xmap ig <Plug>(coc-git-chunk-inner)
omap ag <Plug>(coc-git-chunk-outer)
xmap ag <Plug>(coc-git-chunk-outer)

" }}}

" }}}
