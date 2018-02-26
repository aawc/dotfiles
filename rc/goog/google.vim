if filereadable("/usr/share/vim/google/google.vim")
  source /usr/share/vim/google/google.vim
  filetype plugin indent on
  syntax on

  " Zapfhahn coverage
  Glug coverage
  Glug coverage uncovered_text=':(' covered_text=':)' partial_text=':|'
  Glug coverage-google

  " G4 integration
  Glug g4

  " Shows related files
  Glug relatedfiles
  " Brings up the related files. Also try: ,rc and ,rh
  Glug relatedfiles plugin[mappings]='<leader>r'

  " Create a selection window for the active files
  noremap <leader>go :PiperSelectActiveFiles<CR>
  nnoremap <leader>gc :CritiqueComments<CR>
  nnoremap <leader>gC :CritiqueComments!<CR>

  " Blaze integration
  Glug blaze plugin[mappings]=',b'

  Glug outline-window
  nnoremap <leader>g :GoogleOutlineWindow<CR>

  "http://go/buildifier
  let g:auto_buildifier = 1
  autocmd FileType bzl,blazebuild AutoFormatBuffer buildifier
endif
