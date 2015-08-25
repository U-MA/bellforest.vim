let s:EventDispathcer = { 'listeners' : [] }

function! s:EventDispathcer.add_event_listener(listener) abort
  call add(self.listeners, a:listener)
endfunction

function! s:EventDispathcer.dispatch() abort
  let l:key = bellforest#Director#instance().pressed_key
  for l:listener in self.listeners
    call l:listener.press(nr2char(l:key))
  endfor
endfunction

let s:Director = { 'fps' : 60, 'is_end' : 0, 'pressed_key' : 0 }

function! s:Director.set_fps(fps) abort
  let self.fps = a:fps
endfunction

function! s:Director.run_with_scene(scene) abort
  tabnew XXXXX

  call a:scene.init()

  while !self.is_end
    let self.pressed_key = getchar(0)

    " draw a:scene
    call a:scene.visit()

    call s:EventDispathcer.dispatch()

    redraw
    sleep 16m
  endwhile

  bdelete!
endfunction

function! s:Director.app_end() abort
  let self.is_end = 1
endfunction

function! s:Director.get_event_dispatcher() abort
  return s:EventDispathcer
endfunction

" Director is singleton
function! bellforest#Director#instance() abort
  return s:Director
endfunction
