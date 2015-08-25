let s:Node = { 'position' : [ 1, 1 ], 'width' : 1, 'height' : 1,
  \            'data' : [], 'childs' : [], 'parent' : {} }

function! s:Node.visit() abort
  call self.draw()
  for l:child in self.childs
    call l:child.visit()
  endfor
endfunction

function! s:Node.draw() abort
  if type(self.data) == type('')
    call self.draw_char()
  elseif type(self.data) == type([])
    call self.draw_rect()
  endif
endfunction

function! s:Node.erase() abort
   if type(self.data) == type('')
    call self.erase_char()
  elseif type(self.data) == type([])
    call self.erase_rect()
  endif
endfunction

function! s:Node.erase_rect() abort
   let l:visible_rect = self.visible_rect()

  if l:visible_rect.width > 0 && l:visible_rect.height > 0

    let l:abs_visible_pos = self.convert_absolute(l:visible_rect.position)
    let l:top    = l:abs_visible_pos[0]
    let l:bottom = l:abs_visible_pos[0] + l:visible_rect.height - 1
    let l:cleft  = l:abs_visible_pos[1]
    let l:cright = l:abs_visible_pos[1] + l:visible_rect.width - 1

    let l:lnum = self.absolute_position()[0]
    for l:line in self.data
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
  let l:p_abs_pos = self.parent.absolute_position()
  return [l:p_abs_pos[0] + self.position[0]-1,
    \     l:p_abs_pos[1] + self.position[1]-1]

endfunction

function! s:Node.convert_absolute(position) abort
  let l:abs_pos = self.parent.convert_absolute(self.position)

  return [l:abs_pos[0] + a:position[0] - 1,
    \     l:abs_pos[1] + a:position[1] - 1]
endfunction

function! s:Node.visible_rect() abort
  let l:pvisible = self.parent.visible_rect()

  let l:top    = max([l:pvisible.position[0], self.position[0]])
  let l:bottom = min([l:pvisible.position[0] + l:pvisible.height - 1, self.position[0] + self.height - 1])
  let l:left   = max([l:pvisible.position[1], self.position[1]])
  let l:right  = min([l:pvisible.position[1] + l:pvisible.width - 1, self.position[1] + self.width - 1])

  let l:rect = { 'position' : [ 1, 1 ], 'width' : 1, 'height' : 1 }
  let l:rect.position = [l:top - self.position[0] + 1, l:left - self.position[1] + 1]
  let l:rect.width    = max([0, l:right - l:left + 1])
  let l:rect.height   = max([0, l:bottom - l:top + 1])
  return l:rect
endfunction

function! s:Node.draw_rect() abort
  let l:visible_rect = self.visible_rect()

  if l:visible_rect.width > 0 && l:visible_rect.height > 0
    let l:abs_visible_pos = self.convert_absolute(l:visible_rect.position)
    let l:top    = l:abs_visible_pos[0]
    let l:bottom = l:abs_visible_pos[0] + l:visible_rect.height - 1
    let l:cleft  = l:abs_visible_pos[1]
    let l:cright = l:abs_visible_pos[1] + l:visible_rect.width - 1

    let l:lnum = self.absolute_position()[0]
    for l:line in self.data
      if l:top <= l:lnum && l:lnum <= l:bottom
        let l:bufline = getline(l:lnum)
        let l:left    = l:cleft == 1 ? '' : l:bufline[: l:cleft-2]
        let l:right   = l:bufline[l:cright :]
        let l:subline = l:left . l:line[l:cleft-self.absolute_position()[1] : l:cright-self.absolute_position()[1]] . l:right
        call setline(l:lnum, l:subline)
      endif
      let l:lnum += 1
    endfor
  endif
endfunction

function! s:Node.get_event_dispatcher() abort
  return bellforest#Director#instance().get_event_dispatcher()
endfunction

function! bellforest#Node#new(position, data) abort
  let l:node = deepcopy(s:Node)
  let l:node.position = copy(a:position)
  let l:node.data     = a:data
  let l:node.width    = len(a:data[0])
  let l:node.height   = len(a:data)
  return l:node
endfunction
