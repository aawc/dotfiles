set nocompatible
set bs=2 "set backspace to be able to delete previous characters
set number "Enable line numbering, taking up 6 spaces

"Turn off word wrapping
set wrap!
set hlsearch

"Turn on smart indent
set smartindent
set tabstop=2 "set tab character to 4 characters
set expandtab "turn tabs into whitespace
set shiftwidth=2 "indent width for autoindent
filetype indent on "indent depends on filetype

"Shortcut to auto indent entire file
nnoremap <F11> 1G=G
inoremap <F11> <ESC>1G=Ga

"Turn on incremental search with ignore case (except explicit caps)
set incsearch
set ignorecase
set smartcase

"Informative status line
"set statusline=%F%m%r%h%w\ [TYPE=%Y\ %{&ff}]\ [%l/%L\ (%p%%)]

"Set color scheme
"set t_Co=256
syntax enable

"Enable indent folding
set foldenable
"set fdm=indent

"Set space to toggle a fold
nnoremap <space> za

"Hide buffer when not in window (to prevent relogin with FTP edit)
set bufhidden=hide

"Have 3 lines of offset (or buffer) when scrolling
set scrolloff=3

set cursorline

"Turn on spell checking with English dictionary
"set spell
set spelllang=en
set spellsuggest=8 "show only 9 suggestions for misspelled words

filetype plugin on

if has('gui_running')
	"Set the font and size
	"set guifont=Lucida\ Console
	set guifont=Monospace\ 10  " use this font
	set guioptions-=T "Hide toolbar
else
	"colorscheme elflord    " use this color scheme
	"set background=dark        " adapt colors for background
endif

"actionscript language
let tlist_actionscript_settings ='actionscript;c:class;f:method;p:property;v:variable'

" From the previous .vimrc
"set autowrite      "VK: Write the buffer to disk when switching buffers
set wildmenu        "VK: Show filematch menu
set wildignore=*.o,*.obj,*.bak,*.exe
set showmatch       "VK: Show corresponding bracket {}, {}, ()

set report=1        "VK: Some commands show how many lines were affected.

if (&term == "xterm") || has ("gui_running")
	set t_kb=
	set bs=2          " allow backspacing over everything in insert mode
	fixdel            " VK: Fix the 'Del' key.
endif

set showmode        "VK: If in Insert, Replace or Visual mode put a message on the last line.
set incsearch       "VK: Incrmental search. Search as you type.
set hlsearch        "VK: Highlight search items
set history=50                   " keep 50 lines of history

set sts=0
set noea
set ruler
"set wrap           "VK: lines longer than window width do not wrap
set nobackup          "VK: Don't keep backups after file-write
set writebackup       "VK: Keep backups till file-write
set autoindent
set nu

set so=2            "VK: Minimal number of screen lines to keep above and below the cursor.
set ss=1
set siso=5

set backupskip+=*.log     "VK: Do not create a backup file for these files
set backupskip+=*.out

set laststatus=2
set splitbelow
set splitright
set autoread

if &term == "screen" || &term == "xterm"
	set title
endif

" move cursor to next window below
noremap <C-Up> <C-W>w
" move cursor to next window above
noremap <C-Down> <C-W>W
noremap <C-Right> w
noremap <C-Left> b

" Open new file (split window mode)
noremap <C-o> :new
" Save current buffer
noremap <C-s> :w<CR>
" Save current buffer (FORCE)
noremap <C-x> :w!<CR>
" New tab Ctrl+T
noremap <C-t> :tabnew
" Toggle search highlighting
noremap <F3> :set invhlsearch<CR>
" Toggle line number display
noremap <C-l> :set invnu<CR>
" Reload .vimrc
nnoremap <leader>s  :source $HOME/.vimrc<CR>
" Edit .vimrc
nmap <leader>e  :tabnew $HOME/.vimrc<CR>
" Re-load file from disk (:e!)
nmap <leader>r :e!<CR>
nnoremap < <C-w>>
nnoremap > <C-w><

" grep the keword under cursor in the current buffer.
nmap <C-f>  [I

" Toggle paste mode on and off
map <leader>pp :setlocal paste!<cr>

" Insert mode Abbreviations (defines shortcuts for common text)
:iabbrev //= //==================================================================================================
:iabbrev //- //--------------------------------------------------------------------------------------------------
:iabbrev //* //**************************************************************************************************
:iabbrev pdb import pdb; pdb.set_trace()

if &t_Co > 1
	set hlsearch
	hi Statement ctermfg=6*
	hi Normal guibg=White guifg=Black
endif

syntax on

" http://stackoverflow.com/questions/2447109/showing-a-different-background-colour-in-vim-past-80-characters
"let &colorcolumn=join(range(81,999),",")
"highlight ColorColumn ctermbg=235 guibg=#2c2d27

set textwidth=80
set colorcolumn=+1
"highlight ColorColumn guibg=#2d2d2d ctermbg=246

" don't indent public: private: or protected:
set cinoptions+=g0

:inoremap <Tab> <C-R>=Mosh_Tab_Or_Complete()<CR>

"vim.org (Tip #64: Always set your working directory to the file you're editing)
"-------------------------------------------------------------------------------
"autocmd BufEnter * call CHANGE_CURR_DIR()

"vim.org (Tip #235: Highlight the line or word under cursor)
"-------------------------------------------------------------------------------
function! VIMRCWhere()
	if !exists("s:highlightcursor")
		"       match Todo /\k*\%#\k*/
		match Todo /^.*\%#.*$/
		let s:highlightcursor=1
	else
		match None
		unlet s:highlightcursor
	endif
endfunction
map <C-K> :call VIMRCWhere()<CR>

"vim.org (Tip #20: Are *.swp and *~ files littering your working directory?)
"-------------------------------------------------------------------------------
"set backupdir=./.backup,.,/tmp 	"VK: Directory for '~' files
"set directory=.,./.backup,/tmp 	"VK: Directory for .swp files

"===================================================================================================
function! Mosh_Tab_Or_Complete()
"===================================================================================================
	if col('.')>1 && strpart( getline('.'), col('.')-2, 3 ) =~ '^\w'
		return "\<C-N>"
	else
		return "\<Tab>"
endfunction
:set  dictionary="/usr/dict/words"

"===================================================================================================
function! CHANGE_CURR_DIR()
	"===================================================================================================
	exec "cd %:p:h"
endfunction

au BufNewFile,BufRead *.as		set filetype=actionscript
filetype plugin on
set ofu=syntaxcomplete#Complete

execute pathogen#infect()
let python_highlight_all=1

let g:tagbar_usearrows = 1
nnoremap <leader>l :TagbarToggle<CR>
