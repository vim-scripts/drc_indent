" Language:		Maple  (maple indent file)
" Maintainer:	Charles Campbell
" Last Change:	Oct 31, 2004
" Version:		2
" History:
" 	1, Oct 29, 2004 : * initial release
"
" Indents use &sw  (see :help 'sw')

" ---------------------------------------------------------------------
" Load Once: Only load this indent file when no other was loaded. {{{1
if exists("b:did_indent")
  finish
endif
let b:did_indent = 1
"DechoMsgOn

setlocal indentexpr=GetMapleIndent()
setlocal indentkeys=o,O,*<RETURN>,!^F,;,:,=elif,=else,=fi;,=od;

" ---------------------------------------------------------------------
" GetMapleIndent: called when an indentkey trigger is identified {{{1
fun! GetMapleIndent()
  let curline = getline(v:lnum)
  let lnum    = prevnonblank(v:lnum - 1)
  let prvline = getline(lnum)
"  call Dfunc("GetMapleIndent() lnum=".lnum." curline<".curline."> prvline<".prvline.">")

  " At the start of the file use zero indent.
  if lnum == 0
"   call Dret("GetMapleIndent 0 : at start-of-file")
   return 0
  else
   " get previous non-blank line's indent
   let ind = indent(lnum)
  endif

  " add a 'shiftwidth'    after: if while for else elif
  " remove a 'shiftwidth' after: od end   fi
  if prvline =~ '^\s*\%(if\|for\|while\|else\|elif\)\>'
   let ind= ind + &sw
"   call Decho(v:lnum.": prvline<".prvline."> ++ind=".ind)
  elseif prvline =~ ':=\s*proc\s*('
   let ind= ind + &sw
"   call Decho(v:lnum.": prvline<".prvline."> ++ind=".ind)
  endif

  " subtract a 'shiftwidth'    after: if while for else elif
  " remove a 'shiftwidth' after: od end   fi
  if curline =~ '^\s*\%(elif\|else\|od\|end\|fi\)\>'
   let ind= ind - &sw
"   call Decho(v:lnum.": curline<".curline."> --ind=".ind)
  else
"   call Decho(v.lnum.": no chg in ind=".ind)
  endif

"  call Dret("GetMapleIndent ".ind)
  return ind
endfun

" ---------------------------------------------------------------------
"  vim: ts=4 fdm=marker
