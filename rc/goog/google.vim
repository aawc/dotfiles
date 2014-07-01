source /usr/share/vim/google/google.vim

" G4 integration
Glug g4

" Create a selection window for the active files
noremap <leader>go :PiperSelectActiveFiles<CR>
nnoremap <leader>gc :CritiqueComments<CR>
nnoremap <leader>gC :CritiqueComments!<CR>

" Blaze integration
Glug blaze plugin[mappings]=',b'

:iabbrev g3/ //depot/google3/

Glug outline-window
nnoremap <leader>g :GoogleOutlineWindow<CR>

"http://go/buildifier
let g:auto_buildifier = 1

" Open the current file in Chrome:
nnoremap <leader>cs :!google-chrome --new-window https://cs.corp.google.com\\#%:p:s?.*./google3/?google3/?<CR> <CR>
