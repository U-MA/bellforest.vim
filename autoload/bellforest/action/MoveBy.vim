let s:MoveBy = { 'second' : 0, 'target' : [], 'duration' : 0, 'actor' : {},
  \              'start_position' : [] }

function! s:MoveBy.step(dt) abort
  if self.duration + a:dt > self.second
    if self.target[0] != 0
      let self.actor.position[0] = self.start_position[0] + self.target[0]
    endif

    if self.target[1] != 0
      let self.actor.position[1] = self.start_position[1] + self.target[1]
    endif
  else
    let l:delta = [ self.dps[0] * a:dt, self.dps[1] * a:dt ]
    if self.target[0] != 0
      let self.actor._position[0] += l:delta[0]
    endif

    if self.target[1] != 0
      let self.actor._position[1] += l:delta[1]
    endif
  endif
  let self.duration += a:dt
endfunction

function! s:MoveBy.is_done() abort
  return self.duration >= self.second
endfunction

function! s:MoveBy.stop() abort
  let self.actor._position[0] = float2nr(self.actor._position[0])
  let self.actor._position[1] = float2nr(self.actor._position[1])
endfunction

function! s:MoveBy.delta(dt) abort
  return [ (a:dt / (self.second - self.duration)) * ((self.start_position[0] + self.target[0] - 1) - self.actor._position[0]),
    \      (a:dt / (self.second - self.duration)) * ((self.start_position[1] + self.target[1] - 1) - self.actor._position[1]) ]
endfunction

function! bellforest#action#MoveBy#new(second, delta_position) abort
  let l:moveby = deepcopy(s:MoveBy)
  let l:moveby.second = a:second
  let l:moveby.target = a:delta_position
  let l:moveby.dps    = [ (a:delta_position[0] * 1.0) / a:second, (a:delta_position[1] * 1.0) / a:second ]
  return l:moveby
endfunction
