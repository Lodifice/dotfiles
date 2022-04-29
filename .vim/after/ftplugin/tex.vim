" Fix highlighted and concealed subscripts
" TODO doesn't work
let g:tex_subscripts='[0-9a-zA-W.,:;+-<>/()=]'

" Text objects for TeX
function! s:InsideTextObject(delim)
    let line_until_cursor = getline('.')[0:col('.')-1]
    return count(line_until_cursor, a:delim) % 2 != 0
endfunction

" TODO
" doesn't work if before first text object
" cursor positions are different from builtins
" counts

function! s:SelectDelimitedTextObject(delim, inside)
    let forward = ['f', 't']
    let backward = ['F', 'T']
    if <SID>InsideTextObject(a:delim)
        execute "normal! " . forward[a:inside] . a:delim . "v" . backward[a:inside] . a:delim
    else
        execute "normal! " . backward[a:inside] . a:delim . "v" . forward[a:inside] . a:delim
    endif
endfunction

vnoremap <silent> i$ :<C-u>call <SID>SelectDelimitedTextObject('$', v:true)<CR>
onoremap <silent> i$ :<C-u>call <SID>SelectDelimitedTextObject('$', v:true)<CR>
vnoremap <silent> a$ :<C-u>call <SID>SelectDelimitedTextObject('$', v:false)<CR>
onoremap <silent> a$ :<C-u>call <SID>SelectDelimitedTextObject('$', v:false)<CR>

" Underscore is not a part of words
setlocal iskeyword-=_

" mzview mappings
nmap <localleader>s <Plug>mzview_SynctexForward
nmap <localleader>v <Plug>mzview_SpawnViewer
nmap <localleader>r <Plug>mzview_RebuildPDF
