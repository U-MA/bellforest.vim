let s:RemoveSelf = {}

function! s:RemoveSelf.step(dt) abort
  call self.actor.remove_from_parent()
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
