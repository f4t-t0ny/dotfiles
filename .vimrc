
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
"colorscheme 256-grayvim
" !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

"colorscheme Monokai-chris
"colorscheme Monokai
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

autocmd BufRead,BufNewFile ~/.bash/* set filetype=sh
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

"YouCompleteMe Options 
let g:ycm_confirm_extra_conf = 0
let g:ycm_global_ycm_extra_conf = '~/.vim/.ycm_extra_conf.py'
let g:ycm_filepath_completion_use_working_dir = 1
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

"shift line forward (Ctrl-Shift-Tab for backward shift)
nmap <C-Tab> i_<Esc>mz:set ve=all<CR>o<C-o>`z<Down>_<Esc>:exe "normal >>"<CR>my`z:exe "normal >>"<CR>`y<Up>mz<Down>dd`z:set ve=<CR>i<Del><Right><Esc>
nmap <C-S-Tab> i_<Esc>mz:set ve=all<CR>o<C-o>`z<Down>_<Esc>:exe "normal <<"<CR>my`zi<Del><Esc>:exe "normal <<"<CR>`y<Up>mz<Down>dd`z:set ve=<CR>:<Del>
imap <C-Tab> _<Esc>mz:set ve=all<CR>o<C-o>`z<Down>_<Esc>:exe "normal >>"<CR>my`z:exe "normal >>"<CR>`y<Up>mz<Down>dd`z:set ve=<CR>i<Del>
imap <C-S-Tab> _<Esc>mz:set ve=all<CR>o<C-o>`z<Down>_<Esc>:exe "normal <<"<CR>my`zi<Del><Esc>:exe "normal <<"<CR>`y<Up>mz<Down>dd`z:set ve=<CR>i

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
  elseif s:uname =~"Darwin"
  endif
endif

"if !exists("s:youcompleteme_disabled")
  "Bundle 'Valloric/YouCompleteMe'
"endif

set guifont=Inconsolata\ for\ Powerline:h15
let g:Powerline_symbols = 'fancy'
set encoding=utf-8
set t_Co=256
set fillchars+=stl:\ ,stlnc:\
set term=xterm-256color
set termencoding=utf-8

"Basic plugins
Plugin 'scrooloose/nerdtree'
Plugin 'Valloric/YouCompleteMe'
Plugin 'bling/vim-airline'
Plugin 'cakebaker/scss-syntax.vim'
Plugin 'chase/vim-ansible-yaml'
Plugin 'digitaltoad/vim-jade'
Plugin 'ekalinin/Dockerfile.vim'
Plugin 'fatih/vim-go'
Plugin 'flazz/vim-colorschemes'
Plugin 'jistr/vim-nerdtree-tabs'
Plugin 'kchmck/vim-coffee-script'
Plugin 'rodjek/vim-puppet'
Plugin 'scrooloose/Syntastic'
Plugin 'scrooloose/nerdcommenter'
Plugin 'tfnico/vim-gradle'
Plugin 'thinca/vim-guicolorscheme'
Plugin 'tpope/vim-abolish'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-git'
Plugin 'tpope/vim-rails'
Plugin 'tpope/vim-surround'
Plugin 'vim-scripts/darkspectrum'
Plugin 'vim-scripts/vimwiki'
Plugin 'Xuyuanp/nerdtree-git-plugin'
Plugin 'airblade/vim-gitgutter'
Plugin 'rosenfeld/conque-term'
Plugin 'bruno-/vim-man'
"----old stuff
"Plugin 'powerline/powerline'

"set filetype back on
filetype on

"go stuff
let g:go_fmt_command = "goimports"

if (isdirectory("~/.vim/bundle/vim-guicolorscheme") && &t_Co == 256 || &t_Co == 88) && !has('gui_running')
  runtime ! bundle/vim-guicolorscheme/plugin/guicolorscheme.vim
  "set background=dark
  "GuiColorScheme base16-atelierlakeside
  GuiColorScheme darkspectrum
elseif isdirectory("~/.vim/bundle/darkspectrum")
  colorscheme darkspectrum
endif

"vimwiki settings
let vimwiki_path=$HOME.'/vimwiki/'
let vimwiki_html_path=$HOME.'/vimwiki_html/'
let g:vimwiki_list = [{'path_html':vimwiki_html_path,
                       \ 'template_path':vimwiki_html_path,
                       \ 'template_default': 'default',
                       \ 'template_ext': '.tpl',
                       \ 'auto_export': 1}]

let g:ConqueTerm_StartMessages = 0
