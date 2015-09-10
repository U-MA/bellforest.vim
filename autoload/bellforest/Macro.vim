function! bellforest#Macro#create_callback1(funcref, caller) abort
  let l:func = { '_func' : a:funcref, '_caller' : a:caller }
  function! l:func.apply(arg0) abort
    return call(self._func, [ a:arg0 ], self._caller)
  endfunction
  return l:func
endfunction
