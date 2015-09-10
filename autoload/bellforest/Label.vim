let s:Label = bellforest#Node#new([1, 1], '')

function! s:Label.set_position(position) abort
  let self._position = copy(a:position)
endfunction

function! s:Label.set_text(text) abort
  let self._width  = len(a:text)
  let self._height = 1
  let self._data   = [ a:text ]
endfunction

function! bellforest#Label#new() abort
  return deepcopy(s:Label)
endfunction
