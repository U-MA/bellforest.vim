let s:EventListenerKeyPressed = {}

function! s:EventListenerKeyPressed.press() abort
  " You may override this function
endfunction

function! bellforest#EventListenerKeyPressed#new() abort
  return deepcopy(s:EventListenerKeyPressed)
endfunction
