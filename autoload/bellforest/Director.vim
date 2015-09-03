let s:Director = { 'fps' : 60, 'is_end' : 0, 'pressed_key' : 0 }

function! s:Director.set_fps(fps) abort
  let self.fps = a:fps
endfunction

function! s:Director.set_filetype(filename) abort
  let self.filename = a:filename
endfunction

function! s:Director.run_with_scene(scene) abort
  execute 'tabnew' a:scene.name
  if has_key(self, 'init')
    call self.init()
  endif

  if has_key(self, 'filename')
    execute 'setlocal filetype=' . self.filename
  endif

  let self.is_end = 0

  let self.scene = a:scene
  call self.scene.init()
  call self.scene.child_init()

  let l:start = reltime()
  while !self.is_end
    let l:dt = s:reltime2msec(l:start)
    let self.pressed_key = getchar(0)

    for l:child in self.scene.childs.data
      call l:child.erase()
    endfor

    call bellforest#EventDispatcher#instance().dispatch()

    call bellforest#ActionManager#instance().update(l:dt / 1000.0)

    call bellforest#Scheduler#instance().update(l:dt / 1000.0)

    " draw a:scene
    call self.scene.visit()

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
  return bellforest#EventDispatcher#instance()
endfunction

function! s:Director.replace_scene(scene) abort
  for l:child in self.scene.childs.data
    call l:child.erase()
  endfor
  call self.scene.cleanup()

  let self.scene = a:scene
  call a:scene.init()
  call a:scene.child_init()
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
