let s:ActionManager = { 'elements' : [] }

function! s:ActionManager.add_action(actor, action) abort
  let a:action.actor = a:actor
  let a:action.start_position = copy(a:actor.position)
  call add(self.elements, a:action)
endfunction

function! s:ActionManager.update(dt) abort
  let l:will_remove = []
  for l:i in range(len(self.elements))
    let l:element = self.elements[l:i]

    call l:element.step(a:dt)
    if l:element.is_done()
      call l:element.stop()

      call add(l:will_remove, l:i)
    endif
  endfor

  for l:i in reverse(l:will_remove)
    call remove(self.elements, l:i)
  endfor
endfunction

" ActionManager is singleton
function! bellforest#ActionManager#instance() abort
  return s:ActionManager
endfunction
