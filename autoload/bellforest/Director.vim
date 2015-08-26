let s:EventDispathcer = { 'listeners' : [] }

function! s:EventDispathcer.add_event_listener(listener) abort
  call add(self.listeners, a:listener)
endfunction

function! s:EventDispathcer.dispatch() abort
  let l:key = bellforest#Director#instance().pressed_key
  for l:listener in self.listeners
    if type(l:listener.press) == type(function('tr'))
      call l:listener.press(nr2char(l:key))
    else
      call l:listener.press.apply(nr2char(l:key))
    endif
  endfor
endfunction


let s:Director = { 'fps' : 60, 'is_end' : 0, 'pressed_key' : 0 }

function! s:Director.set_fps(fps) abort
  let self.fps = a:fps
endfunction

function! s:Director.run_with_scene(scene) abort
  execute 'tabnew' a:scene.name

  let self.is_end = 0

  call a:scene.init()
  call a:scene.child_init()

  let l:start = reltime()
  while !self.is_end
    let l:dt = s:reltime2msec(l:start)
    let self.pressed_key = getchar(0)

    for l:child in a:scene.childs
      call l:child.erase()
    endfor

    call s:EventDispathcer.dispatch()

    call bellforest#ActionManager#instance().update(l:dt / 1000.0)

    call bellforest#Scheduler#instance().update()

    " draw a:scene
    call a:scene.visit()

    redraw
    let l:start = reltime()
    execute 'sleep ' float2nr(s:fps2msec(self.fps)) 'm'
  endwhile

  bdelete!
endfunction

function! s:Director.end() abort
  let self.is_end = 1
endfunction

function! s:Director.get_event_dispatcher() abort
  return s:EventDispathcer
endfunction

" Director is singleton
function! bellforest#Director#instance() abort
  return s:Director
endfunction

function! s:fps2msec(fps) abort
  return (1.0 / a:fps) * 1000
endfunction

function! s:reltime2msec(start) abort
  let l:time = reltime(a:start)
  let l:sec  = l:time[0]
  let l:msec = l:time[1] " マイクロ秒
  return l:sec * 1000.0 + l:msec / 1000.0
endfunction
