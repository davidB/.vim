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
"call pathogen#infect()

" The next two lines ensure that the ~/.vim/bundle/ system works
" silent! call pathogen#helptags()
" silent! call pathogen#runtime_append_all_bundles()
filetype plugin on

" @see https://github.com/MarcWeber/vim-addon-manager/blob/master/doc/vim-addon-manager.txt
" @see https://github.com/MarcWeber/vim-addon-manager-known-repositories/tree/master/db
fun SetupVAM()
  " YES, you can customize this vam_install_path path and everything still works!
  let vam_install_path = expand('$HOME') . '/.vim/vim-addons'
  exec 'set runtimepath+='.vam_install_path.'/vim-addon-manager'

  " * unix based os users may want to use this code checking out VAM
  " * windows users want to use http://mawercer.de/~marc/vam/index.php
  " to fetch VAM, VAM-known-repositories and the listed plugins
  " without having to install curl, unzip, git tool chain first
  " -> BUG [4] (git-less installation)
  if !filereadable(vam_install_path.'/vim-addon-manager/.git/config') && 1 == confirm("git clone VAM into ".vam_install_path."?","&Y\n&N")
    " I'm sorry having to add this reminder. Eventually it'll pay off.
    call confirm("Remind yourself that most plugins ship with documentation (README*, doc/*.txt). Its your first source of knowledge. If you can't find the info you're looking for in reasonable time ask maintainers to improve documentation")
    exec '!p='.shellescape(vam_install_path).'; mkdir -p "$p" && cd "$p" && git clone --depth 1 git://github.com/MarcWeber/vim-addon-manager.git'
    " VAM run helptags automatically if you install or update plugins
    exec 'helptags '.fnameescape(vam_install_path.'/vim-addon-manager/doc')
  endif

  " Example drop git sources unless git is in PATH. Same plugins can
  " be installed form www.vim.org. Lookup MergeSources to get more control
  " let g:vim_addon_manager['drop_git_sources'] = !executable('git')

  call vam#ActivateAddons([], {'auto_install' : 0})
  " sample: call vam#ActivateAddons(['pluginA','pluginB', ...], {'auto_install' : 0})
  " - look up source from pool (<c-x><c-p> complete plugin names):
  " ActivateAddons(["foo", ..
  " - name rewritings:
  " ..ActivateAddons(["github:foo", .. => github://foo/vim-addon-foo
  " ..ActivateAddons(["github:user/repo", .. => github://user/repo
  " Also see section "2.2. names of addons and addon sources" in VAM's documentation
endfun
call SetupVAM()
" experimental: run after gui has been started (gvim) [3]
" option1: au VimEnter * call SetupVAM()
" option2: au GUIEnter * call SetupVAM()
" See BUGS sections below [*]
" Vim 7.0 users see BUGS section [3]

call vam#ActivateAddons(["vim-haxe", "FuzzyFinder", "unimpaired", "The_NERD_tree", "Syntastic", "Source_Explorer_srcexpl.vim", "snipmate", "SuperTab_continued.", "indexer.tar.gz_", "project.tar.gz", "vimprj", "DfrankUtil", "fugitive", "closetag"])
" add NERDCommenter to toggle comment line,...
call vam#ActivateAddons(["Solarized"])

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
   
  autocmd BufNewFile,BufRead *.rss      setfiletype xml
  autocmd BufNewFile,BufRead *.coffee   setfiletype coffee

  " Remove trailing whitespaces and ^M chars
  " for alternate implementation see http://vimcasts.org/episodes/tidying-whitespace/
  autocmd FileType c,cpp,java,scala,php,js,coffee,python,twig,xml,yml autocmd BufWritePre <buffer> :call setline(1,map(getline(1,"$"),'substitute(v:val,"\\s\\+$","","")'))

  " auto compile on save (poor solution vs :make or syntastic
  "autocmd BufWritePost,FileWritePost *.coffee :silent !coffee -c <afile>

  " Automatically cd into the directory that the file is in
  "autocmd BufEnter * execute "chdir ".escape(expand("%:p:h"), ' ')
  "set autochdir

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
map <F8> :NERDTreeToggle<CR>

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
" tags (code navigation)
" @see http://stackoverflow.com/questions/563616/vim-and-ctags-tips-and-tricks/741486#741486
"set tags+=tags;$HOME
set tags=./tags;/ 
" Alt-right/left to navigate forward/backward in the tags stack
map <F3> <C-T>
map <S-F3> <C-]>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin Syntastic

let g:syntastic_enable_signs=1
let g:syntastic_auto_jump=1
let g:syntastic_auto_loc_list=1
let g:syntastic_stl_format = '[%E{Err: %fe #%e}%B{, }%W{Warn: %fw #%w}]'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin SuperTab
let g:SuperTabDefaultCompletionType = "context"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin TagBar 
let g:tagbar_type_coffee = {
      \ 'ctagstype' : 'coffee',
      \ 'kinds' : [
      \   'c:class',
      \   'f:functions',
      \   'v:variables'
      \ ],
      \ }

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" special function
function! CleanEOL()
  :%s///g
  :%s///g
  :%s/\[K//g
  :%s///g
endf
