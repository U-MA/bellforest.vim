let s:Rect = { 'position' : [ 1, 1 ], 'width' : 0, 'height' : 0 }

function! bellforest#Rect#new(position, width, height) abort
  let l:rect = deepcopy(s:Rect)
  let l:rect.position = copy(a:position)
  let l:rect.width    = a:width
  let l:rect.height   = a:height
  return l:rect
endfunction
