" ------------------------------------------------
" Copied from https://github.com/gmarik/Vundle.vim
" ------------------------------------------------
set nocompatible              " be iMproved, required
filetype off                  " required

" Plug vim-plug
call plug#begin('~/.vim/plugged')

" let Vundle manage Vundle, required
Plug 'gmarik/Vundle.vim'

Plug 'bling/vim-airline'
Plug 'chrisbra/vim-diff-enhanced'
Plug 'groenewege/vim-less'
Plug 'hail2u/vim-css3-syntax'
Plug 'Lokaltog/vim-easymotion'
Plug 'majutsushi/tagbar'
Plug 'roryokane/detectindent'
Plug 'skammer/vim-css-color'
Plug 'tmux-plugins/vim-tmux'
Plug 'tpope/vim-fugitive' | let s:fugitive_loaded = 1
Plug 'Valloric/MatchTagAlways'

Plug 'pangloss/vim-javascript'
let javascript_enable_domhtmlcss=1
let g:javascript_conceal=1

" Initialize plugin system
call plug#end()

" ----
" DONE
" Now close,re-open vim and run :PluginInstall
" ----
