set nocompatible            " disable compatibility to old-time vi
set showmatch               " show matching 
set ignorecase              " case insensitive 
set mouse=v                 " middle-click paste with 
set hlsearch                " h:ighlight search 
set incsearch               " incremental search
set tabstop=4               " number of columns occupied by a tab 
set softtabstop=4           " see multiple spaces as tabstops so <BS> does the right thing
set expandtab               " converts tabs to white space
set shiftwidth=4            " width for autoindents
set autoindent              " indent a new line the same amount as the line just typed
set relativenumber          " add line numbers
set wildmode=longest,list   " get bash-like tab completions
filetype plugin indent on   " allow auto-indenting depending on file type
syntax on                   " syntax highlighting
set mouse=a                 " enable mouse click
set clipboard+=unnamedplus  " using system clipboard
filetype plugin on
set ttyfast                 " Speed up scrolling in Vim
set spell                   " enable spell check (may need to download language package)
" set noswapfile            " disable creating swap file
set backupdir=~/.cache/vim  " Directory to store backup files.
let mapleader = ","

" ******************************* VIMPLUG ***********************************
call plug#begin()
    " Appearance
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'ryanoasis/vim-devicons'
    Plug 'morhetz/gruvbox'
    " Utilities
    Plug 'sheerun/vim-polyglot'
    Plug 'jiangmiao/auto-pairs'
    Plug 'ap/vim-css-color'
    Plug 'preservim/nerdtree'
    Plug 'preservim/nerdcommenter'
    " Completion / linters / formatters
    Plug 'plasticboy/vim-markdown'
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    " Git
    Plug 'airblade/vim-gitgutter'
    " Latex
    Plug 'lervag/vimtex'
    " Ctrlp
    Plug 'ctrlpvim/ctrlp.vim'
    " Rust
    Plug 'rust-lang/rust.vim'
call plug#end()
" ******************************* VIMPLUG ***********************************

" ******************************* THEMING ***********************************
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme='gruvbox'
set termguicolors
colorscheme gruvbox
filetype plugin indent on
filetype plugin on
" ******************************* THEMING ***********************************

" setup nerdtree
let NERDTreeShowHidden=1 " show hidden files

" setup ctrlp
let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']

" ******************************* VIMTEX ***********************************
" This enables Vim's and neovim's syntax-related features. Without this, some
" VimTeX features will not work (see ":help vimtex-requirements" for more
" info).
"syntax enable

" setup vim markdown
let g:tex_conceal = '' "disable math conceal?
let g:vim_markdown_math = 1
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_frontmatter = 1
let g:vim_markdown_conceal = 0
let g:vim_markdown_fenced_languages = ['tsx=typescriptreact']

" Viewer options: One may configure the viewer either by specifying a built-in
" viewer method:
let g:vimtex_view_method = 'zathura'

" Or with a generic interface:
let g:vimtex_view_general_viewer = 'zathura'
let g:vimtex_view_general_options = '--unique file:@pdf\#src:@line@tex'
let g:tex_flavor = 'latex'

" VimTeX uses latexmk as the default compiler backend. If you use it, which is
" strongly recommended, you probably don't need to configure anything. If you
" want another compiler backend, you can change it as follows. The list of
" supported backends and further explanation is provided in the documentation,
" see ":help vimtex-compiler".
let g:vimtex_compiler_method = 'latexrun'

" Most VimTeX mappings rely on localleader and this can be changed with the
" following line. The default is usually fine and is the symbol "\".
let maplocalleader = ","
" ******************************* VIMTEX ***********************************

" ***************************** REMAPPINGS ***********************************
nnoremap <C-q> :q!<CR>
nnoremap <F4> :bd<CR>
" elnerdo tree
nnoremap <F5> :NERDTreeToggle<CR>   
" Tabs
nnoremap <S-Tab> :bnext<CR>
nnoremap <silent> <S-t> :tabnew<CR>
" disable arrow keys :)
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>
" ***************************** REMAPPINGS ***********************************

source $HOME/.config/nvim/plug-config/coc.vim
