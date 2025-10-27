" COMPILER starting with b
let g:asyncrun_open = 16

fu! BuildWalrus()
  AsyncRun . ./util/common_alias.sh && bwalrus_so
endf

let g:ctest_dir = 0
fu! TestRerunWalrus()
  echo "CTEST_DIR:" g:ctest_dir
  execute 'AsyncRun -cwd=' . g:ctest_dir . ' source ~/.zshrc && pwd && rerun_walrus --print-condensed --print-after="lower_kernel,post_sched" '
endf

fu! TestUnitTest(instance, target = "")
  echo expand('%')
  echo expand("<cword>")

  if a:target == ""
    execute 'AsyncRun sba; sp; pytest ' . expand("%") . ' -k ' . expand("<cword>") . ' --target-instance-family=' . a:instance
  else
    execute 'AsyncRun sba; sp; pytest ' . expand("%") . ' -k ' . expand("<cword>") . ' --target-instance-family=' . a:instance . ' --target ' . a:target
  endif
endf

fu! MonitorUnitTest(instance)
  echo expand('%')
  echo expand("<cword>")

  execute 'AsyncRun -cwd=' . expand("<cword>")
endf

" either trn1 or 2
fu! IsTrn1TestLine(line) 
  if stridx(a:line, "s3") 
    return 0
  endif
  if stridx(a:line, "lnc=1") >= 0 || stridx(a:line, "trn1") >= 0
    return 1
  endif
  return 0
endf

fu! AdvanceUnitTest() range
  for linenr in range(a:firstline, a:lastline)
    if IsTrn1TestLine(getline(linenr)) == 1
      echo getline(linenr))
    endif
    echo getline(linenr))
  endfor
endf

au FileType python set tabstop=2 softtabstop=2 shiftwidth=2 expandtab

" DEV SHORTCUTS
nnoremap <Leader>tp :call TogglePrefix()<CR>
nnoremap <Leader>as :AsyncStop<CR>
nnoremap <Leader>bw :call BuildWalrus()<CR>
nnoremap <Leader>bb :AsyncRun brazil-build<CR>
nnoremap <Leader>tw :call TestRerunWalrus()<CR>
nnoremap <Leader>tu :call TestUnitTest("trn2")
