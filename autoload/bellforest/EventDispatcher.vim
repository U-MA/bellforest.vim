let s:EventDispatcher = { 'listeners' : [] }
let s:EventDispatcher.listeners = bellforest#util#Vector#new()

function! s:EventDispatcher.add_event_listener(listener) abort
  call self.listeners.push_back(a:listener)
endfunction

function! s:EventDispatcher.remove_event_listener(listener) abort
  call self.listeners.erase_object(a:listener)
endfunction

function! s:EventDispatcher.dispatch() abort
  let l:key = bellforest#Director#instance().pressed_key
  for l:listener in self.listeners.data
    if type(l:listener.press) == type(function('tr'))
      call l:listener.press(nr2char(l:key))
    else
      call l:listener.press.apply(nr2char(l:key))
    endif
  endfor
endfunction

function! bellforest#EventDispatcher#instance() abort
  return s:EventDispatcher
endfunction
