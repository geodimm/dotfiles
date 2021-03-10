function! ShowCurrentFileName() abort
    " Create a buffer and set the text
    let buf = nvim_create_buf(v:false, v:true)
    let fname = expand('%:p')
    call nvim_buf_set_lines(buf, 0, -1, v:true, ["", "     " . fname, ""])

    " Create the floating window
    let height = 3
    let width = len(fname) + 10
    let opts = {
                \ 'relative': 'editor',
                \ 'row': 2,
                \ 'col': float2nr((&columns - width) / 2),
                \ 'width': width,
                \ 'height': height,
                \ 'style': 'minimal'
                \ }

    " Create the content window
    let win_id = nvim_open_win(buf, v:true, opts)

    " Set the floating window highlighting
    call setwinvar(win_id, '&winhl', 'Normal:PMenuSel')

    setlocal colorcolumn=""

    noremap <buffer> <silent> y j^y$:close<CR>
    noremap <buffer> <silent> j :<C-U>close<CR>
    noremap <buffer> <silent> k :<C-U>close<CR>
    noremap <buffer> <silent> q :<C-U>close<CR>
endfunction
noremap <silent> <leader>n :call ShowCurrentFileName()<CR>

function! PlugLoaded(name) abort
    return (
        \ has_key(g:plugs, a:name) &&
        \ isdirectory(g:plugs[a:name].dir) &&
        \ stridx(&rtp, g:plugs[a:name].dir) >= 0)
endfunction
