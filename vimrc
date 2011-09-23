
" Windows:  $VIM/_vimrc (original)
" *n*x   :  ~/.vimrc
" www.pinkjuice.com/vim/vimrc.txt

" for more info check
" www.pinkjuice.com/vim/
" regarding XML related stuff check
" www.pinkjuice.com/howto/vimxml/
" email: tobiasreif pinkjuice com

" The following works for me with Vim 6.2 on Windows
" (most stuff also works on Linux),
" but I don't recommend to blindly copy and use it.
" (check the respective documentation)

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" general

set nocompatible

syntax on
highlight Normal guifg=Black guibg=#ffefd5

set showcmd
set mouse=a
set formatoptions=t
"set textwidth=70
set encoding=utf-8
set termencoding=latin1
set fileformat=unix
"set guifont=courier_new:h10
set guifont=Courier\ New:h10,Courier,Lucida\ Console,Letter\ Gothic,
 \Arial\ Alternative,Bitstream\ Vera\ Sans\ Mono,OCR\ A\ Extended
set nowrap
set shiftwidth=2
set visualbell
set noerrorbells
set number
set autoindent
set ruler
set expandtab
"set whichwrap=<,>,h,l
set guioptions=bgmrL
set backspace=2
set history=50
"set backup
set wildmenu
set nrformats=
set foldlevelstart=99
if has("unix")
  set shcf=-ic
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
call pathogen#infect()

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


""""
" mouse wheel to scroll (see http://vimdoc.sourceforge.net/htmldoc/scroll.html#scroll-mouse-wheel)
:map <ScrollWheelUp> <C-Y>
:map <S-ScrollWheelUp> <C-U>
:map <ScrollWheelDown> <C-E>
:map <S-ScrollWheelDown> <C-D>
