" abaenderung der directories mit autovervollstaendigung
map <C-x><C-x><C-T> :!ctags -R -f ~/.vim/commontags /usr/include /usr/local/include /usr/src/linux/include .<CR><CR>
set tags+=~/.vim/commontags
" tabs for python
set expandtab
"colorscheme Tomorrow-Night-Blue
"colorscheme bubblegum
"colorscheme default
"colorscheme cobalt

" DONT REMOVE THIS, ELSE COLORSCHEMES DONT WORK!!!!!!
colorscheme 256-grayvim
" !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

"colorscheme Monokai-chris
colorscheme Monokai
set noswapfile
se nu 
" REQUIRED. This makes vim invoke Latex-Suite when you open a tex file.
" filetype plugin on

" IMPORTANT: win32 users will need to have 'shellslash' set so that latex
" can be called correctly.
set shellslash

" IMPORTANT: grep will sometimes skip displaying the file name if you
" search in a singe file. This will confuse Latex-Suite. Set your grep
" program to always generate a file-name.
set grepprg=grep\ -nH\ $*

" OPTIONAL: This enables automatic indentation as you type.
"filetype indent on

" OPTIONAL: Starting with Vim 7, the filetype of empty .tex files defaults to
" 'plaintex' instead of 'tex', which results in vim-latex not being loaded.
" The following changes the default filetype back to 'tex':
" let g:tex_flavor='latex'
syntax on
se makeprg=make
se foldmethod=marker
se tabstop=2
se shiftwidth=2
se expandtab
se mouse=a
se smartindent

"read .vim.custom in cwd 
if filereadable(".vim.custom")
    so .vim.custom
endif

"check spell and limit width for git commit messages
autocmd Filetype gitcommit setlocal spell textwidth=72

"use system clipboard
set clipboard=unnamedplus

"activate filetype plugins, needed for nerdcomment
filetype plugin indent on

"for pathogen
execute pathogen#infect()

"vim-nerdtree-tabs
map <Leader>n <plug>NERDTreeTabsToggle<CR>


"powerline
set rtp+=$HOME/.local/lib/python2.7/site-packages/powerline/bindings/vim/
set laststatus=2

"dont yank when pasting
xnoremap p pgvy

""loop over directories for project settings
""let parent=1
"let local_vimrc = ".vim.custom"
"let local_tags = "tags"
"while parent <= 8
  "if filewritable(local_vimrc)
    "exe ":so " . local_vimrc
  "endif
  "let local_vimrc = "../". local_vimrc
  "let parent = parent+1
"endwhile
"unlet parent local_vimrc
"
let g:nerdtree_tabs_focus_on_files=1
let g:NERDTreeShowHidden=1

filetype plugin on
set omnifunc=syntaxcomplete#Complete

"vimwiki settings
set nocompatible
