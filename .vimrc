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
set textwidth=0
set expandtab
set mouse=a " always use mouse
set backspace=indent,eol,start
set wildmode=longest,list,full "wildcard type in ex mode
set wildmenu
set clipboard=unnamed " use system clipboard
filetype plugin indent on " activate all filetype triggers
let mapleader="," " set leader key
set splitright
set splitbelow
set wrap
set autoindent
set cindent
set showtabline=2 " always show tabs
set scrolloff=15 " start scrolling x lines from bottom/top

" KEY_MAPPINGS: {{{1
" dont yank when pasting
xnoremap p pgvy
" tab switching
nnoremap th  :tabfirst<cr>
nnoremap tj  :tabnext<cr>
nnoremap tk  :tabprev<cr>
nnoremap tl  :tablast<cr>
nnoremap tt  :tabedit<cr>
nnoremap tn  :tabnext<cr>
nnoremap tm  :tabm<cr>
nnoremap td  :tabclose<cr>
" edit vimrc in split
nnoremap <leader>e :e $MYVIMRC<cr>

" FUNCTION: Preserve(command) {{{1
" Restore cursor position, window position, and last search after running a
" command.
fun! Preserve(command)
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
endfun

"FUNCTION: SourceRecursive(vim_custom_filename, targetdir) {{{1
fun! SourceRecursive(vim_custom_filename, targetdir)
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
endfun
"}}}
" FUNCTION: Output() {{{1
function! Output()
    let winnr = bufwinnr('^_output$')
    if ( winnr >= 0 )
        execute winnr . 'wincmd w'
        execute 'normal ggdG'
    else
        new _output
        setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
    endif
    silent! r! ls
endfunction

