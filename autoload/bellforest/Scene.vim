let s:Scene = { '_name' : '', '_width' : 0, '_height' : 0, '_childs' : [] }

function! s:Scene.init() abort
  " You may override this function
endfunction

function! s:Scene.name() abort
  return self._name
endfunction

function! s:Scene.height() abort
  return self._height
endfunction

function! s:Scene.width() abort
  return self._width
endfunction

function! s:Scene.add_child(node) abort
  let a:node._parent = self
  call self._childs.push_back(a:node)
  "call add(self.childs, a:node)
endfunction

function! s:Scene.remove_child(child) abort
  call self._childs.erase_object(a:child)
endfunction

function! s:Scene.schedule_update() abort
  call bellforest#Scheduler#instance().schedule(self)
endfunction

function! s:Scene.unschedule_update() abort
  call bellforest#Scheduler#instance().unschedule(self)
endfunction

function! s:Scene.cleanup() abort
  call bellforest#EventDispatcher#instance().remove_event_with_target(self)
endfunction

function! s:Scene.visit() abort
  for l:child in self._childs.list()
    call l:child.visit()
  endfor
endfunction

function! s:Scene.count_childs() abort
  let l:count = 0
  for l:child in self._childs.list()
    let l:count += l:child.count_childs() + 1
  endfor
  return l:count
endfunction

function! s:Scene.draw_space(height, width) abort
  let self._height = a:height
  let self._width  = a:width

  let l:white_space = repeat(' ', a:width)
  for l:i in range(1, a:height)
    call setline(l:i, l:white_space)
  endfor
endfunction

function! s:Scene.visible_rect() abort
  let l:rect = {}
  let l:rect.position = [ 1, 1 ]
  let l:rect.width    = self._width
  let l:rect.height   = self._height
  return l:rect
endfunction

function! s:Scene.convert_absolute(position) abort
  return [ a:position[0], a:position[1] ]
endfunction

function! s:Scene.absolute_position() abort
  return [ 1, 1 ]
endfunction

function! s:Scene.get_event_dispatcher() abort
  return bellforest#Director#instance().get_event_dispatcher()
endfunction

function! s:Scene.child_init() abort
  for l:child in self._childs.list()
    call l:child.init()
    call l:child.child_init()
  endfor
endfunction

function! bellforest#Scene#new(name, ...) abort
  let l:scene = deepcopy(s:Scene)
  let l:scene._name = a:name
  if a:0 > 0
    let l:scene._height = a:000[0]
    let l:scene._width  = a:000[1]
  endif
  let l:scene._childs = bellforest#util#Vector#new()
  return l:scene
endfunction
