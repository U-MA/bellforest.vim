" Author: U-MA
" Lisence:

" Utiliry {{{

" class Vector {{{

let s:Vector = { 'data' : [] }
function! s:Vector.new() abort
  return deepcopy(s:Vector)
endfunction

function! s:Vector.push_back(x) abort
  call add(self.data, a:x)
endfunction

function! s:Vector.erase(x) abort
  for l:i in range(0, len(self.data)-2)
    if self.data[l:i] is a:x
      call remove(self.data, l:i)
    endif
  endfor
endfunction

" }}}

" class Random {{{
" from http://d.hatena.ne.jp/mFumi/20110920/1316525906
let s:Random = { 'seed' : 0 }
function! s:Random.rand() abort
  let self.seed = self.seed * 214013 + 2531011
  return (self.seed < 0 ? self.seed - 0x80000000 : self.seed) / 0x10000 % 0x8000
endfunction " }}}

" }}}
