" Fix highlighted and concealed subscripts
" TODO doesn't work
let g:tex_subscripts='[0-9a-zA-W.,:;+-<>/()=]'

" Text objects for TeX
vnoremap <silent> i$ :<C-u>normal! T$vt$<CR>
onoremap <silent> i$ :<C-u>normal! T$vt$<CR>
vnoremap <silent> a$ :<C-u>normal! F$vf$<CR>
onoremap <silent> a$ :<C-u>normal! F$vf$<CR>

" Underscore is not a part of words
setlocal iskeyword-=_

" mzview mappings
nmap <localleader>s <Plug>mzview_SynctexForward
nmap <localleader>r <Plug>mzview_RebuildPDF
