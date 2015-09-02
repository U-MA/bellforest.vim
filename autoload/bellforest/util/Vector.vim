let s:vector = { 'data' : [] }
function! s:vector.push_back(x) abort
  call add(self.data, a:x)
endfunction

function! s:vector.pop_back() abort
  let l:ret = self.data[len(self.data)-1]
  call remove(self.data, len(self.data)-1)
  return l:ret
endfunction

function! s:vector.get(idx) abort
  return self.data[a:idx]
endfunction

function! s:vector.size() abort
  return len(self.data)
endfunction

function! s:vector.empty() abort
  let self.data = []
endfunction

function! s:vector.erase_object(obj) abort
  for l:i in range(self.size())
    if self.data[l:i] is# a:obj
      return remove(self.data, l:i)
    endif
  endfor
endfunction

function! bellforest#util#Vector#new() abort
  return deepcopy(s:vector)
endfunction
