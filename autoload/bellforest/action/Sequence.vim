let s:Sequence = {}
let s:Sequence.actions = bellforest#util#Vector#new()

function! s:Sequence.size() abort
  return len(self.actions.data)
endfunction

function! bellforest#action#Sequence#new(...) abort
  let l:sequence = deepcopy(s:Sequence)
  for l:i in range(a:0)
    call l:sequence.actions.push_back(a:000[l:i])
  endfor
  return l:sequence
endfunction
