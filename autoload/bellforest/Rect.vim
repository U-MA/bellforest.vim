let s:Rect = { 'position' : [ 1, 1 ], 'width' : 0, 'height' : 0 }

function! s:Rect.intersect(rect) abort
  return self.position[0] <= a:rect.position[0] + a:rect.height - 1 &&
    \    self.position[0] + self.height - 1 >= a:rect.position[0] &&
    \    self.position[1] <= a:rect.position[1] + a:rect.width - 1 &&
    \    self.position[1] + self.width - 1 >= a:rect.position[1]
endfunction

function! bellforest#Rect#new(position, width, height) abort
  let l:rect = deepcopy(s:Rect)
  let l:rect.position = copy(a:position)
  let l:rect.width    = a:width
  let l:rect.height   = a:height
  return l:rect
endfunction
