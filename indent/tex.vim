" TeX indent file
" Language:		LaTeX
" Maintainer:	Charles Campbell
" Last Change:	Apr 26, 2004
" Version:		1
"
" Indents by &sw  (see :help 'sw')

" Only load this indent file when no other was loaded.
if exists("b:did_indent")
  finish
endif
let b:did_indent = 1
if !exists("s:brace")
 let s:brace= 0
endif

setlocal indentexpr=GetTexIndent()
setlocal indentkeys=o,O,*<RETURN>,!^F,=\\end{,=\\chapter,=\\section,=\\subsection,=\\subsubsection,=\\paragraph,=\\subparagraph,=\\item

" ---------------------------------------------------------------------

" GetTexIndent: called when an indentkey trigger is identified
fun! GetTexIndent()
  let lnum = prevnonblank(v:lnum - 1)

  " if the current line doesn't begin with a '%', use its indent
  " (ie. skip over preceding comment lines)
  while lnum > 0 && getline(lnum) =~ '^\s*%'
    let lnum = prevnonblank(lnum-1)
  endwhile

  " At the start of the file use zero indent.
  if lnum == 0
   return 0
  endif

  " determine nominal indent() value
  " get current line and previous non-comment/blank line
  let ind        = indent(v:lnum)
  let prvline    = getline(lnum)
  let curline    = getline(v:lnum)
  let initoffset = search('^\s*\\chapter{','bW')? &sw : 0
  if search('^\s*\\begin{document}','bW')
   let initoffset = initoffset + &sw
  endif
"  echomsg "GetTexIndent() ind=".ind.' initoffset='.initoffset.' line='.line('.').' col='.col('.').' lnum='.lnum.' v:lnum='.v:lnum
"  echomsg "prvline<".prvline.">"
"  echomsg "curline<".curline.">"

  " restore cursor to current line so that the searchpair()s will work
  exe v:lnum

  " \chapter{...}
  if curline =~ '^\s*\\chapter'
   let initoffset = &sw
   let ind         = 0
"   echomsg '\chapter ind='.ind

   " sub*chapter-section-paragraph
  elseif curline =~ '^\s*\\section\*\={'
   let ind= initoffset
"   echomsg '\section ind='.ind
  elseif curline =~ '^\s*\\sub\(section\|paragraph\)\*\={'
   let ind= &sw + initoffset
"   echomsg '\subsection ind='.ind
  elseif curline =~ '^\s*\\subsubsection\*\={'
   let ind= 2*(&sw) + initoffset
"   echomsg '\subsubsection ind='.ind
  elseif prvline =~ '^\s*\\chapter'
   let ind= &sw
  elseif prvline =~ '^\s*\\section\*\={'
   let ind= &sw + initoffset
"   echomsg '\section ind='.ind
  elseif prvline =~ '^\s*\\sub\(section\|paragraph\)\*\={'
   let ind= 2*(&sw) + initoffset
"   echomsg '\subsection ind='.ind
  elseif prvline =~ '^\s*\\subsubsection{'
   let ind= 3*(&sw) + initoffset
"   echomsg '\subsubsection ind='.ind

  " \begin{...}
  elseif prvline =~ '^\s*\\begin{' && curline =~'^\s*$'
   let ind= ind + &sw
"   echomsg '\begin ind='.ind

  " \end{...}
  elseif curline =~ '^\s*\\end{$'
   norm! 0
   let srch     = searchpair('^\s*\\begin{','','^\s*\\end{\zs','bWn')
   if srch > 0
    let srchline = getline(srch)
    let ind      = indent(srch)
"    echomsg '\end srch='.srch.' line='.line('.').' col='.col('.')
   else
"    echomsg '\end srch='.srch.' line='.line('.').' col='.col('.')
   endif

  " \item
  elseif curline =~ '^\s*\\item\>'
   norm! 0
   let srch     = searchpair('^\s*\\begin{','^\s*\\item\>','^\s*\\end{','bWn')
   if srch > 0
    let srchline = getline(srch)
    if srchline =~ '^\s*\\item\>'
	 " \item followed by \item
     let ind= indent(srch)
"     echomsg '\item #1 ind='.ind.' srch=".srch." srchline<'.srchline.'>'
    else
	 " (\begin | \end ) followed by \item
     let ind= indent(srch) + &sw
"     echomsg '\item #2 ind='.ind.' srch='.srch." srchline<'.srchline.'>'
    endif
   endif
  elseif prvline =~ '^\s*\\item\>'
   if &sw <= 6
    let ind= indent(lnum) + 6
   else
    let ind= indent(lnum) + &sw
   endif
"   echomsg '\item #3 ind='.ind

  " ..{  and ..}
  elseif prvline =~ '[^\\]{$' || prvline =~ '[^\\]{\s*%.*$'
   let s:brace= s:brace + 1
   let ind= indent(lnum) + &sw
"   echomsg '\item {$ ind='.ind
  elseif s:brace > 0 && prvline =~ '[^\\]}$' || prvline =~ '[^\\]}\s*%.*$'
   let s:brace = s:brace - 1
   let ind     = indent(lnum) - &sw
"   echomsg '\item }$ ind='.ind
  endif

  " sanity check
  if ind < 0
"   echomsg "*** ind=".ind.", setting it to zero"
   let ind= 0
  endif
"  echomsg "return GetTexIndent ".ind
  return ind
endfun

" ---------------------------------------------------------------------
