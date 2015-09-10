let s:RemoveSelf = { '_actor' : {} }

function! s:RemoveSelf.step(dt) abort
  call self._actor.remove_from_parent()
endfunction

function! s:RemoveSelf.is_done() abort
  return 1
endfunction

function! s:RemoveSelf.stop() abort
  " do nothing
endfunction

function! bellforest#action#RemoveSelf#new() abort
  return deepcopy(s:RemoveSelf)
endfunction
