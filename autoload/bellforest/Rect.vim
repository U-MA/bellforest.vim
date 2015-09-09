let s:Rect = {}

function! s:Rect.intersect(rect) abort
  return self._position[0] <= a:rect._position[0] + a:rect._height - 1 &&
    \    self._position[0] + self._height - 1 >= a:rect._position[0] &&
    \    self._position[1] <= a:rect._position[1] + a:rect._width - 1 &&
    \    self._position[1] + self._width - 1 >= a:rect._position[1]
endfunction

function! bellforest#Rect#new(position, width, height) abort
  let l:rect = deepcopy(s:Rect)
  let l:rect._position = copy(a:position)
  let l:rect._width    = a:width
  let l:rect._height   = a:height
  return l:rect
endfunction
