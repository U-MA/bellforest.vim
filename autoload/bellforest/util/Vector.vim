let s:vector = { 'data' : [] }
function! s:vector.push_back(x) abort
  call add(self.data, a:x)
endfunction

function! s:vector.pop_back() abort
  let l:ret = self.data[len(self.data)-1]
  call remove(self.data, len(self.data)-1)
  return l:ret
endfunction

function! bellforest#util#Vector#new() abort
  return deepcopy(s:vector)
endfunction
