" Determine if normal YAML or Concourse YAML
" Language: Concourse Flavored YAML
" Author:   Luan Santos <vim@luan.sh>
" URL:      https://github.com/luan/vim-concourse

autocmd BufNewFile,BufRead *.yml,*.yaml  call s:SelectConcourse()

fun! s:SelectConcourse()
  " Bail out if 'filetype' is already set to "concourse".
  if index(split(&ft, '\.'), 'concourse') != -1
    return
  endif

  let lines = join(getline('1', '$'), "\n")

  let grep = 'grep -E'
  if executable('ag')
    let grep = 'ag'
  endif

  let fp = expand("<afile>:p")
  let concourseRegex = '^(groups|resources|jobs):'
  let concourseKeyCount = system('cat ' . fp . ' | ' . grep . ' "' . concourseRegex . '" | wc -l')

  if concourseKeyCount =~# '3'
    execute 'set filetype=concourse'
  else
  endif
endfun
