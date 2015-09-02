let s:Sequence = { 'now' : 0 }
let s:Sequence.actions = bellforest#util#Vector#new()

function! s:Sequence.size() abort
  return len(self.actions.data)
endfunction

function! s:Sequence.current_action() abort
  return self.actions.get(self.now)
endfunction

function! s:Sequence.step(dt) abort
  let l:current_action = self.current_action()
  if empty(l:current_action.actor)
    let l:current_action.actor = self.actor
    let l:current_action.start_position = copy(self.actor.position)
  endif

  call l:current_action.step(a:dt)
  if l:current_action.is_done()
    call l:current_action.stop()
    let self.now += 1
  endif
endfunction

function! s:Sequence.is_done() abort
  return self.size() <= self.now
endfunction

function! s:Sequence.stop() abort
  " TODO
endfunction

function! bellforest#action#Sequence#new(...) abort
  let l:sequence = deepcopy(s:Sequence)
  for l:i in range(a:0)
    call l:sequence.actions.push_back(a:000[l:i])
  endfor
  return l:sequence
endfunction
