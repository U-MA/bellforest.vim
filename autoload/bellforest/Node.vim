let s:Node = {}

function! s:Node.init() abort
  " You may override this function
endfunction

function! s:Node.set_data(list) abort
  let self._data = a:list
endfunction

function! s:Node.set_position(position) abort
  let self._position = copy(a:position)
endfunction

function! s:Node.schedule_update() abort
  call bellforest#Scheduler#instance().schedule(self)
endfunction

function! s:Node.unschedule_update() abort
  call bellforest#Scheduler#instance().unschedule(self)
endfunction

function! s:Node.run_action(action) abort
  call bellforest#ActionManager#instance().add_action(self, a:action)
endfunction

function! s:Node.remove_child(child) abort
  call self._childs.erase_object(a:child)
endfunction

function! s:Node.remove_from_parent() abort
  call self._parent.remove_child(self)
endfunction

function! s:Node.count_childs() abort
  let l:count = self._childs.size()
  for l:child in self._childs.list()
    let l:count += l:child.count_childs()
  endfor
  return l:count
endfunction

function! s:Node.child_init() abort
  for l:child in self._childs.list()
    call l:child.init()
    call l:child.child_init()
  endfor
endfunction

function! s:Node.visit() abort
  call self.draw()
  for l:child in self._childs.list()
    call l:child.visit()
  endfor
endfunction

function! s:Node.draw() abort
  if type(self._data) == type('')
    "TODO
    "call self.draw_char()
  elseif type(self._data) == type([])
    call self.draw_rect()
  endif
endfunction

function! s:Node.rect() abort
  return bellforest#Rect#new(self._position, self._width, self._height)
endfunction

function! s:Node.add_child(child) abort
  let a:child._parent = self
  call self._childs.push_back(a:child)
endfunction

function! s:Node.draw_rect() abort
  let l:visible_rect = self.visible_rect()

  if l:visible_rect.width > 0 && l:visible_rect.height > 0
    let l:abs_visible_pos = self.convert_absolute(l:visible_rect.position)
    let l:top    = float2nr(l:abs_visible_pos[0])
    let l:bottom = float2nr(l:abs_visible_pos[0] + l:visible_rect.height - 1)
    let l:cleft  = float2nr(l:abs_visible_pos[1])
    let l:cright = float2nr(l:abs_visible_pos[1] + l:visible_rect.width - 1)

    let l:lnum = float2nr(self.absolute_position()[0])
    for l:line in self._data
      if l:top <= l:lnum && l:lnum <= l:bottom
        let l:bufline = getline(l:lnum)
        let l:left    = l:cleft == 1 ? '' : l:bufline[: l:cleft-2]
        let l:right   = l:bufline[l:cright :]
        let l:subline = l:left . l:line[l:cleft-float2nr(self.absolute_position()[1]) : l:cright-float2nr(self.absolute_position()[1])] . l:right
        call setline(l:lnum, l:subline)
      endif
      let l:lnum += 1
    endfor
  endif
endfunction


function! s:Node.erase() abort
   if type(self._data) == type('')
     "TODO
     "call self.erase_char()
  elseif type(self._data) == type([])
    call self.erase_rect()
  endif
endfunction

function! s:Node.erase_rect() abort
   let l:visible_rect = self.visible_rect()

  if l:visible_rect.width > 0 && l:visible_rect.height > 0

    let l:abs_visible_pos = self.convert_absolute(l:visible_rect.position)
    let l:top    = float2nr(l:abs_visible_pos[0])
    let l:bottom = float2nr(l:abs_visible_pos[0] + l:visible_rect.height - 1)
    let l:cleft  = float2nr(l:abs_visible_pos[1])
    let l:cright = float2nr(l:abs_visible_pos[1] + l:visible_rect.width - 1)

    let l:lnum = float2nr(self.absolute_position()[0])
    for l:line in self._data
      if l:top <= l:lnum && l:lnum <= l:bottom
        let l:bufline = getline(l:lnum)
        let l:left    = l:cleft == 1 ? '' : l:bufline[: l:cleft-2]
        let l:right   = l:bufline[l:cright :]
        let l:subline = l:left . repeat(' ', l:cright-l:cleft+1) . l:right
        call setline(l:lnum, l:subline)
      endif
      let l:lnum += 1
    endfor
  endif
endfunction

function! s:Node.absolute_position() abort
  let l:p_abs_pos = self._parent.absolute_position()
  return [l:p_abs_pos[0] + self._position[0]-1,
    \     l:p_abs_pos[1] + self._position[1]-1]

endfunction

function! s:Node.convert_absolute(position) abort
  let l:abs_pos = self._parent.convert_absolute(self._position)

  return [l:abs_pos[0] + a:position[0] - 1,
    \     l:abs_pos[1] + a:position[1] - 1]
endfunction

function! s:max(x, y) abort
  if a:x > a:y
    return a:x
  else
    return a:y
  endif
endfunction

function! s:min(x, y) abort
  if a:x < a:y
    return a:x
  else
    return a:y
  endif
endfunction

function! s:Node.visible_rect() abort
  let l:pvisible = self._parent.visible_rect()

  let l:top    = s:max(l:pvisible.position[0], self._position[0])
  let l:bottom = s:min(l:pvisible.position[0] + l:pvisible.height - 1, self._position[0] + self._height - 1)
  let l:left   = s:max(l:pvisible.position[1], self._position[1])
  let l:right  = s:min(l:pvisible.position[1] + l:pvisible.width - 1, self._position[1] + self._width - 1)

  let l:rect = { 'position' : [ 1, 1 ], 'width' : 1, 'height' : 1 }
  let l:rect.position = [l:top - self._position[0] + 1, l:left - self._position[1] + 1]
  let l:rect.width    = s:max(0, l:right - l:left + 1)
  let l:rect.height   = s:max(0, l:bottom - l:top + 1)
  return l:rect
endfunction

function! s:Node.get_event_dispatcher() abort
  return bellforest#Director#instance().get_event_dispatcher()
endfunction

function! bellforest#Node#new(...) abort
  let l:node = deepcopy(s:Node)
  if a:0
    let l:node._position = copy(a:000[0])
    let l:node._data     = a:000[1]
    let l:node._width    = len(l:node._data[0])
    let l:node._height   = len(l:node._data)
  else
    let l:node._position = [1, 1]
    let l:node._data     = []
    let l:node._width    = 0
    let l:node._height   = 0
  endif
  let l:node._parent   = {}
  let l:node._childs   = bellforest#util#Vector#new()
  return l:node
endfunction
