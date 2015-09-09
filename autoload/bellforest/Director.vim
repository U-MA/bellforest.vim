let s:Director = { '_fps' : 60, '_is_end' : 0, '_pressed_key' : 0 }

function! s:Director.set_fps(fps) abort
  let self._fps = a:fps
endfunction

function! s:Director.set_filetype(filename) abort
  let self.filename = a:filename
endfunction

function! s:Director.run_with_scene(scene) abort
  execute 'tabnew' a:scene.name

  call a:scene.draw_space(a:scene.height, a:scene.width)
  if has_key(self, 'init')
    call self.init()
  endif

  if has_key(self, 'filename')
    execute 'setlocal filetype=' . self.filename
  endif

  let self._is_end = 0

  let self.scene = a:scene
  call self.scene.init()
  call self.scene.child_init()

  let l:start = reltime()
  while !self._is_end
    let l:dt = s:reltime2msec(l:start)
    let self._pressed_key = getchar(0)

    for l:child in self.scene.childs.list()
      call l:child.erase()
    endfor

    call bellforest#EventDispatcher#instance().dispatch()

    call bellforest#ActionManager#instance().update(l:dt / 1000.0)

    call bellforest#Scheduler#instance().update(l:dt / 1000.0)

    " draw a:scene
    call self.scene.visit()

    redraw
    let l:start = reltime()
    execute 'sleep ' float2nr(s:fps2msec(self._fps)) 'm'
  endwhile

  bdelete!
endfunction

function! s:Director.count_childs() abort
  if !has_key(self, 'scene')
    return 0
  endif
  return self.scene.count_childs()
endfunction

function! s:Director.get_info(key) abort
  if a:key ==# 'listeners'
    return printf("listeners: %d", self.get_event_dispatcher().listeners.size())
  elseif a:key ==# 'objects'
    return printf("objects: %d", self.count_childs())
  else
    return 'key not found'
  endif
endfunction

function! s:Director.print_debug(line, key) abort
  let l:info = self.get_info(a:key)
  call setline(a:line, l:info)
endfunction

function! s:Director.end() abort
  let self._is_end = 1

  call self.cleanup()
endfunction

function! s:Director.get_event_dispatcher() abort
  return bellforest#EventDispatcher#instance()
endfunction

function! s:Director.replace_scene(scene) abort
  for l:child in self.scene.childs.list()
    call l:child.erase()
  endfor
  call self.scene.cleanup()

  let self.scene = a:scene
  call a:scene.init()
  call a:scene.child_init()
endfunction

function! s:Director.cleanup() abort
  " all sigletons reset
  call bellforest#EventDispatcher#instance().remove_all_events()
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
