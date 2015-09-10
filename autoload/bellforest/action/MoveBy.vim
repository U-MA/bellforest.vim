let s:MoveBy = { '_second' : 0, '_target' : [], '_duration' : 0, '_actor' : {},
  \              '_start_position' : [] }

function! s:MoveBy.step(dt) abort
  if self._duration + a:dt > self._second
    if self._target[0] != 0
      let self._actor._position[0] = self._start_position[0] + self._target[0]
    endif

    if self._target[1] != 0
      let self._actor._position[1] = self._start_position[1] + self._target[1]
    endif
  else
    let l:delta = [ self._dps[0] * a:dt, self._dps[1] * a:dt ]
    if self._target[0] != 0
      let self._actor._position[0] += l:delta[0]
    endif

    if self._target[1] != 0
      let self._actor._position[1] += l:delta[1]
    endif
  endif
  let self._duration += a:dt
endfunction

function! s:MoveBy.is_done() abort
  return self._duration >= self._second
endfunction

function! s:MoveBy.stop() abort
  let self._actor._position[0] = float2nr(self._actor._position[0])
  let self._actor._position[1] = float2nr(self._actor._position[1])
endfunction

function! s:MoveBy.delta(dt) abort
  return [ (a:dt / (self._second - self._duration)) * ((self._start_position[0] + self._target[0] - 1) - self._actor._position[0]),
    \      (a:dt / (self._second - self._duration)) * ((self._start_position[1] + self._target[1] - 1) - self._actor._position[1]) ]
endfunction

function! bellforest#action#MoveBy#new(second, delta_position) abort
  let l:moveby = deepcopy(s:MoveBy)
  let l:moveby._second = a:second
  let l:moveby._target = a:delta_position
  let l:moveby._dps    = [ (a:delta_position[0] * 1.0) / a:second, (a:delta_position[1] * 1.0) / a:second ]
  return l:moveby
endfunction
