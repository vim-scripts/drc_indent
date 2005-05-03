" Vim indent file
" Language:	    Shell script
" Maintainer:   Charles E. Campbell, Jr.
" Modified:     from Sung-Hyun Nam's indent/sh.vim <namsh@kldp.org>
" Last Change:	Apr 27, 2005

setlocal indentexpr=GetShIndent()
setlocal cinkeys+==else,=esac,=fi,=done,=while,=until,=for,=elif,=case

" ---------------------------------------------------------------------
" Only define the indenting function once:
if exists("*GetShIndent")
  finish
endif

" ---------------------------------------------------------------------
" GetShIndent:
function GetShIndent()
  " Find a non-empty line above the current line.
  let lnum = v:lnum - 1
  while lnum > 0
    if getline(lnum) !~ '^\s*$'
      break
    endif
    let lnum = lnum - 1
  endwhile

  " Hit the start of the file, use zero indent.
  if lnum == 0
    return 0
  endif

  " Add a 'shiftwidth' after: if, elif, else, case, until, for, while, functions
  let ind = indent(lnum)
  let line = getline(lnum)
  if line =~ '^\s*\(if\|else\|case\|elif\|while\|until\|for\)\>'
      \ || line =~ '^\s*\<\h\w*\>\s*()\s*{'
      \ || line =~ '^\s*{'
    let ind = ind + &sw
  endif

  " Subtract a 'shiftwidth' on a else, elif, esac, fi, done
  let line = getline(v:lnum)
  if line =~ '^\s*\(elif\|else\|esac\|fi\|done\)\>' || line =~ '^\s*}'
    let ind = ind - &sw
  endif

  return ind
endfunction

" ---------------------------------------------------------------------
" vim:sw=2

