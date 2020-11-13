" vim: foldmethod=marker

" coc.nvim {{{

let g:coc_global_extensions = [
    \'coc-marketplace',
    \'coc-explorer',
    \'coc-floaterm',
    \'coc-floatinput',
    \'coc-yank',
    \'coc-snippets',
    \'coc-git',
    \'coc-go',
    \'coc-java',
    \'coc-python',
    \'coc-sh',
    \'coc-vimlsp',
    \'coc-lua',
    \'coc-tsserver',
    \'coc-docker',
    \'coc-json',
    \'coc-yaml',
    \'coc-xml',
    \'coc-toml',
    \'coc-html',
    \'coc-css',
    \'coc-markdownlint',
    \'coc-restclient',
    \'coc-swagger'
    \]

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
    autocmd BufWritePre *.go silent call CocAction('runCommand', 'editor.action.organizeImport')
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
nmap <silent> <leader>cs :CocSearch <c-r>=expand("<cword>")<CR><CR>

" Use K to show documentation in preview window
set keywordprg=:call\ CocActionAsync('doHover')
augroup coc_nvim_help
    autocmd!
    autocmd Filetype vim,help setlocal keywordprg=:help
augroup end

" Introduce function text object
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

highlight CocHintHighlight gui=none cterm=none
highlight CocInfoHighlight gui=none cterm=none
highlight CocWarningHighlight gui=none cterm=none
highlight CocErrorHighlight gui=none cterm=none

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
nmap <silent> <leader>gg <Plug>(coc-git-chunkinfo)

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
