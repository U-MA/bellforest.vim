let s:Sequence = { '_now' : 0 }
let s:Sequence._actions = bellforest#util#Vector#new()

function! s:Sequence.size() abort
  return self._actions.size()
endfunction

function! s:Sequence.current_action() abort
  return self._actions.get(self._now)
endfunction

function! s:Sequence.step(dt) abort
  let l:current_action = self.current_action()
  if empty(l:current_action._actor)
    let l:current_action._actor = self._actor
    let l:current_action._start_position = copy(self._actor._position)
  endif

  call l:current_action.step(a:dt)
  if l:current_action.is_done()
    call l:current_action.stop()
    let self._now += 1
  endif
endfunction

function! s:Sequence.is_done() abort
  return self.size() <= self._now
endfunction

function! s:Sequence.stop() abort
  " TODO
endfunction

function! bellforest#action#Sequence#new(...) abort
  let l:sequence = deepcopy(s:Sequence)
  for l:i in range(a:0)
    call l:sequence._actions.push_back(a:000[l:i])
  endfor
  return l:sequence
endfunction
