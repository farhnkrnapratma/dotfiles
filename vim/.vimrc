" PLUGINS --------------------------------------------------------------------------------------------------------------------{{{

call plug#begin()

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'Yggdroot/indentLine'
Plug 'townk/vim-autoclose'
Plug 'rust-lang/rust.vim'
Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'PhilRunninger/nerdtree-visual-selection'
Plug 'tpope/vim-fugitive'
Plug 'rbong/vim-flog'
Plug 'scrooloose/syntastic'
Plug 'majutsushi/tagbar'
Plug 'catppuccin/vim', { 'as': 'catppuccin' }
Plug 'ryanoasis/vim-devicons'

call plug#end()

" --------------------------------------------------------------------------------------------------------------------------- }}}

" VIM BASIC SETTINGS ---------------------------------------------------------------------------------------------------------{{{

" Enable syntax highlighting
syntax on

" Enable filetype detection and plugins
filetype on
filetype plugin on
filetype indent on

" General settings
set nocompatible
set termguicolors
set showmode
set number
set relativenumber
set ruler
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set mouse=a
set nowrap
set scrolloff=10
set wildmenu
set wildmode=list:longest
set encoding=UTF-8

" Color scheme
colorscheme catppuccin_mocha
hi Normal guibg=NONE ctermbg=NONE

" Status line settings
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

" --------------------------------------------------------------------------------------------------------------------------- }}}

" PLUGIN SETTINGS ------------------------------------------------------------------------------------------------------------{{{

" Airline theme
let g:airline_theme='catppuccin_mocha'
let g:airline#extensions#tabline#enabled=1

" Indent line
let g:indentLine_char='¦'
let g:indentLine_color_term=8

" Rust settings
let g:rustfmt_autosave=1

" Syntastic settings
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" Hide End of Buffer (EoB) characters
let &fillchars ..= ',eob: '

" --------------------------------------------------------------------------------------------------------------------------- }}}

" NERDTREE SETTINGS ----------------------------------------------------------------------------------------------------------{{{

" NERDTree general settings
let g:NERDTreeFileLines=1
let g:NERDTreeShowHidden=1

" NERDTree Git plugin settings
let g:NERDTreeGitStatusIndicatorMapCustom = {
    \ 'Modified'  : '',
    \ 'Staged'    : '',
    \ 'Untracked' : '',
    \ 'Renamed'   : '',
    \ 'Unmerged'  : '',
    \ 'Deleted'   : '',
    \ 'Dirty'     : '󰈿',
    \ 'Ignored'   : '',
    \ 'Clean'     : '',
    \ 'Unknown'   : '',
    \ }

" NERDTree Git highlight settings
highlight NERDTreeGitModified guifg=#FFA500 ctermfg=214
highlight NERDTreeGitStaged guifg=#00FF00 ctermfg=10
highlight NERDTreeGitUntracked guifg=#FFFF00 ctermfg=11
highlight NERDTreeGitRenamed guifg=#00BFFF ctermfg=39
highlight NERDTreeGitUnmerged guifg=#FF0000 ctermfg=9
highlight NERDTreeGitDeleted guifg=#8B0000 ctermfg=1
highlight NERDTreeGitDirty guifg=#FFD700 ctermfg=3
highlight NERDTreeGitIgnored guifg=#808080 ctermfg=8
highlight NERDTreeGitClean guifg=#008000 ctermfg=2
highlight NERDTreeGitUnknown guifg=#A9A9A9 ctermfg=7

" NERDTree auto commands
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * NERDTree | if argc() > 0 || exists("s:std_in") | wincmd p | endif
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | call feedkeys(":quit\<CR>:\<BS>") | endif

" NERDTree key mappings
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>

" --------------------------------------------------------------------------------------------------------------------------- }}}

" KEY MAPPINGS ----------------------------------------------------------------------------------------------------------------{{{

" Tagbar toggle
nnoremap <F8> :TagbarToggle<CR>

" --------------------------------------------------------------------------------------------------------------------------- }}}
