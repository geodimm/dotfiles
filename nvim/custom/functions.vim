function! PlugLoaded(name) abort
    return (
        \ has_key(g:plugs, a:name) &&
        \ isdirectory(g:plugs[a:name].dir) &&
        \ stridx(&rtp, trim(g:plugs[a:name].dir, '/'), 2) >= 0)
endfunction
