augroup lua_formatter
    autocmd!
    autocmd BufWritePre *.lua call LuaFormat()
augroup end
