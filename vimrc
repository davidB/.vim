
" Windows:  $VIM/_vimrc (original)
" *n*x   :  ~/.vimrc
"
" some inspirations :
" * http://www.pinkjuice.com/vim/vimrc.txt
" *
" * https://github.com/spf13/spf13-vim
" * https://github.com/jceb/vimrc

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" general

set nocompatible " must be first line

syntax on
highlight Normal guifg=Black guibg=#ffefd5

set showcmd
set showmode

set formatoptions=t
set fileformats=unix,dos,mac " favorite fileformats
set encoding=utf-8           " set default-encoding to utf-8
set termencoding=utf-8
"set termencoding=latin1
"set guifont=courier_new:h10
set guifont=Courier\ New:h10,Courier,Lucida\ Console,Letter\ Gothic,
 \Arial\ Alternative,Bitstream\ Vera\ Sans\ Mono,OCR\ A\ Extended
set nowrap
"set textwidth=70
set visualbell
set noerrorbells
set number
set ruler
"set whichwrap=<,>,h,l
set guioptions=bgmrL
set backspace=2
set history=50
set noswapfile                 " turn off backups and files
set nobackup                   " Don't keep a backup file
set wildmenu
set nrformats=
set foldlevelstart=99

if has("unix")
  set shcf=-ic
endif
if has('win32') || has('win64')
  set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
endif

let mapleader = ","
let $ADDED = '~/.vim/added/'
if has("win32")
  let $ADDED = $VIM.'/added/'
endif

map <Leader>cd :exe 'cd ' . expand ("%:p:h")<CR>
nmap <F1> :w<CR>
imap <F1> <ESC>:w<CR>a
map <F8> gg"+yG

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" plugin

" use pathogen http://www.vim.org/scripts/script.php?script_id=2332
" runtime! autoload/pathogen.vim
call pathogen#infect()
" The next two lines ensure that the ~/.vim/bundle/ system works
silent! call pathogen#helptags()
silent! call pathogen#runtime_append_all_bundles()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" close buffer without close window view
" see http://stackoverflow.com/questions/256204/close-file-without-quitting-vim-application
"
map fc <Esc>:call CleanClose(1)

map fq <Esc>:call CleanClose(0)


function! CleanClose(tosave)
  if (a:tosave == 1)
    w!
  endif
  let todelbufNr = bufnr("%")
  let newbufNr = bufnr("#")
  if ((newbufNr != -1) && (newbufNr != todelbufNr) &&  buflisted(newbufNr))
    exe "b".newbufNr
  else
    bnext
  endif

  if (bufnr("%") == todelbufNr)
    new
  endif
  exe "bd".todelbufNr
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" indentation
set expandtab       "Use softtabstop spaces instead of tab characters for indentation
set shiftwidth=2    "Indent by 4 spaces when using >>, <<, == etc.
set softtabstop=2   "Indent by 4 spaces when pressing <TAB>

set autoindent      "Keep indentation from previous line
set smartindent     "Automatically inserts indentation in some cases
set cindent         "Like smartindent, but stricter and more customisable

if has ("autocmd")
  " File type detection. Indent based on filetype. Recommended.
  filetype plugin indent on
  autocmd FileType make set noexpandtab " no expand for makefiles
endif

" Remove trailing whitespaces and ^M chars
autocmd FileType c,cpp,java,scala,php,js,coffee,python,twig,xml,yml autocmd BufWritePre <buffer> :call setline(1,map(getline(1,"$"),'substitute(v:val,"\\s\\+$","","")'))

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Copy/Paste
"
" yank/paste to/from clipboard
nnoremap gpc "+p
vnoremap gyc "+y

" Yank from the cursor to the end of the line, to be consistent with C and D.
nnoremap Y y$

"
" avoid autoindent
" see http://vim.wikia.com/wiki/Toggle_auto-indenting_for_code_paste
" see http://amix.dk/blog/viewEntry/19083
noremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>

" groovyness in Insert mode (lets you paste and keep on typing)
" This blows away i_CTRL-V though (see :help i_CTRL-V)
imap <C-v> <Esc><C-v>a
set go-=a
set clipboard-=unnamed

"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" my custom key map
map <F3> :NERDTreeToggle<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Mouse support

set mouse=a

" scroll with mouse wheel
" @see http://vimdoc.sourceforge.net/htmldoc/scroll.html
map <ScrollWheelUp> <C-Y>
map <S-ScrollWheelUp> <C-U>
map <ScrollWheelDown> <C-E>
map <S-ScrollWheelDown> <C-D>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Status line display
set laststatus=2         " statusline is always visible
set ttyfast              " assume a fast tty connection

" draw the status line
function! StatusLine()
        let res = ""
        let bufnr = bufnr('%')
        let res .= bufnr.':'

        let current_file = expand('%:t')
        if current_file == ""
                let current_file = '[No Name]'
        endif
        let res .= current_file
        if &readonly
                let res .= ' [RO]'
        endif
        if ! &modifiable
                if ! &readonly
                        let res .= ' '
                endif
                let res .= '[-]'
        elseif &modified
                if ! &readonly
                        let res .= ' '
                endif
                let res .= '[+]'
        endif

        let alternate_bufnr = bufnr('#')
        let alternate_file = expand('#:t')
        if alternate_bufnr != -1
                if alternate_file == ""
                        let alternate_file = '[No Name]'
                else
                        let res .= ' #'.alternate_bufnr.':'.alternate_file
                endif
        endif

        if &bomb
                let res .= ' BOMB WARNING'
        endif
        if &paste
                let res .= ' PASTE'
        endif
        if ! &eol
                let res .= ' NOEOL'
        endif

        if exists('*TagInStatusLine')
                let res .= ' '.TagInStatusLine()
        endif
        return res
endfunction

set statusline=%{StatusLine()}%=[%{&fileformat}:%{&fileencoding}:%{&filetype}]\ %l,%c/%vv\ %P " statusline