" AUTOCOMMANDS: {{{1
" Set custom filetypes 
au BufRead,BufNewFile *.vim.custom setfiletype vim
au BufRead,BufNewFile *.gitignore setfiletype conf
au BufRead,BufNewFile *.jshintrc setfiletype json
au BufRead,BufNewFile *.nmf setfiletype json
au BufRead,BufNewFile Podfile,*.podspec setfiletype ruby
au BufRead,BufNewFile *.pde setfiletype arduino
au BufRead,BufNewFile *.ino setfiletype arduino
" Directory dependent filetypes
au BufRead,BufNewFile ~/.bash/functions.d/* setfiletype sh
au BufRead,BufNewFile ~/.bash/rc.d/* setfiletype sh
au BufRead,BufNewFile ~/.bash/aliases.d/* setfiletype sh
au BufRead,BufNewFile ~/.bash/variables.d/* setfiletype sh
au BufRead,BufNewFile /etc/icinga2/* set filetype=cpp " overwrite ft
au BufRead,BufNewFile /usr/share/icinga2/* set filetype=cpp
au BufRead,BufNewFile /var/folders/* set filetype=sh

au Filetype gitcommit setlocal spell textwidth=72
au Filetype java setlocal foldmethod=indent

" load all .vim.custom files for each opened file
au BufRead * call SourceRecursive('.vim.custom', expand('%:p:h'))
" FIXME source vimrc after save
"au! bufwritepost .vimrc source % "source vimrc after save
" FIXME only save folds, but nothing else
au BufWinLeave *.* mkview
au BufWinEnter *.* silent loadview
" DISABLED
"au BufWritePre <buffer> call Indent() " Indent on save hook

"" General highlighting for vim '%%%'-section
"augroup HiglightSection
    "autocmd!
    "autocmd WinEnter,VimEnter * :silent! call matchadd('StatusLine', '^.*\s%%%.*$', -1)
"augroup END

" OS_DEPENDENT_SETTINGS: {{{1
if has("unix")
  set term=xterm-256color

  let s:uname = system('uname -s')
  let s:distribution = system('lsb_release >/dev/null 2>&1 && lsb_release -si')
  let s:release = system('lsb_release >/dev/null 2>&1 && lsb_release -sr')
  "if s:uname =~ 'Linux'
    "if s:distribution =~ 'RedHatEnterpriseServer' &&
    "\ str2float(s:release) <= 6.6 
  "endif
endif

" set config
let s:config = 'default'
if hostname() == 'connector'
  let s:config = 'connector'
elseif has('win32')
  let s:config = 'win32'
endif



if index(['connector'], s:config) != -1
  set viminfo = "NONE"
endif

" PLUGINS: {{{1
call plug#begin('~/.vim/plugged')
Plug 'junegunn/vim-plug'

if index(['development'], s:config) != -1
Plug 'vim-scripts/Decho'
"{{{
let g:dechomode=0
let g:decho_winheight=30
"}}}
Plug 'tpope/vim-scriptease'
endif

if index(['default'], s:config) != -1
  Plug 'Valloric/YouCompleteMe'
  "{{{
  let g:ycm_confirm_extra_conf = 0
  let g:ycm_global_ycm_extra_conf = '~/.vim/.ycm_extra_conf.py'
  let g:ycm_filepath_completion_use_working_dir = 1
  nnoremap <leader>jd :YcmCompleter GoTo<CR>
  "}}}
  Plug 'SirVer/ultisnips'
  "{{{
  let g:UltiSnipsExpandTrigger="<c-b>"
  let g:UltiSnipsEditSplit="vertical"
  let g:UltiSnipsListSnippets="<c-l>"
  "}}}
  Plug 'honza/vim-snippets'
endif
if index(['default', 'win32'], s:config) != -1
  Plug 'davidhalter/jedi-vim'
  "{{{
  let g:jedi#usages_command = '<leader>u'
  "}}}
  Plug 'scrooloose/Syntastic'
  "{{{
  let g:syntastic_javascript_checkers = ['jshint'] "check js files with jshint
  if hostname() =~ 'connector'
    let g:syntastic_python_python_exec = 'python2'
  endif
  set statusline+=%#warningmsg#
  set statusline+=%{SyntasticStatuslineFlag()}
  set statusline+=%*

  "let g:syntastic_always_populate_loc_list = 1
  "let g:syntastic_auto_loc_list = 1
  let g:syntastic_check_on_open = 1
  let g:syntastic_check_on_wq = 0
  "}}}
  " Navigating files
  Plug 'scrooloose/nerdtree', { 'on': ['NERDTreeToggle', 'NERDTreeClose'] }
   \ | Plug 'Xuyuanp/nerdtree-git-plugin'
   \ | Plug 'https://github.com/f4t-t0ny/nerdtree-hg-plugin'
  Plug 'EvanDotPro/nerdtree-chmod', { 'on': 'NERDTreeToggle' } 
  "{{{
  let g:NERDTreeShowHidden=1
  let NERDTreeIgnore = ['\.pyc$', '\$py.class']
  let g:nerdtree_tabs_focus_on_files=1
  noremap <Leader>n :NERDTreeToggle<CR>
  " Go to directory with nerdtree
  com! -nargs=1 -complete=dir Ncd NERDTreeClose | cd <args> |NERDTreeCWD

  "}}}
  Plug 'ctrlpvim/ctrlp.vim'
  "{{{
  let g:ctrlp_map = '<c-p>'
  let g:ctrlp_cmd = 'CtrlP'
  "}}}
  " General editing
  Plug 'tpope/vim-abolish'
  Plug 'tpope/vim-surround'
  Plug 'nathanaelkane/vim-indent-guides'
  " Version control
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-git'
  Plug 'mhinz/vim-signify'
  "{{{
  let g:signify_vcs_list = [ 'hg', 'git' ]
  "}}}
  Plug 'gregsexton/gitv'
  Plug 'https://github.com/f4t-t0ny/vim-lawrencium'
  "{{{
  let g:lawrencium_hg_commands_file_types = { 
    \ 'log': 'hglog',
    \ 'lg': 'hglg' 
    \ }
  "}}}
  " Language/syntax plugins
  Plug 'fatih/vim-go', { 'for': 'go'}
  "{{{
  let g:go_fmt_command = "goimports"
  "}}}
  Plug 'cakebaker/scss-syntax.vim', { 'for': 'scss'}
  Plug 'chase/vim-ansible-yaml', { 'for': 'yaml'}
  Plug 'digitaltoad/vim-jade', { 'for': 'jade'}
  Plug 'kchmck/vim-coffee-script', { 'for': 'coffee-script'}
  Plug 'rodjek/vim-puppet', { 'for': 'puppet'}
  Plug 'tfnico/vim-gradle', { 'for': 'gradle'}
  Plug 'tpope/vim-rails', { 'for': 'ruby'}
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
  au FileType java nnoremap <silent> <buffer> <leader>c :JavaCorrect<cr>
  "}}}
  Plug 'keith/swift.vim', { 'for': 'swift'}
  Plug 'sudar/vim-arduino-syntax', { 'for': 'ino'}
  Plug 'jplaut/vim-arduino-ino', { 'for': 'ino'}
  "{{{
  let g:vim_arduino_library_path = '/usr/share/arduino'
  let g:vim_arduino_serial_port = '/dev/ttyACM0' 
  "}}}
  Plug 'derekwyatt/vim-sbt', { 'for': 'sbt.scala'}
  Plug 'derekwyatt/vim-scala', { 'for': 'scala'}

  "" Development
  "Plug '~/dev/vim-sections'

endif
if index(['default', 'win32', 'connector'], s:config) != -1
  " Minimal most important plugins
  Plug 'bling/vim-airline'
  "{{{
  set guifont=Inconsolata\ for\ Powerline:h15
  let g:Powerline_symbols = 'fancy'
  set encoding=utf-8
  set t_Co=256
  set fillchars+=stl:\ ,stlnc:\
  set termencoding=utf-8
  " use airline tabs instead of normal tabs
  let g:airline#extensions#tabline#enabled = 1
  let g:airline#extensions#tabline#fnamemod = ':t'
  "let g:airline#extensions#tabline#show_buffers = 0
  let g:airline#extensions#tabline#buffer_nr_show = 1
  "}}}
  Plug 'moll/vim-bbye'
  Plug 'scrooloose/nerdcommenter'
  "{{{
  "custom delimiters
  let g:NERDCustomDelimiters = { 
    \ 'puppet': { 'left': '#', 'leftAlt': '/*', 'rightAlt': '*/' }, 
    \ 'python': { 'left': '#', 'leftAlt': "''' ", 'rightAlt': "'''"}
    \ }
  "}}}
  Plug 'ekalinin/Dockerfile.vim', { 'for': 'Dockerfile'}
