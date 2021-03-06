if has('nvim')
  " =======================================================
  " General for coc
  " =======================================================

  " Use tab for trigger completion with characters ahead and navigate.
  " Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
  inoremap <silent><expr> <TAB>
        \ pumvisible() ? "\<C-n>" :
        \ <SID>check_back_space() ? "\<TAB>" :
        \ coc#refresh()
  inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

  " Use <cr> for confirm completion, `<C-g>u` means break undo chain at current position.
  " Coc only does snippet and additional edit on confirm.
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"


  " For coc-snippets (https://github.com/aawc/vscode-cpp-snippets)
  inoremap <expr> <TAB> pumvisible() ? "\<C-y>" : "\<TAB>"
  let g:coc_snippet_next = '<TAB>'
  let g:coc_snippet_prev = '<S-TAB>'
endif

