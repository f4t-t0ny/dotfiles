""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                               _                                              "
"                        __   _(_)_ __ ___  _ __ ___                           "
"                        \ \ / / | '_ ` _ \| '__/ __|                          "
"                         \ V /| | | | | | | | | (__                           "
"                          \_/ |_|_| |_| |_|_|  \___|                          "
"                                                                              "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                Basic Settings                                "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""



syntax on
set noswapfile
set number 
set foldmethod=marker
set tabstop=2
set shiftwidth=2
set textwidth=80
set expandtab
set mouse=a "always use mouse
set backspace=indent,eol,start
set wildmode=longest,list "wildcard type in ex mode
set clipboard=unnamed "use system clipboard
filetype plugin indent on "activate all filetype triggers
let mapleader="," "set leader key
set splitright
set splitbelow
set wrap
set showtabline=2

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                             General key mappings                             "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
              
              
"dont yank when pasting
xnoremap p pgvy
"tab switching
nnoremap th  :tabfirst<cr>
nnoremap tj  :tabnext<cr>
nnoremap tk  :tabprev<cr>
nnoremap tl  :tablast<cr>
nnoremap tt  :tabedit<cr>
nnoremap tn  :tabnext<cr>
nnoremap tm  :tabm<cr>
nnoremap td  :tabclose<cr>
"edit vimrc in split
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>ef :e $MYVIMRC<cr>
nnoremap <leader>ea :vsplit ~/.vim/misc/ascisnips.txt<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                               Custom commands                                "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

com! Reload so ~/.vimrc

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                  Functions                                   "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Restore cursor position, window position, and last search after running a
" command.
fun! Preserve(command)
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
endfun
fun! SourceRecursive(vim_custom_filename, targetdir)
  "{{{
  let savedir = getcwd() 
  if &l:modifiable == 0
    return
  endif
  chdir / "goto root 
  "split full current path into directories
  for dir in split( a:targetdir, '/') 
    "goto next dir
    "echom "sourcing " . dir
    if isdirectory(dir)
      exe 'lcd ' . dir 
    else
      exe 'lcd ' . savedir 
      return
    endif
    let fullname = getcwd() . '/' . a:vim_custom_filename
    "check in every dir if a custom vim file exists
    if filereadable( fullname ) 
      "echom 'sourcing ' . fullname
      exe ':so ' . fullname 
    endif
  endfor
  exe 'lcd ' . savedir 
  "}}}
endfun

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                 Autocommands                                 "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"set custom filetypes 
au BufRead,BufNewFile *.vim.custom setfiletype vim
au BufRead,BufNewFile *.gitignore setfiletype conf
au BufRead,BufNewFile *.jshintrc setfiletype json
au BufRead,BufNewFile *.nmf setfiletype json
"directory dependent filetypes
au BufRead,BufNewFile ~/.bash/* setfiletype sh
au BufRead,BufNewFile /etc/icinga2/* set filetype=cpp "overwrite ft
au BufRead,BufNewFile /usr/share/icinga2/* set filetype=cpp
au BufRead,BufNewFile /var/folders/* set filetype=sh

au Filetype gitcommit setlocal spell textwidth=72
au Filetype java setlocal foldmethod=indent

"load all .vim.custom files for each opened file
au BufRead * call SourceRecursive('.vim.custom', expand('%:p:h'))
"FIXME source vimrc after save
"au! bufwritepost .vimrc source % "source vimrc after save
"FIXME only save folds, but nothing else
"au BufWinLeave *.* mkview
"au BufWinEnter *.* silent loadview
"DISABLED
"au BufWritePre <buffer> call Indent() " Indent on save hook

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                            OS dependent settings                             "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let iswin = 0
if has("win32") 
  "is a windows system
  let iswin = 1
elseif has("unix")
  set term=xterm-256color

  let s:uname = system("uname -s")
  let s:distribution = system("lsb_release >/dev/null 2>&1 && lsb_release -si")
  let s:release = system("lsb_release >/dev/null 2>&1 && lsb_release -sr")
  if s:uname =~ "Linux" &&
    \ s:distribution =~ "RedHatEnterpriseServer" &&
    \ str2float(s:release) <= 6.6 
    echo "test"
  endif
endif




""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                           _ _                                " 
"                    __   ___   _ _ __   __| | | ___                           " 
"                    \ \ / / | | | '_ \ / _` | |/ _ \                          " 
"                     \ V /| |_| | | | | (_| | |  __/                          " 
"                      \_/  \__,_|_| |_|\__,_|_|\___|                          " 
"                                                                              "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set nocompatible
filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
Bundle 'gmarik/vundle'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                   Plugins                                    "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"Vim UI plugins
if !iswin
  Plugin 'Valloric/YouCompleteMe'
  "{{{
  let g:ycm_confirm_extra_conf = 0
  let g:ycm_global_ycm_extra_conf = '~/.vim/.ycm_extra_conf.py'
  let g:ycm_filepath_completion_use_working_dir = 1
  nnoremap <leader>jd :YcmCompleter GoTo<CR>
  "}}}
endif
Plugin 'bling/vim-airline'
"{{{
set guifont=Inconsolata\ for\ Powerline:h15
let g:Powerline_symbols = 'fancy'
set encoding=utf-8
set t_Co=256
set fillchars+=stl:\ ,stlnc:\
set termencoding=utf-8
"}}}
"Plugin 'scrooloose/Syntastic'
"{{{
let g:syntastic_javascript_checkers = ['jshint'] "check js files with jshint
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*

"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
"let g:syntastic_check_on_open = 1
"let g:syntastic_check_on_wq = 0
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
Plugin 'gregsexton/gitv'
"Mercurial plugin
Plugin 'ludovicchabant/vim-lawrencium'

"General editing plugins
Plugin 'scrooloose/nerdcommenter'
"{{{
"custom delimiters
let g:NERDCustomDelimiters = { 'puppet': { 'left': '#', 'leftAlt': '/*', 'rightAlt': '*/' } }
"}}}
Plugin 'tpope/vim-abolish'
Plugin 'tpope/vim-surround'
if !iswin
  Plugin 'SirVer/ultisnips'
  "{{{
  let g:UltiSnipsExpandTrigger="<c-b>"
  let g:UltiSnipsEditSplit="vertical"
  let g:UltiSnipsListSnippets="<c-l>"
  "}}}
  Plugin 'honza/vim-snippets'
