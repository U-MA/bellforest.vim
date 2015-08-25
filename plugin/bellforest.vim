" Author: U-MA
" Lisence:

if exists('g:loaded_bellforest')
  finish
endif
let g:loaded_bellforest = 1

let s:save_cpo = &cpo
set cpo&vim

" command!

let &cpo = s:save_cpo
unlet s:save_cpo
