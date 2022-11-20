if exists("b:current_syntax")
  finish
endif

syntax case match

syn keyword    starlarkDirective          load
syn keyword    starlarkKeyword            None True False
syn keyword    starlarkStatement          break continue return pass
syn keyword    starlarkConditional        if elif else
syn keyword    starlarkRepeat             for
syn keyword    starlarkOperator           and in not or
syn keyword    starlarkReserved           as assert class del except finally from global import is lambda nonlocal raise try while with yield

syn keyword    starlarkDeclaration        def nextgroup=starlarkFunction skipwhite
syn match      starlarkFunction           "\%(\%(def\s\|@\)\s*\)\@<=\h\%(\w\|\.\)*" contained

syn keyword    starlarkBuitinFuncs        any all bool bytes dict dir enumerate float fail getattr hasattr hash int len list max min print range repr reversed sorted str tuple type zip

syn keyword    starlarkTodo               NOTE HACK FIXME BUG TODO XXX contained
syn cluster    starlarkCommentGroup       contains=starlarkTodo
syn region     starlarkComment            start="#" end="$" contains=@starlarkCommentGroup,@Spell

syn region     starlarkBlock              start="{" end="}" transparent fold
syn region     starlarkParen              start="(" end=")" transparent

syn region     starlarkString             start=+"+ skip=+\\\\\|\\"+ end=+"+
syn region     starlarkString             start=+`+ end=+`+
syn region     starlarkString             start=+'+ end=+'+

syn match      starlarkNumber             "\<0[oO]\=\o\+[Ll]\=\>"
syn match      starlarkNumber             "\<0[xX]\x\+[Ll]\=\>"
syn match      starlarkNumber             "\<0[bB][01]\+[Ll]\=\>"
syn match      starlarkNumber             "\<\%([1-9]\d*\|0\)[Ll]\=\>"
syn match      starlarkNumber             "\<\d\+[jJ]\>"
syn match      starlarkNumber             "\<\d\+[eE][+-]\=\d\+[jJ]\=\>"
syn match      starlarkNumber             "\<\d\+\.\%([eE][+-]\=\d\+\)\=[jJ]\=\%(\W\|$\)\@="
syn match      starlarkNumber             "\%(^\|\W\)\@<=\d*\.\d\+\%([eE][+-]\=\d\+\)\=[jJ]\=\>"

" Function calls
syntax match   starlarkCustomParen        "(" contains=cParen
syntax match   starlarkCustomFunc         "\w\+\s*(" contains=starlarkCustomParen
syntax match   starlarkCustomScope        "\."
syntax match   starlarkCustomAttr         "\.\w\+" contains=starlarkCustomScope
syntax match   starlarkCustomMethod       "\.\w\+\s*(" contains=starlarkCustomScope,starlarkCustomParen

hi def link    starlarkKeyword            Keyword
hi def link    starlarkDeclaration        Keyword
hi def link    starlarkDirective          Include
hi def link    starlarkStatement          Statement
hi def link    starlarkConditional        Conditional
hi def link    starlarkRepeat             Repeat
hi def link    starlarkOperator           Operator
hi def link    starlarkBuitinFuncs        Function
hi def link    starlarkFunction           Function
hi def link    starlarkComment            Comment
hi def link    starlarkTodo               Todo
hi def link    starlarkString             String
hi def link    starlarkNumber             Number
hi def link    starlarkReserved           Error

hi def link    starlarkCustomFunc         Function
hi def link    starlarkCustomMethod       Function
hi def link    starlarkCustomAttr         Identifier

let b:current_syntax = 'starlark'
