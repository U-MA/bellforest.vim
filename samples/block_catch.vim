" s:score_node {{{
let s:score_node = bellforest#Node#new([1, 1], [
  \ '+- Score -+',
  \ '|         |',
  \ '+---------+',
  \ ])

" data member {{{
let s:score_node.point       = 0
let s:score_node.point_label = bellforest#Label#new()
let s:label_init_x           = 0
" }}}

function! s:score_node.init() abort " {{{
  call self.point_label.set_position([2, 9])
  let self.label_init_x = self.point_label.position[1]
  call self.point_label.set_text(string(self.point))
  call self.add_child(self.point_label)
endfunction " }}}

function! s:score_node.update_point() abort " {{{
  let self.point += 1
  let self.point_label.position[1] = self.label_init_x + 1 - len(self.point)
  call self.point_label.set_text(string(self.point))
endfunction " }}}

" }}}

" s:timer_node {{{
let s:timer_node = bellforest#Node#new([1, 15], [
  \ '+- Timer -+',
  \ '|         |',
  \ '+---------+',
  \ ])

" data member {{{
let s:timer_node.time        = 0
let s:timer_node.timer_label = bellforest#Label#new()
"}}}

function! s:timer_node.init() abort " {{{
  let self.time = 30 " second

  call self.timer_label.set_position([2, 8])
  call self.timer_label.set_text(string(self.time))
  call self.add_child(self.timer_label)
endfunction " }}}

function! s:timer_node.update_timer(dt) abort " {{{
  let self.time -= a:dt
  call self.timer_label.set_text(string(float2nr(self.time + 0.5)))
endfunction " }}}

" }}}

" s:scene {{{
let s:scene = bellforest#Scene#new('BlockCatch')

" data member {{{
let s:scene.rng         = bellforest#util#Random#new()
let s:scene.blocks      = bellforest#util#Vector#new()
let s:scene.point_node  = s:score_node
let s:scene.timer_node  = s:timer_node
let s:scene.state       = 'before' " state is before, ready, play
" }}}

function! s:scene.init() abort " {{{
  call self.draw_space(20, 40)

  let self.state = 'before'
  let self.time  = 1

  function! s:app_end(key) abort " {{{
    if a:key == 'Q'
      call bellforest#Director#instance().end()
    endif
  endfunction " }}}

  let l:listener = bellforest#EventListenerKeyPressed#new()
  let l:listener.press = function('s:app_end')
  call self.get_event_dispatcher().add_event_listener(l:listener)

  call self.add_background()
  call self.add_child(self.point_node)
  call self.add_child(self.timer_node)
  call self.add_basket()
  call self.add_howto_node()

  function! s:scene.press_start(key) abort
    if a:key ==# 'j'
      let self.state = 'ready'
      call self.start()
    endif
  endfunction

  let self.start_listener = bellforest#EventListenerKeyPressed#new()
  let self.start_listener.press = bellforest#Macro#create_callback1(s:scene.press_start, self)
  call self.get_event_dispatcher().add_event_listener(self.start_listener)

  call self.schedule_update()
endfunction " }}}

function! s:scene.update(dt) abort " {{{
  if self.state ==# 'play'
    call self.timer_node.update_timer(a:dt)

    if self.rng.rand() % 70 == 0
      call self.add_block()
    endif

    let l:basket_rect = self.basket.rect()
    for l:block in self.blocks.data
      if l:basket_rect.intersect(l:block.rect())
        call self.point_node.update_point()
        call self.blocks.erase_object(l:block)
        call self.remove_child(l:block)
      endif
    endfor

    " FINISH GAME
    if self.timer_node.time < 0
      call self.unschedule_update()
      let l:dispatcher = self.get_event_dispatcher()
      call l:dispatcher.remove_event_listener(self.listener)

      function! s:restart(key) abort
        if a:key ==# 'R'
          call bellforest#Director#instance().replace_scene(s:scene.create())
        endif
      endfunction

      let l:listener = bellforest#EventListenerKeyPressed#new()
      let l:listener.press = function('s:restart')
      call l:dispatcher.add_event_listener(l:listener)

      call self.add_finish_node()
    endif
  elseif self.state ==# 'ready'
    if self.time < 0
      call self.remove_child(self.ready_node)
      let self.state = 'play'
    else
      let self.time -= a:dt
    endif
  elseif self.state ==# 'before'
  endif
endfunction " }}}

function! s:scene.start() abort " {{{
  call self.get_event_dispatcher().remove_event_listener(self.start_listener)
  call self.remove_child(self.howto_node)

  let l:info = bellforest#Node#new([10, 15], [
    \ '+---------+',
    \ '|         |',
    \ '+---------+',
    \ ])
  let l:info_label = bellforest#Label#new()
  let l:info_label.set_position([2, 4])
  let l:info_label.set_text('READY')
  call l:info.add_child(l:info_label)
  let self.ready_node = l:info
  call self.add_child(l:info)
endfunction " }}}

function! s:scene.add_background() abort " {{{
  let l:ground = bellforest#Node#new([20, 1], [
    \ '========================================',
    \ ])
  call self.add_child(l:ground)
endfunction " }}}

function! s:scene.add_basket() abort " {{{
  let l:basket = bellforest#Node#new([18, 17], [
    \ '|     |',
    \ '+-----+',
    \ ])
  let self.basket = l:basket

  function! l:basket.press(key) abort
    if a:key == 'h'
      let self.position[1] -= 1
    elseif a:key == 'l'
      let self.position[1] += 1
    endif
  endfunction
  let self.listener = bellforest#EventListenerKeyPressed#new()
  let self.listener.press = bellforest#Macro#create_callback1(l:basket.press, l:basket)
  call l:basket.get_event_dispatcher().add_event_listener(self.listener)

  call self.add_child(l:basket)
endfunction " }}}

function! s:scene.add_block() abort " {{{
  let l:x = self.rng.rand() % self.width
  let l:block = bellforest#Node#new([ 4, l:x ], [
    \ '##',
    \ '##',
    \ ])
  let l:fall = bellforest#action#MoveBy#new(5, [ 20, 0 ])
  call l:block.run_action(l:fall)
  call self.blocks.push_back(l:block)
  call self.add_child(l:block)
endfunction " }}}

function! s:scene.add_howto_node() abort " {{{
  let l:node = bellforest#Node#new([5, 13], [
    \ '+-------------+',
    \ '| HOW TO PLAY |',
    \ '|             |',
    \ '| Move left   |',
    \ '|    press h  |',
    \ '|             |',
    \ '| Move right  |',
    \ '|    press l  |',
    \ '|             |',
    \ '| Start       |',
    \ '|    press j  |',
    \ '+-------------+',
    \ ])
  let self.howto_node = l:node
  call self.add_child(l:node)
endfunction " }}}

function! s:scene.add_finish_node() abort " {{{
  let l:node = bellforest#Node#new([7, 14], [
    \ '+------------+',
    \ '|   FINISH   |',
    \ '|            |',
    \ '| Restart    |',
    \ '|    press R |',
    \ '|            |',
    \ '| Quit       |',
    \ '|    press Q |',
    \ '+------------+',
    \ ])
  call self.add_child(l:node)
endfunction " }}}

function! s:scene.create() abort " {{{
  return deepcopy(s:scene)
endfunction " }}}

" }}}

call bellforest#Director#instance().run_with_scene(s:scene.create())
