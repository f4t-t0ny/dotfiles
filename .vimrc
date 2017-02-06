" General settings
set ts=2
set sw=2
set nu

" Fix for backspace to work on mac
set backspace=indent,eol,start 

" Enable syntax highlighting
syntax on

" set leader key
let mapleader=","

" activate mouse
set mouse=a

" Use system clipboard on mac
set clipboard=unnamed

" Plugins begin
call plug#begin('~/.vim/plugged')  

"" Jedi
Plug 'davidhalter/jedi-vim'
let g:jedi#usages_command = "<leader>u"
autocmd FileType python setlocal completeopt-=preview

" Bbye
Plug 'moll/vim-bbye'

" Nerdtree
Plug 'scrooloose/nerdtree'
noremap <Leader>n :NERDTreeToggle<CR>

" Nerdcommenter
Plug 'scrooloose/nerdcommenter'

" Airline for buffer line
Plug 'bling/vim-airline'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#tabline#buffer_nr_show = 1

" Syntastic
Plug 'vim-syntastic/syntastic'
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" Signify
Plug 'mhinz/vim-signify'
let g:signify_vcs_list = [ 'hg', 'git' ]

" Hocon
Plug 'GEverding/vim-hocon'

" Puppet
Plug 'rodjek/vim-puppet'

call plug#end()
