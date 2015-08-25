let s:Scene = { 'width' : 0, 'height' : 0, 'childs' : [] }

function! s:Scene.init() abort
  " You may override this function
endfunction

function! s:Scene.add_child(node) abort
  let a:node.parent = self
  call add(self.childs, a:node)
endfunction

function! s:Scene.visit() abort
  for l:child in self.childs
    call l:child.visit()
  endfor
endfunction

function! s:Scene.draw_space(height, width) abort
  let self.height = a:height
  let self.width  = a:width

  let l:white_space = repeat(' ', a:width)
  for l:i in range(1, a:height)
    call setline(l:i, l:white_space)
  endfor
endfunction

function! s:Scene.visible_rect() abort
  let l:rect = {}
  let l:rect.position = [ 1, 1 ]
  let l:rect.width    = self.width
  let l:rect.height   = self.height
  return l:rect
endfunction

function! s:Scene.convert_absolute(position) abort
  return [ a:position[0], a:position[1] ]
endfunction

function! s:Scene.absolute_position() abort
  return [ 1, 1 ]
endfunction

function! bellforest#Scene#new() abort
  return deepcopy(s:Scene)
endfunction
