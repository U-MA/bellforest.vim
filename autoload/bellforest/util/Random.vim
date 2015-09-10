let s:random = { '_seed' : 0 }

function! s:random.set_seed(s) abort
  let self._seed = a:s
endfunction

" from http://d.hatena.ne.jp/mFumi/20110920/1316525906
function! s:random.rand() abort
  let self._seed = self._seed * 214013 + 2531011
  return (self._seed < 0 ? self._seed - 0x80000000 : self._seed) / 0x10000 % 0x8000
endfunction

function! bellforest#util#Random#new() abort
  return copy(s:random)
endfunction