endif
if index(['default', 'connector'], s:config) != -1
  colorscheme summerfruit256

  " Custom light comment
  " {{{
  let g:delMap = {
      \ 'python': '#',
      \ 'vim': '"',
      \ 'sh': '#',
      \ 'Dockerfile': '#',
      \ }
  " }}}

  " Retrieve normal comment fg color
  let g:ctermfg_comment = synIDattr( hlID('Comment'), 'fg')

  fun! LightComment()
    " Get correct delimiter for filetype 
    try
      let comDel = g:delMap[&l:ft]
    catch
      return
    endtry

    " Create basic syntax rule for all filetypes
    let synCmd = "syn match CommentHint "
      \ ."'\\v\\s*" .comDel ."+ .*$' contains=Todo,@Spell"
    exec synCmd

    " Tweaking for different filetypes / syntaxes
    if &l:ft == 'vim'
      syn cluster vimFuncBodyList add=CommentHint
    endif

    " Change default comment to lighter version
    hi Comment ctermfg=114 gui=bold cterm=bold

    " Highlight only comments with spaces as full comments
    exec 'hi CommentHint ctermfg=' .g:ctermfg_comment .'gui=bold cterm=bold'

  endfun
  augroup LightComment
      autocmd!
      autocmd WinEnter,VimEnter,BufEnter * :silent! call LightComment() 
  augroup END

endif

"Plug 'vim-scripts/vimwiki'
""{{{
"let vimwiki_path=$HOME.'/vimwiki/'
"let vimwiki_html_path=$HOME.'/vimwiki_html/'
"let g:vimwiki_table_auto_fmt = 0
"let wiki = {}
"let wiki.path_html = vimwiki_html_path
"let wiki.template_path = vimwiki_html_path
"let wiki.template_default = 'default'
"let wiki.template_ext = '.tpl'
"let wiki.nested_syntaxes = {'python': 'python', 'c++': 'cpp'}
"let g:vimwiki_list = [wiki]

"au BufWritePost *.wiki
  "\ call vimwiki#html#Wiki2HTML(expand(VimwikiGet('path_html')),
  "\                             expand('%'))
"nnoremap <leader>wv :60vs \| VimwikiIndex<cr>
""}}}
"Plug 'rosenfeld/conque-term'
""{{{
"let g:ConqueTerm_StartMessages = 0
""}}}
"Plug 'f4t-t0ny/DrawIt'
""{{{
"fun! CutBlock(brush) range
  "let b:drawit_brush= a:brush
  "if visualmode() == "\<c-v>" && ((a:firstline == line("'>") && a:lastline == line("'<")) || (a:firstline == line("'<") && a:lastline == line("'>")))
   "exe 'norm! gv"'.b:drawit_brush.'y'
   "exe 'norm! gvr "'
  "endif
"endfun
"com! -nargs=1 -range CutBlock <line1>,<line2>call CutBlock(<q-args>)
"com! -nargs=1 -range CopyBlock <line1>,<line2>call DrawIt#SetBrush(<q-args>)
""}}}

call plug#end()

" COMMANDS: {{{1
" Reload vimrc
com! Reload so ~/.vimrc

" Vert split with open buffer
com! -nargs=* Vsb vert sb <args>

" Full window help 
com! -nargs=1 -complete=help H enew | h <args> | wincmd k | bd       

" Go to open buffer with <leader>i
for i in range(1,10)
  execute "noremap <leader>".i." :b".i."<cr>"
endfor

" Silent shell commands
command! -nargs=+ Silent
\ | execute ':silent !'.<q-args>
\ | execute ':redraw!'

" Identify syntax group under the cursor
map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" INIT: {{{1
" colorize after 80 columns
let &colorcolumn=join(range(81,999),',')

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
