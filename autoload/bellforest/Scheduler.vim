let s:Scheduler = { 'nodes' : [] }

function! s:Scheduler.schedule(node) abort
  call add(self.nodes, a:node)
endfunction

function! s:Scheduler.update() abort
  for l:node in self.nodes
    call l:node.update()
  endfor
endfunction

" Scheduler is singleton
function! bellforest#Scheduler#instance() abort
  return s:Scheduler
endfunction
