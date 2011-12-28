
" Windows:  $VIM/_vimrc (original)
" *n*x   :  ~/.vimrc
"
" some inspirations :
" * http://www.pinkjuice.com/vim/vimrc.txt
" *
" * https://github.com/spf13/spf13-vim
" * https://github.com/jceb/vimrc
" * http://electronicvendor.com/what-is-in-your-vimrc/

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" general

set nocompatible " must be first line

set showcmd
set showmode

set formatoptions=t
set fileformats=unix,dos,mac " favorite fileformats
set encoding=utf-8           " set default-encoding to utf-8
set termencoding=utf-8
set term=$TERM
set shell=bash
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
set nowritebackup
set backupdir=~/.vim/backup,/tmp
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

" use pathogen
" @see http://www.vim.org/scripts/script.php?script_id=2332

" runtime! autoload/pathogen.vim
call pathogen#infect()

" The next two lines ensure that the ~/.vim/bundle/ system works
silent! call pathogen#helptags()
silent! call pathogen#runtime_append_all_bundles()
filetype plugin on

"set runtimepath+=~/.vim/vam
"call vam#ActivateAddons(["snipmate","vim-haxe"])
call vam#ActivateAddons(["vim-haxe", "FuzzyFinder", "unimpaired"])
"call scriptmanager#Activate(["vim-haxe"])

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" syntax colors
syntax on
"highlight Normal guifg=Black guibg=#ffefd5
set background=dark
highlight clear
"colorscheme solarized
colorscheme elflord


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" close buffer without close window view
" @see http://stackoverflow.com/questions/256204/close-file-without-quitting-vim-application
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
" @see http://vimcasts.org/episodes/tabs-and-spaces/

set expandtab       "Use softtabstop spaces instead of tab characters for indentation
set shiftwidth=2    "Indent by 2 spaces when using >>, <<, == etc.
set softtabstop=2   "Indent by 2 spaces when pressing <TAB>
set tabstop=2

set autoindent      "Keep indentation from previous line
set smartindent     "Automatically inserts indentation in some cases
set cindent         "Like smartindent, but stricter and more customisable

if has ("autocmd")
  " File type detection. Indent based on filetype. Recommended.
  filetype on
  filetype plugin indent on

  " Syntax of these languages is fussy over tabs Vs spaces
  autocmd FileType make setlocal ts=8 sts=8 sw=8 noexpandtab
  autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
   
  " Customisations based on house-style (arbitrary)
  "autocmd FileType html setlocal ts=2 sts=2 sw=2 expandtab
  "autocmd FileType css setlocal ts=2 sts=2 sw=2 expandtab
  "autocmd FileType javascript setlocal ts=2 sts=2 sw=2 expandtab
  autocmd FileType php setlocal ts=4 sts=4 sw=4 expandtab
   
  " Treat .rss files as XML
  autocmd BufNewFile,BufRead *.rss setfiletype xml
  

  " Remove trailing whitespaces and ^M chars
  " for alternate implementation see http://vimcasts.org/episodes/tidying-whitespace/
  autocmd FileType c,cpp,java,scala,php,js,coffee,python,twig,xml,yml autocmd BufWritePre <buffer> :call setline(1,map(getline(1,"$"),'substitute(v:val,"\\s\\+$","","")'))

  " auto compile on save (poor solution vs :make or syntastic
  "autocmd BufWritePost,FileWritePost *.coffee :silent !coffee -c <afile>

  " Automatically cd into the directory that the file is in
  "autocmd BufEnter * execute "chdir ".escape(expand("%:p:h"), ' ')
  set autochdir

endif
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Copy/Paste
"
" to use system/x11 clipboard check "vim --version |grep '+xterm_clipboard'"
" else try to install gvim (on archlinux it install a vim version with
" +xterm_clipboard) or try to use xclip (see key mapping below)
"
" @see http://vim.wikia.com/wiki/Accessing_the_system_clipboard

" yank/paste to/from clipboard
"nnoremap gpc "+p
"vnoremap gyc "+y

" @see http://vimdoc.sourceforge.net/htmldoc/options.html#%27clipboard%27
set clipboard=unnamedplus

" if use xclip
"vmap <C-c> :<Esc>`>a<CR><Esc>mx`<i<CR><Esc>my'xk$v'y!xclip -selection c<CR>u
"map <Insert> :set paste<CR>i<CR><CR><Esc>k:.!xclip -o<CR>JxkJx:set nopaste<CR> 

"Yank from the cursor to the end of the line, to be consistent with C and D.
nnoremap Y y$


" avoid autoindent
" @see http://vim.wikia.com/wiki/Toggle_auto-indenting_for_code_paste
" @see http://amix.dk/blog/viewEntry/19083
noremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" bubble(move) text
" @see http://vimcasts.org/episodes/bubbling-text/
" use vim-unimpaire

" Bubble single lines
nmap <C-Up> [e
nmap <C-Down> ]e
" Bubble multiple lines
vmap <C-Up> [egv
vmap <C-Down> ]egv
" Visually select the text that was last edited/pasted
nmap gV `[v`]

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

set statusline=%{StatusLine()}
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
set statusline+=%=[%{&fileformat}:%{&fileencoding}:%{&filetype}]\ %l,%c/%vv\ %P " statusline

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Show invisible
" @see http://vimcasts.org/episodes/show-invisibles/

" Shortcut to rapidly toggle `set list`
nmap <leader>l :set list!<CR>

" Use the same symbols as TextMate for tabstops and EOLs
set listchars=tab:▸\ ,eol:¬

"Invisible character colors
highlight NonText guifg=#4a4a59
highlight SpecialKey guifg=#4a4a59


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin Syntastic

let g:syntastic_enable_signs=1
let g:syntastic_auto_jump=1
let g:syntastic_auto_loc_list=1
let g:syntastic_stl_format = '[%E{Err: %fe #%e}%B{, }%W{Warn: %fw #%w}]'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" special function
function! CleanEOL()
  :%s///g
  :%s///g
  :%s/\[K//g
  :%s///g
endf
