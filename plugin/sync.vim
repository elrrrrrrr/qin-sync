let s:exepath = expand('%:p:h') . '/.sync'
if filereadable(s:exepath)
  au BufWritePost *.vm :silent call QinSync()
endif

function QinSync()
  let l:currentPath = expand('%')
  exe '!' . s:exepath . ' ' . l:currentPath ' > /dev/null &'
endfunction
