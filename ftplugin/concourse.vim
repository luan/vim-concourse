" Vim indent file
" Language: Concourse Flavored YAML
" Author:   Luan Santos <vim@luan.sh>
" URL:      https://github.com/luan/vim-concourse

setlocal autoindent sw=2 ts=2 expandtab foldmethod=syntax
setlocal indentexpr=
setlocal norelativenumber nocursorline

if globpath(&rtp, 'plugin/rainbow.vim') != ""
  silent! RainbowToggleOff
endif

if !exists("g:concourse_flytags_bin")
    let g:concourse_flytags_bin = "flytags"
endif

" vim:set sw=2:
