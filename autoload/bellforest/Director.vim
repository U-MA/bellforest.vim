let s:EventDispathcer = { 'listeners' : [] }

function! s:EventDispathcer.add_event_listener(listener) abort
  call add(self.listeners, a:listener)
endfunction

function! s:EventDispathcer.dispatch() abort
endfunction

let s:Director = { 'fps' : 60 }

function! s:Director.set_fps(fps) abort
  let self.fps = a:fps
endfunction

function! s:Director.run_with_scene(scene) abort
  tabnew XXXXX

  call a:scene.init()

  " draw a:scene
  call a:scene.visit()
endfunction

" Director is singleton
function! bellforest#Director#instance() abort
  return s:Director
endfunction