endif

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
"{{{
""HACK, but works
"for eclim_plugin in ['adt', 'cdt', 'dltk', 'dltkruby', 'groovy', 'jdt', 'pdt', 
"\ 'pydev', 'sdt', 'vimplugin', 'wst']
  "exec 'set rtp+='.$HOME.'/.vim/bundle/eclim/'.'org.eclim.'.eclim_plugin.'/vim/eclim'
"endfor
let g:EclimCompletionMethod = 'omnifunc'
"let g:EclimFileTypeValidate=0 "disable eclim validation, enable syntastic
let g:EclimJavascriptValidate=0
let g:EclimJavaValidate=1
au FileType java nnoremap <silent> <buffer> <leader>i :JavaImport<cr>
au FileType java nnoremap <silent> <buffer> <leader>a :JavaImportOrganize<cr>
au FileType java nnoremap <silent> <buffer> <leader>d :JavaSearch -x declarations<cr>
au FileType java nnoremap <silent> <buffer> <cr> :JavaSearchContext<cr>
"}}}

if iswin
  colorscheme pablo
else
  "Colorscheme plugins
  Plugin 'thinca/vim-guicolorscheme'
  colorscheme summerfruit256
endif

" Debugging
Plugin 'vim-scripts/Decho'
""{{{
let g:dechomode=0
""}}}

"Other plugins
Plugin 'vim-scripts/vimwiki'
"{{{
let vimwiki_path=$HOME.'/vimwiki/'
let vimwiki_html_path=$HOME.'/vimwiki_html/'
let g:vimwiki_table_auto_fmt = 0
let wiki = {}
let wiki.path_html = vimwiki_html_path
let wiki.template_path = vimwiki_html_path
let wiki.template_default = 'default'
let wiki.template_ext = '.tpl'
let wiki.nested_syntaxes = {'python': 'python', 'c++': 'cpp'}
let g:vimwiki_list = [wiki]

au BufWritePost *.wiki
  \ call vimwiki#html#Wiki2HTML(expand(VimwikiGet('path_html')),
  \                             expand('%'))
nnoremap <leader>wv :60vs \| VimwikiIndex<cr>
"}}}
Plugin 'rosenfeld/conque-term'
"{{{
let g:ConqueTerm_StartMessages = 0
"}}}
Plugin 'bruno-/vim-man'
Plugin 'f4t-t0ny/DrawIt'
"{{{
fun! CutBlock(brush) range
  "{{{
  let b:drawit_brush= a:brush
  if visualmode() == "\<c-v>" && ((a:firstline == line("'>") && a:lastline == line("'<")) || (a:firstline == line("'<") && a:lastline == line("'>")))
   exe 'norm! gv"'.b:drawit_brush.'y'
   exe 'norm! gvr "'
  endif
  "}}}
endfun
com! -nargs=1 -range CutBlock <line1>,<line2>call CutBlock(<q-args>)
com! -nargs=1 -range CopyBlock <line1>,<line2>call DrawIt#SetBrush(<q-args>)
"}}}
Plugin 'nathanaelkane/vim-indent-guides'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                               Custom init code                               "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"else filetype detection not working 
filetype on 

"colorize after 80 columns
let &colorcolumn=join(range(81,999),",")

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
