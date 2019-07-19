" Text objects for TeX
vnoremap i$ :<C-u>normal! T$vt$<CR>
onoremap i$ :<C-u>normal! T$vt$<CR>
vnoremap a$ :<C-u>normal! F$vf$<CR>
onoremap a$ :<C-u>normal! F$vf$<CR>

" Underscore is not a part of words
setlocal iskeyword-=_

" mzview mappings
nmap <localleader>s <Plug>mzview_SynctexForward
nmap <localleader>r <Plug>mzview_RebuildPDF
