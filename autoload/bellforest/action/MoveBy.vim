let s:MoveBy = { 'second' : 0, 'target' : [], 'duration' : 0, 'actor' : {},
  \              'start_position' : [] }

function! s:MoveBy.step(dt) abort
  let l:delta = self.delta(a:dt)
  if self.target[0] != 0
    let self.actor.position[0] += l:delta[0]
  endif

  if self.target[1] != 0
    let self.actor.position[1] += l:delta[1]
  endif

  let self.duration += a:dt
endfunction

function! s:MoveBy.is_done() abort
  return self.duration >= self.second
endfunction

function! s:MoveBy.stop() abort
  " TODO
endfunction

function! s:MoveBy.delta(dt) abort
  return [ (a:dt / (self.second - self.duration)) * ((self.start_position[0] + self.target[0] - 1) - self.actor.position[0]),
    \      (a:dt / (self.second - self.duration)) * ((self.start_position[1] + self.target[1] - 1) - self.actor.position[1]) ]
endfunction

function! bellforest#action#MoveBy#new(second, delta_position) abort
  let l:moveby = deepcopy(s:MoveBy)
  let l:moveby.second = a:second
  let l:moveby.target = a:delta_position
  return l:moveby
endfunction
