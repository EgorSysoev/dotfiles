" Common Commands
" ---------------
" Switch Buffers                                    = <Tab> or <S-Tab> (when in normal mode)
" Close Current Buffer without messing with windows = ,x
" Switch between currently open panes               = ,C

" Pathogen lines
runtime bundle/vim-pathogen/autoload/pathogen.vim
call pathogen#infect()
call pathogen#helptags()

" Remap Leader to ,
imap jj <esc>
let mapleader= ","
let g:mapleader= ","

" Basic setup, enter :help [setting] to see what these are
set encoding=utf-8
set number
set ruler
set hidden
set smarttab
set expandtab
set textwidth=80
set textwidth=0
set tabstop=2
set softtabstop=2
set shiftwidth=2
set foldlevel=0
set autoindent
set incsearch
set hlsearch
set ignorecase
set smartcase
set wildmenu
set backspace=indent,eol,start
set t_Co=256
set nocompatible
set guioptions-=T
set showcmd
set laststatus=2
set mouse=
set noerrorbells visualbell t_vb=
set wildignore+=*.o,*.obj,.git,*.pyc,parts,*.egg-info,node_modules,
syntax on

" turn on all python syntax highlighting
let python_highlight_all=1

" Solarized Theme Dark
colorscheme solarized
set background=dark

let g:solarized_termcolors=16

" We have to have a winheight bigger than we want to set winminheight. But if
" we set winheight to be huge before winminheight, the winminheight set will
" fail.
set winwidth=84
set winheight=5
set winminheight=5
set winheight=999

" Set to show invisibles (tabs & trailing spaces) & their highlight color
set list listchars=tab:»\ ,trail:·
highlight SpecialKey guifg=#FF003F

" Allow syntastic sytax checking
let syntastic_enable_signs=1
let g:syntastic_enable_signs=1
let syntastic_quiet_warnings=1
let g:syntastic_quiet_warnings=1

" Custom Commands. Switching bufferes, running CoffeeScript, CommandT, running
" tests
map <Tab> :bn<CR>
map <S-Tab> :bp<CR>
map <leader>x :bd<cr>
map <leader><S-c> <C-w><C-w>
map <leader>f :CommandTFlush<cr>\|:CommandT<cr>
map <leader>cr :CoffeeRun<cr>
map <leader>cp :!clear && coffee -p %<cr>
map <leader>dt :w\|:!python -m doctest %<cr>
nnoremap <leader><leader> <c-^>

" Simple auto closing backets & parenthesis
inoremap (      ()<Left>
inoremap (<CR>  (<CR>)<Esc>O
inoremap <expr> ) strpart(getline('.'), col('.')-1, 1) == ")" ? "\<Right>" : ")"
inoremap [      []<Left>
inoremap [<CR>  [<CR>]<Esc>O
inoremap <expr> ] strpart(getline('.'), col('.')-1, 1) == "]" ? "\<Right>" : "]"
inoremap {      {}<Left>
inoremap {<CR>  {<CR>}<Esc>O
inoremap <expr> } strpart(getline('.'), col('.')-1, 1) == "}" ? "\<Right>" : "}"

" Custom django template tag matching
inoremap {%     {%%}<Left><Left>

" Custom Single and double quote handling, most people
" probably wouldn't like this
inoremap ""     ""<Left>
inoremap """    """<CR>"""<Esc>kA
inoremap <expr> " strpart(getline('.'), col('.')-1, 1) == '"' ? "\<Right>" : '"'
inoremap ''     ''<Left>
inoremap '''    '''<CR>'''<Esc>kA
inoremap <expr> ' strpart(getline('.'), col('.')-1, 1) == "'" ? "\<Right>" : "'"

" Function for removing trailing white space on save
function! <SID>StripTrailingWhitespaces()
  " Preparation: save last search, and cursor position.
  let _s=@/
  let l = line(".")
  let c = col(".")
  " Do the business:
  %s/\s\+$//e
  " Clean up: restore previous search history, and cursor position
  let @/=_s
  call cursor(l, c)
endfunction

" Turn On FileType Detection
filetype plugin indent on

if has("autocmd")
  " Set filetype tab settings
  autocmd FileType ruby,html,javascript,stylus,css,xml,htmldjango set ai sw=2 sts=2 et
  autocmd FileType python,doctest set ts=4 sw=4 sts=4 et

  " Set Syntax Highlighting for odd file types
    au BufNewFile,BufRead *.json set filetype=json syntax=javascript
    au BufNewFile,BufRead *.pt,*.cpt,*.zpt set filetype=zpt syntax=xml
    au BufNewFile,BufRead *.zcml set filetype=zcml syntax=xml
    au BufNewFile,BufRead *.txt set filetype=doctest

    " Set Syntax Highlighting for html to default to django
    au BufNewFile,BufRead *.html set ft=htmldjango

    " This automatically removes the trailing whitespace in specific file types
    autocmd BufWritePre *.py :call <SID>StripTrailingWhitespaces()

    " Restore cursor position
    autocmd BufReadPost *
      \ if line("'\"") > 1 && line("'\"") <= line("$") |
      \   exe "normal! g`\"" |
      \ endif
endif

" MULTIPURPOSE TAB KEY (taken from Gary Bernhardt)
" Indent if we're at the beginning of a line. Else, do completion.
function! InsertTabWrapper()
  let col = col('.') - 1
  if !col || getline('.')[col - 1] !~ '\k'
    return "\<tab>"
  else
    return "\<c-p>"
  endif
endfunction
inoremap <tab> <c-r>=InsertTabWrapper()<cr>
inoremap <s-tab> <c-n>

" DON't USE ARROW KEYS
map <Left> :echo "no!"<cr>
map <Right> :echo "no!"<cr>
map <Up> :echo "no!"<cr>
map <Down> :echo "no!"<cr>

" RENAME CURRENT FILE
function! RenameFile()
  let old_name = expand('%')
  let new_name = input('New file name: ', expand('%'))
  if new_name != '' && new_name != old_name
    exec ':saveas ' . new_name
    exec ':silent !rm ' .old_name
    redraw!
  endif
endfunction
map <leader>n :call RenameFile()<cr>

" Get rid of those annoying ~'s on lines that don't exist yet
highlight NonText ctermfg= bg
