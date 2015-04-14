""""""""""""""""""
" basic settings "
""""""""""""""""""
syntax on
set noswapfile
se nu 
se foldmethod=marker
se tabstop=2
se shiftwidth=2
se expandtab
se mouse=a "always use mouse
set backspace=indent,eol,start
set clipboard=unnamed "use system clipboard
filetype plugin indent on "activate all filetype triggers
let mapleader="," "set leader key

""""""""""""""""
" Key mappings "
""""""""""""""""
"dont yank when pasting
xnoremap p pgvy
"tab switching
nnoremap th  :tabfirst<CR>
nnoremap tj  :tabnext<CR>
nnoremap tk  :tabprev<CR>
nnoremap tl  :tablast<CR>
nnoremap tt  :tabedit<CR>
nnoremap tn  :tabnext<CR>
nnoremap tm  :tabm<CR>
nnoremap td  :tabclose<CR>

"""""""""""""
" functions "
"""""""""""""
" Restore cursor position, window position, and last search after running a command.
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
function SourceRecursive(vim_custom_filename)
  "{{{
  let cwd_saved = getcwd()
  chdir / "goto root 
  for dir in split( cwd_saved, '/') "split full current path into directories
    let fullname = getcwd() . '/' . a:vim_custom_filename
    if filereadable( a:vim_custom_filename ) "check in every dir if a custom vim file exists
      "source it if so
      exe ':so ' . fullname 
    endif
    "goto next dir
    exe 'lcd ' . dir 
  endfor
  "}}}
endfunction

""""""""""""""""
" Autocommands "
""""""""""""""""
au BufRead,BufNewFile ~/.bash/* set filetype=sh
au BufNewFile,BufRead *.vim.custom set filetype=vim
au BufNewFile,BufRead *.gitignore set filetype=conf
au BufNewFile,BufRead *.jshintrc set filetype=json
au BufRead,BufNewFile /etc/icinga2/* set syntax=cpp
au BufRead,BufNewFile /usr/share/icinga2/* set syntax=cpp
au Filetype           gitcommit setlocal spell textwidth=72
"au BufWritePre <buffer> call Indent() " Indent on save hook

""""""""""""""""""""""""
" OS dependent settings"
""""""""""""""""""""""""
let s:uname = system("uname -s")
let s:distribution = system("lsb_release >/dev/null 2>&1 && lsb_release -si")
let s:release = system("lsb_release >/dev/null 2>&1 && lsb_release -sr")
if !has("unix") 
  "dont do anything if not unix
elseif s:uname =~ "Linux" && s:distributor =~ "RedHatEnterpriseServer" && str2float(s:release) <= 6.6 "redhat6 got no glibc 2.14, so disable youcompleteme
  let s:youcompleteme_disabled = 1
endif

""""""""""""""""""""
" Custom init code "
""""""""""""""""""""
call SourceRecursive('.vim.custom')


""""""""""""""""""
" Vundle Plugins "
""""""""""""""""""
set nocompatible
filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
Bundle 'gmarik/vundle'

"Vim UI plugins
Plugin 'Valloric/YouCompleteMe'
"{{{
let g:ycm_confirm_extra_conf = 0
let g:ycm_global_ycm_extra_conf = '~/.vim/.ycm_extra_conf.py'
let g:ycm_filepath_completion_use_working_dir = 1
nnoremap <leader>jd :YcmCompleter GoTo<CR>
"}}}
Plugin 'bling/vim-airline'
"{{{
set guifont=Inconsolata\ for\ Powerline:h15
let g:Powerline_symbols = 'fancy'
set encoding=utf-8
set t_Co=256
set fillchars+=stl:\ ,stlnc:\
set term=xterm-256color
set termencoding=utf-8
"}}}
Plugin 'scrooloose/Syntastic'
"{{{
let g:syntastic_javascript_checkers = ['jshint'] "check js files with jshint
"}}}
"Nerdtree and plugins
Plugin 'scrooloose/nerdtree'
"{{{
let g:NERDTreeShowHidden=1
"}}}
Plugin 'jistr/vim-nerdtree-tabs'
"{{{
let g:nerdtree_tabs_focus_on_files=1
map <Leader>n <plug>NERDTreeTabsToggle<CR>
"}}}
"Git plugins
Plugin 'Xuyuanp/nerdtree-git-plugin'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-git'
Plugin 'airblade/vim-gitgutter'

"General editing plugins
Plugin 'scrooloose/nerdcommenter'
"{{{
"custom delimiters
let g:NERDCustomDelimiters = { 'puppet': { 'left': '#', 'leftAlt': '/*', 'rightAlt': '*/' } }
"}}}
Plugin 'tpope/vim-abolish'
Plugin 'tpope/vim-surround'

"Language/syntax plugins
Plugin 'fatih/vim-go'
"{{{
let g:go_fmt_command = "goimports"
"}}}
Plugin 'cakebaker/scss-syntax.vim'
Plugin 'chase/vim-ansible-yaml'
Plugin 'digitaltoad/vim-jade'
Plugin 'ekalinin/Dockerfile.vim'
Plugin 'kchmck/vim-coffee-script'
Plugin 'rodjek/vim-puppet'
Plugin 'tfnico/vim-gradle'
Plugin 'tpope/vim-rails'

Plugin 'dansomething/vim-eclim'
"{{{
let g:EclimCompletionMethod = 'omnifunc'
let g:EclimFileTypeValidate=0
let g:EclimJavascriptValidate=0
"}}}

"Colorscheme plugins
Plugin 'thinca/vim-guicolorscheme'
Plugin 'vim-scripts/summerfruit256.vim'
if isdirectory(expand("~/.vim/bundle/summerfruit256.vim"))
  colorscheme summerfruit256
endif

"Other plugins
Plugin 'vim-scripts/vimwiki'
"{{{
let vimwiki_path=$HOME.'/vimwiki/'
let vimwiki_html_path=$HOME.'/vimwiki_html/'
let g:vimwiki_list = [{'path_html':vimwiki_html_path,
                       \ 'template_path':vimwiki_html_path,
                       \ 'template_default': 'default',
                       \ 'template_ext': '.tpl',
                       \ 'auto_export': 1}]
"}}}
Plugin 'rosenfeld/conque-term'
"{{{
let g:ConqueTerm_StartMessages = 0
"}}}
Plugin 'bruno-/vim-man'

filetype on "set filetype back on
