" Text objects for TeX
" TODO
" counts
" enlarge selection if already in visual mode
" accept delimiters wider than one character

function! s:SelectDelimitedTextObject(delim, inside)
    let forward = ['f', 't']
    let current_line = getline('.')
    let line_till_cursor = current_line[0:col('.')-1]
    let line_from_cursor = current_line[col('.'):]
    " If there aren't enough delimiters after the cursor position,
    " don't do anything
    let remaining_delims = count(line_from_cursor, a:delim)
    let before_first_occurrence = count(line_till_cursor, a:delim) == 0
    " If we're invoked left of the first delimiter in the current line,
    " then we actually move to the first delimiter pair
    if before_first_occurrence
        " ... but only if the line has enough delimiters
        if remaining_delims < 2
            return
        endif
        execute "normal! f" . a:delim
    else    " Otherwise we may have to move back to the `opening delimiter`
        let current_symbol = line_till_cursor[col('.')-1]
        let inside_textobject = count(line_till_cursor, a:delim) % 2 != 0
        " If we are not on a `closing delimiter`,
        " then we need one additional delimiter to the right
        if !(current_symbol ==# a:delim && !inside_textobject) && remaining_delims < 1
            return
        endif
        " If we are not on an `opening delimiter`,
        " then we move back to it
        if current_symbol !=# a:delim || !inside_textobject
            execute "normal! F" . a:delim
        endif
    endif
    if a:inside
        normal! l
    endif
    let visual_start = col('.')
    execute "normal! v" . forward[a:inside] . a:delim
    if !a:inside
        if len(current_line) > col('.') && current_line[col('.')] =~ "\\s"
            normal! l
        elseif visual_start > 1 && current_line[visual_start - 2] =~ "\\s"
            execute "normal! oho"
        endif
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

" section movement
let s:re_sec = '\v^\s*\\%(' . join([
      \   '%(sub)?paragraph',
      \   '%(sub)*section',
      \   'chapter',
      \   'part',
      \   'appendi%(x|ces)',
      \   '%(front|back|main)matter',
      \   'add%(sec|chap|part)',
      \ ], '|') . ')>'

function! s:MoveLatexSection(direction)
    let match = search(s:re_sec, 'sW' . a:direction)
    " TODO move to start/end if there is no match
endfunction

nnoremap <silent> ][ :call <SID>MoveLatexSection('')<CR>
nnoremap <silent> [[ :call <SID>MoveLatexSection('b')<CR>
