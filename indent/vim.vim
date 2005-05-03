" Vim indent file
" Language:	Vim script
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Modified By:  Chip Campbell to support two-space indenting for functions
"                                        one-space indenting for if/else/while
"                                        to "un"indent an endtry
" Version:		1
" Last Change:	May 03, 2005

" ---------------------------------------------------------------------
" Only load this indent file when no other was loaded. {{{1
if exists("b:did_indent")
  finish
endif
let b:did_indent = 1

" ---------------------------------------------------------------------
"  Set up indentexpr, indentkeys: {{{1
setlocal indentexpr=GetVimIndent()
setlocal indentkeys+==endf,=endi,=endt,=endw,=else,=fina,=cat,=END,0\\

" Only define the function once.
if exists("*GetVimIndent")
  finish
endif

" ---------------------------------------------------------------------
"  GetVimIndent: {{{1
fun! GetVimIndent()
  " Find a non-blank line above the current line.
  let lnum = prevnonblank(v:lnum - 1)

  " If the current line doesn't start with '\' and below a line that starts
  " with '\', use the indent of the line above it.
  if getline(v:lnum) !~ '^\s*\\'
    while lnum > 0 && getline(lnum) =~ '^\s*\\'
      let lnum = lnum - 1
    endwhile
  endif

  " At the start of the file use zero indent.
  if lnum == 0
    return 0
  endif

  " Add a 'shiftwidth' after :if, :while, :function and :else.
  let ind = indent(lnum)
  if getline(v:lnum) =~ '^\s*\\' && v:lnum > 1 && getline(lnum) !~ '^\s*\\'
    let ind = ind + 3
  elseif getline(lnum) =~ '^\s*\(if\>\|wh\%[ile]\|el\%[seif]\|try\|cat\%[ch]\|fina\%[lly]\)'
    let ind = ind + 1
  elseif getline(lnum) =~ '^\s*fu\%[nction]'
    let ind = ind + 2
  elseif getline(lnum) =~ '^\s*aug\%[roup]' && getline(lnum) !~ '^\s*aug\%[roup]\s*!\=\s\+END'
    let ind = ind + 1
  endif

  " If the previous line contains an "end" after a pipe, but not in an ":au"
  " command.
  if getline(lnum) =~ '|\s*\(ene\@!\)' && getline(lnum) !~ '^\s*au\%[tocmd]'
    let ind = ind - 1
  endif

  " Subtract indenting on a :endif, :endwhile, :endfun and :else.
  if getline(v:lnum) =~ '^\s*endf\%[unction]'
    let ind = ind - 2
  elseif getline(v:lnum) =~ '^\s*\(ene\@!\|cat\|fina\|el\|aug\%[roup]\s*!\=\s\+END\)'
    let ind = ind - 1
  endif

  return ind
endfun

" ---------------------------------------------------------------------
" vim:sw=2 fdm=marker
