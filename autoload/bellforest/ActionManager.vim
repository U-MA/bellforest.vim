let s:ActionManager = { 'elements' : [] }

function! s:ActionManager.add_action(actor, action) abort
  let a:action.actor = a:actor
  call add(self.elements, a:action)
endfunction

function! s:ActionManager.update(dt) abort
  for l:i in range(len(self.elements))
    let l:element = self.elements[l:i]

    call l:element.step(a:dt)
    if l:element.is_done()
      call l:element.stop()

      call remove(self.elements, l:i)
    endif
  endfor
endfunction

" ActionManager is singleton
function! bellforest#ActionManager#instance() abort
  return s:ActionManager
endfunction
