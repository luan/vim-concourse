" Check if tagbar is installed under plugins or is directly under rtp
" this covers pathogen + Vundle/Bundle
"
" Also make sure the ctags command exists
"
if !executable('ctags')
    finish
elseif globpath(&rtp, 'plugin/tagbar.vim') == ""
    finish
endif

function! s:SetTagbar()
    if !exists("g:concourse_flytags_bin")
        let g:concourse_flytags_bin = "flytags"
    endif
    let bin_path = concourse#CheckBinPath(g:concourse_flytags_bin)
    if empty(bin_path)
        return
    endif

    if !exists("g:tagbar_type_concourse")
        let g:tagbar_type_concourse = {
            \ 'ctagstype' : 'concourse',
            \ 'kinds'     : [
                \ 'p:primitives',
                \ 't:resource_types',
                \ 'g:groups',
                \ 'r:resources',
                \ 'i:inputs',
                \ 'k:tasks',
                \ 'o:outputs',
                \ 'j:jobs',
            \ ],
            \ 'sro' : '.',
            \ 'kind2scope' : {
                \ 'p' : 'ptype',
                \ 'j' : 'stype'
            \ },
            \ 'scope2kind' : {
                \ 'ptype' : 'p',
                \ 'stype' : 'j'
            \ },
            \ 'ctagsbin'  : expand(bin_path),
            \ 'ctagsargs' : '-sort -silent'
        \ }
    endif
endfunction

call s:SetTagbar()
