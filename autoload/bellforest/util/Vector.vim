let s:Vector = {}

function! s:Vector.push_back(x) abort
  call add(self._data, a:x)
endfunction

function! s:Vector.pop_back() abort
  let l:ret = self._data[len(self._data)-1]
  call remove(self._data, len(self._data)-1)
  return l:ret
endfunction

function! s:Vector.get(idx) abort
  return self._data[a:idx]
endfunction

function! s:Vector.size() abort
  return len(self._data)
endfunction

function! s:Vector.empty() abort
  let self._data = []
endfunction

function! s:Vector.erase_object(obj) abort
  for l:i in range(self.size())
    if self._data[l:i] is# a:obj
      return remove(self._data, l:i)
    endif
  endfor
endfunction

function! s:Vector.list() abort
  return self._data
endfunction

function! bellforest#util#Vector#new() abort
  let l:vector = deepcopy(s:Vector)
  let l:vector._data = []
  return l:vector
endfunction
