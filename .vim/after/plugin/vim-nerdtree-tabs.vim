"Open nerd tree tabs after startup.
"echo &l:ft
"if &l:ft != 'man'
  "autocmd vimenter * NERDTreeTabsToggle
  "autocmd vimenter * wincmd l
"endif
