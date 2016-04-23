" install necessary Concourse tools
if exists("g:concourse_loaded_install")
    finish
endif
let g:go_loaded_install = 1


" these packages are used by vim-concourse and can be automatically installed if
" needed by the user with GoInstallBinaries
let s:packages = [
            \ "github.com/luan/flytags",
            \ ]

" These commands are available on any filetypes
command! ConcourseInstallBinaries call s:ConcourseInstallBinaries(-1)
command! ConcourseUpdateBinaries call s:ConcourseInstallBinaries(1)

" ConcourseInstallBinaries downloads and install all necessary binaries stated
" in the packages variable. It uses by default $GOBIN or $GOPATH/bin as the
" binary target install directory. ConcourseInstallBinaries doesn't install
" binaries if they exist, to update current binaries pass 1 to the argument.
function! s:ConcourseInstallBinaries(updateBinaries)
    if $GOPATH == ""
        echohl Error
        echomsg "vim-concourse: $GOPATH is not set"
        echohl None
        return
    endif

    let err = s:CheckBinaries()
    if err != 0
        return
    endif

    let concourse_bin_path = concourse#BinPath()

    " change $GOBIN so go get can automatically install to it
    let $GOBIN = concourse_bin_path

    " old_path is used to restore users own path
    let old_path = $PATH

    " vim's executable path is looking in PATH so add our go_bin path to it
    let $PATH = $PATH . concourse#PathListSep() . concourse_bin_path

    " when shellslash is set on MS-* systems, shellescape puts single quotes
    " around the output string. cmd on Windows does not handle single quotes
    " correctly. Unsetting shellslash forces shellescape to use double quotes
    " instead.
    let resetshellslash = 0
    if has('win32') && &shellslash
        let resetshellslash = 1
        set noshellslash
    endif

    let cmd = "go get -u -v "

    let s:go_version = matchstr(system("go version"), '\d.\d.\d')

    " https://github.com/golang/go/issues/10791
    if s:go_version > "1.4.0" && s:go_version < "1.5.0"
        let cmd .= "-f "
    endif

    for pkg in s:packages
        let basename = fnamemodify(pkg, ":t")
        let binname = "go_" . basename . "_bin"

        let bin = basename
        if exists("g:{binname}")
            let bin = g:{binname}
        endif

        if !executable(bin) || a:updateBinaries == 1
            if a:updateBinaries == 1
                echo "vim-concourse: Updating ". basename .". Reinstalling ". pkg . " to folder " . concourse_bin_path
            else
                echo "vim-concourse: ". basename ." not found. Installing ". pkg . " to folder " . concourse_bin_path
            endif


            let out = system(cmd . shellescape(pkg))
            if v:shell_error
                echo "Error installing ". pkg . ": " . out
            endif
        endif
    endfor

    " restore back!
    let $PATH = old_path
    if resetshellslash
        set shellslash
    endif
endfunction

" CheckBinaries checks if the necessary binaries to install the Go tool
" commands are available.
function! s:CheckBinaries()
    if !executable('go')
        echohl Error | echomsg "vim-concourse: go executable not found." | echohl None
        return -1
    endif

    if !executable('git')
        echohl Error | echomsg "vim-concourse: git executable not found." | echohl None
        return -1
    endif
endfunction

" FlyTags generates ctags for the current buffer
function! s:FlyTags()
    if &filetype != "concourse"
        return
    endif

    let bin_path = concourse#CheckBinPath(g:concourse_flytags_bin)
    if empty(bin_path)
        return
    endif
    call system(expand(bin_path) . " -f " . &tags . " " . expand("%:p"))
endfunction

" Autocommands
" ============================================================================
"
augroup vim-concourse
    autocmd!

    " run gometalinter on save
    if get(g:, "concourse_tags_autosave", 1)
        autocmd FileType concourse
                    \ let b:tagspath = tempname() |
                    \ exec 'setlocal tags='.b:tagspath |
                    \ call s:FlyTags()
        autocmd BufWritePost *.yml call s:FlyTags()
    endif
augroup END


" vim:ts=4:sw=4:et
