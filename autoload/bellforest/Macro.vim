function! bellforest#Macro#create_callback1(funcref, caller) abort
  let l:func = { 'func' : a:funcref, 'caller' : a:caller }
  function! l:func.apply(arg0) abort
    return call(self.func, [ a:arg0 ], self.caller)
  endfunction
  return l:func
endfunction
