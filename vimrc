set encoding=utf-8      "file encoding
set scrolloff=3         "number of lines of context above/below cursor
set showmode            "shows the current edit mode
set showcmd             "shows the current command
set hidden              "buffer is hidden if abandoned
set wildmenu            "wildcard-based menu
set cursorline          "highlight cursor line
set ttyfast             "more characters will be sent to screen for redrawing
set relativenumber      "line numbers are relative to current line
set undofile            "create an undo file that persists

set nocompatible        "not vi compatible, which is a-okay
set backspace=indent,eol,start      "now that's what i call rational backspacing

syntax on               "turn on syntax highlighting
try
    colorscheme tomorrow-night-eighties
catch /^Vim\%((\a\+)\)\=:E185/
    colorscheme desert      "set the colorscheme, currently using vims desert builtin
endtry

set foldclose=          "turn off automatic foldclosing

set autochdir           "change the cwd to the same dir the cur file is in

" indenting
set expandtab           "expand insert # spaces that makes a tab
set shiftwidth=4        "4 spaces for shifting
set softtabstop=4       "tabs are 4 spaces
set autoindent
set nosmartindent
set cindent             "c-style indentation
set cinkeys=!^F         "only indent when requested
set cinoptions=(0t0c1   " :help cinoptions-values

let mapleader=","       "set new leader key

nnoremap / /\v
vnoremap / /\v
set gdefault            "apply substitutions globally on a line
set incsearch
set hlsearch
" clear out search by typing ,<space>
nnoremap <leader><space> :noh<cr>
nnoremap <tab> %
vnoremap <tab> %

set wrap
set formatoptions=qrn1
set colorcolumn=80

" turn off beeping
set noerrorbells        "no audible bell
set visualbell
autocmd VimEnter * set vb t_vb= "make the visual bell zero time, doesn't blink

set ruler               " user a ruler, tell me where I am in the file
set showcmd             " show me the vim command in the ruler
set showmatch           " show me matching close braces
set ignorecase          " case insensitive searching
set smartcase           " unless I really mean case sensitive
set list                " show me whitespace where I care

" useful misc options
set listchars=tab:>_    " in case I want to use the 'list' option
set matchpairs+=<:>     " match < > with the % command, too
set complete=.,w,b,i,t,u    " to help complete
set formatoptions=tcrqn

" keep state about editing
set viminfo='50,\"1000,:100,n~/.viminfo

if has("autocmd")
    "enable filetype detection
    filetype plugin indent on
endif

"teach me to do things right!
"that is, learn hjkl correctly
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>
nnoremap j gj
nnoremap k gk

"get rid of the help key
inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>

"make ; work instead of : 'cause seriously, it's okay
"nnoremap ; :

" set gui options
if has("gui_running")
    if has("gui_gtk2")
        set guifont=Inconsolata\ Medium\ 12
    elseif has("gui_macvim")
        set guifont:Menlo:h14
    elseif has("gui_win32")
        set guifont:Consolas:h10
    else
        set guifont=Inconsolata:h12
    endif

    " macvim specific options
    if has("gui_macvim")
        "make macvim fullscreen stretch to full horiz
        set fuopt+=maxhorz
    endif

    set lines=50
    set columns=100

    set guioptions-=T       "remove the toolbar
    set guioptions-=m       "remove the menubar
    set guioptions+=c       "console-based dialogs for simple queries
    set guioptions-=r       "remove right scrollbar
    set guioptions-=L       "remove left scrollbar
endif


"strip whitespace from the end of the line in the current buffer
nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<CR>

"open .vimrc in a vertically split window so I can add things to it
nnoremap <leader>ev <C-w><C-v><C-l>:e $MYVIMRC<cr>

"quicker escaping
inoremap jj <ESC>

"use ,w to open a new vertical split and switch to it
nnoremap <leader>w <C-w>v<C-w>l

"more intuitive commands to move around splits
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

