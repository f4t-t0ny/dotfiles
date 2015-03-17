
"" abaenderung der directories mit autovervollstaendigung
"map <C-x><C-x><C-T> :!ctags -R -f ~/.vim/commontags /usr/include /usr/local/include /usr/src/linux/include .<CR><CR>
"set tags+=~/.vim/commontags
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
"se makeprg=make
se foldmethod=marker
se tabstop=2
se shiftwidth=2
se expandtab
se mouse=a
"se smartindent

"read .vim.custom in cwd 
if filereadable(".vim.custom")
  so .vim.custom
endif

"check spell and limit width for git commit messages
autocmd Filetype gitcommit setlocal spell textwidth=72

"use system clipboard
set clipboard=unnamed

"activate filetype plugins, needed for nerdcomment
filetype plugin indent on



"powerline
set rtp+=$HOME/.local/lib/python2.7/site-packages/powerline/bindings/vim/
set laststatus=2

"dont yank when pasting
xnoremap p pgvy

let g:nerdtree_tabs_focus_on_files=1
let g:NERDTreeShowHidden=1

filetype plugin on
"set omnifunc=syntaxcomplete#Complete

"switch easily between windows
nmap <silent> <A-Up> :wincmd k<CR>
nmap <silent> <A-Down> :wincmd j<CR>
nmap <silent> <A-Left> :wincmd h<CR>
nmap <silent> <A-Right> :wincmd l<CR>

"set leader key
let mapleader=","

"vim-nerdtree-tabs
map <Leader>n <plug>NERDTreeTabsToggle<CR>

"YCM Completer
nnoremap <leader>jd :YcmCompleter GoTo<CR>

if has("unix")
  let s:uname = system("uname -s")
  if s:uname == "Darwin"
    " mac stuff
    let g:ycm_path_to_python_interpreter = '/Users/andreas.wallner/bin/python'
  endif
endif
set backspace=indent,eol,start

autocmd BufRead,BufNewFile ~/.bash/* set syntax=sh
"tab switching
nnoremap th  :tabfirst<CR>
nnoremap tj  :tabnext<CR>
nnoremap tk  :tabprev<CR>
nnoremap tl  :tablast<CR>
nnoremap tt  :tabedit<Space>
nnoremap tn  :tabnext<Space>
nnoremap tm  :tabm<Space>
nnoremap td  :tabclose<CR>

"let .vim.custom files get vim syntax
au BufNewFile,BufRead *.vim.custom set filetype=vim
au BufNewFile,BufRead *.gitignore set filetype=conf
au BufNewFile,BufRead *.jshintrc set filetype=json

" Restore cursor position, window position, and last search after running a
" command.
function! Preserve(command)
  "{{{
  " Save the last search.
  let search = @/

  " Save the current cursor position.
  let cursor_position = getpos('.')

  " Save the current window position.
  normal! H
  let window_position = getpos('.')
  call setpos('.', cursor_position)

  " Execute the command.
  execute a:command

  " Restore the last search.
  let @/ = search

  " Restore the previous window position.
  call setpos('.', window_position)
  normal! zt

  " Restore the previous cursor position.
  call setpos('.', cursor_position)
  "}}}
endfunction

" Re-indent the whole buffer.
function! Indent()
  call Preserve('normal gg=G')
endfunction

" Indent on save hook
"au BufWritePre <buffer> call Indent()

"source all .vim.custom files from / till current directory
let vim_custom_file = '.vim.custom'
let cwd_saved = getcwd()
chdir / "goto root 
for dir in split( cwd_saved, '/') "split full current path into directories
  let fullname = getcwd() . '/' . vim_custom_file
  if filereadable(vim_custom_file) "check in every dir if a custom vim file exists
    "source it if so
    exe ':so ' . fullname 
  endif
  "goto next dir
  exe 'lcd ' . dir 
endfor

let g:EclimCompletionMethod = 'omnifunc'
let g:EclimFileTypeValidate=0
let g:EclimJavascriptValidate=0

let g:ycm_confirm_extra_conf = 0
let g:ycm_global_ycm_extra_conf = '~/.vim/.ycm_extra_conf.py'
autocmd BufRead,BufNewFile /etc/icinga2/* set syntax=cpp
autocmd BufRead,BufNewFile /usr/share/icinga2/* set syntax=cpp

"nerd custom delimiters for puppet
let g:NERDCustomDelimiters = { 'puppet': { 'left': '#', 'leftAlt': '/*', 'rightAlt': '*/' } }

"check js files with jshint
let g:syntastic_javascript_checkers = ['jshint']

"initialize vundle
set nocompatible
filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

"vundle plugin manager
Bundle 'gmarik/vundle'

"vim plugins
"
if has("unix") 
  let s:uname = system("uname -s")
  if s:uname =~ "Linux"
    let s:distributor = system("lsb_release -si")
    let s:release = system("lsb_release -sr")
    if s:distributor =~ "RedHatEnterpriseServer" && str2float(s:release) <= 6.6 "redhat6 got no glibc 2.14, so disable youcompleteme
      let s:youcompleteme_disabled = 1
    endif
  endif
endif

if !exists(s:youcompleteme_disabled)
  Bundle 'Valloric/YouCompleteMe'
endif
Bundle 'cakebaker/scss-syntax.vim'
Bundle 'chase/vim-ansible-yaml'
Bundle 'digitaltoad/vim-jade'
Bundle 'ekalinin/Dockerfile.vim'
Bundle 'fatih/vim-go'
Bundle 'jistr/vim-nerdtree-tabs'
Bundle 'kchmck/vim-coffee-script'
Bundle 'powerline/powerline'
Bundle 'rodjek/vim-puppet'
Bundle 'scrooloose/Syntastic'
Bundle 'scrooloose/nerdcommenter'
Bundle 'scrooloose/nerdtree'
Bundle 'tfnico/vim-gradle'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-git'
Bundle 'tpope/vim-rails'
Bundle 'vim-scripts/vimwiki'

"set filetype back on
filetype on

