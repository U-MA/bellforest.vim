let s:Scheduler = { '_nodes' : {} }
let s:Scheduler._nodes = bellforest#util#Vector#new()

function! s:Scheduler.schedule(node) abort
  call self._nodes.push_back(a:node)
  "call add(self.nodes, a:node)
endfunction

function! s:Scheduler.unschedule(node) abort
  call self._nodes.erase_object(a:node)
endfunction

function! s:Scheduler.update(dt) abort
  for l:node in self._nodes.list()
    call l:node.update(a:dt)
  endfor
endfunction

" Scheduler is singleton
function! bellforest#Scheduler#instance() abort
  return s:Scheduler
endfunction
