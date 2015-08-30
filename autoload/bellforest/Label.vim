let s:Label = bellforest#Node#new([1, 1], '')

function! s:Label.set_position(position) abort
  let self.position = copy(a:position)
endfunction

function! s:Label.set_text(text) abort
  let self.width  = len(a:text)
  let self.height = 1
  let self.data   = [ a:text ]
endfunction

function! bellforest#Label#new() abort
  return deepcopy(s:Label)
endfunction
