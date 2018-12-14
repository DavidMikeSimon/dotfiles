call plug#begin('~/.local/share/nvim/plugged')
Plug 'frankier/neovim-colors-solarized-truecolor-only'
Plug 'kien/ctrlp.vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'simnalamburt/vim-mundo'
Plug 'scrooloose/nerdcommenter'
Plug 'tpope/tpope-vim-abolish'
" Plug 'tpope/vim-dispatch'
" Plug 'vim-airline/vim-airline'
" Plug 'vim-airline/vim-airline-themes'
Plug 'itchyny/lightline.vim'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
" Plug 'airblade/vim-gitgutter'
Plug 'easymotion/vim-easymotion'
Plug 'haya14busa/incsearch.vim'
Plug 'haya14busa/incsearch-fuzzy.vim'
Plug 'haya14busa/incsearch-easymotion.vim'
Plug 'mxw/vim-jsx'
Plug 'FooSoft/vim-argwrap'
Plug 'kassio/neoterm'
Plug 'djoshea/vim-autoread'
" Plug 'neomake/neomake'
Plug 'Shougo/deoplete.nvim'
" Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
" Plug 'junegunn/fzf.vim'
Plug 'janko-m/vim-test'
Plug 'isRuslan/vim-es6'
Plug 'nixprime/cpsm'
Plug 'elixir-editors/vim-elixir'
Plug 'maxbrunsfeld/vim-yankstack'
call plug#end()

let mapleader=","

set showcmd      " Show (partial) command in status line.
set showmatch    " Show matching brackets.
set ignorecase   " Do case insensitive matching
set smartcase    " Do smart case matching
set incsearch    " Incremental search
set autowrite    " Automatically save before commands like :next and :make
set hidden       " Hide buffers when they are abandoned
set mouse=a      " Enable mouse usage (all modes)
set ruler        " Always show current position
set autoindent   " Automatically copy indent to new lines
set nohlsearch   " Highlight search results
set shiftround   " Don't allow uneven indentation
set noshowmode   " Don't show --INSERT-- below the statusline
set lazyredraw   " Faster redrawing

" True color in terminal
set termguicolors

" Shortcuts to work with OS X clipboard
map <leader>xc :w !pbcopy<CR><CR>
map <leader>xp :r!pbpaste<CR>

" Convenience commands for window switching
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l
inoremap <C-h> <Esc> <C-w>h
inoremap <C-j> <Esc> <C-w>j
inoremap <C-k> <Esc> <C-w>k
inoremap <C-l> <Esc> <C-w>l
tnoremap <C-h> <C-\><C-n><C-w>h
tnoremap <C-j> <C-\><C-n><C-w>j
tnoremap <C-k> <C-\><C-n><C-w>k
tnoremap <C-l> <C-\><C-n><C-w>l
tnoremap <C-w> <C-\><C-n><C-w>

" yankstack
let g:yankstack_map_keys = 0
call yankstack#setup()
nmap <leader>p <Plug>yankstack_substitute_older_paste
nmap <leader>P <Plug>yankstack_substitute_newer_paste

" Tab completion settings
set completeopt=longest,menuone
set wildmode=longest,list,full
set wildmenu

" Set path to include everything below working directory
set path=,,**

" Save swapfiles in a separate directory
set directory=~/.nvim-swap//

" Nobody likes Ex mode
map Q <Nop>

" 120 columns
set cc=120

" Indicate noisily when vim has to do a soft break to show an entire line
set showbreak=+++++

" Handle comment insertion and joining helpfully
set formatoptions=croqj

" Language-specific comment settings
autocmd Filetype ruby setlocal comments=:#.,:#
autocmd Filetype javascript setlocal comments=s1:/*,mb:*,ex:*/,://.,://
autocmd Filetype javascript.jsx setlocal comments=s1:/*,mb:*,ex:*/,://.,://

" Scroll through long lines one visual line at a time
" DISABLED because it messes with relative line number motion (can it be fixed?)
"map j gj
"map k gk

" Fast scrolling up and down
map U <C-u>
map D <C-d>

" Searches wrap around file
set wrapscan

" Show current line number surrounded by relative number
set number
set relativenumber

" In Insert mode and when pane not in focus, show absolute line numbers
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END

" Reticule cursor
au WinLeave * set nocursorline nocursorcolumn
au WinEnter * set cursorline cursorcolumn
set cursorline cursorcolumn

" Keep undo history
silent !mkdir -p $HOME/.nvim-undo > /dev/null 2>&1
set undodir=$HOME/.nvim-undo
set undofile

" Solarized color scheme
set background=dark
let g:solarized_termtrans=1
let g:solarized_contrast="high"
let g:solarized_visibility="high"
colorscheme solarized

" Open new split panes to the right and bottom
set splitbelow
set splitright

" write directly to file, instead of atomic move. necessary for brunch/chokidar file watcher :-(
set nobackup
set nowritebackup

" Resize internal window scale when console resized
autocmd VimResized * :wincmd =

" Keep some space above/below cursor
set scrolloff=10

" Esc to leave terminal insert mode
tnoremap <ESC> <C-\><C-n>

" When jumping to path under cursor, open in existing window or window 1
"map <CR> :let mycurf=expand("<cfile>")<cr>1<C-w>w :execute("drop ".mycurf)<cr>
map <silent> <CR> :call CarefulCursorFile()<CR>
function! CarefulCursorFile()
  let pathstuff=matchlist(expand("<cWORD>"), "\\([a-zA-Z0-9/_.-]\\+\\)\\(:\\(\\d\\+\\)\\)\\?")
  if strlen(pathstuff[1]) > 0 && filereadable(pathstuff[1])
    call win_gotoid(win_getid(1))
    execute("drop ".pathstuff[1])
    if pathstuff[3]
      execute("normal! ".pathstuff[3]."G")
    endif
  endif
endfunction

" Switch to insert mode on entering terminal if cursor on the last line
au BufEnter * call InsertIfTerminalBottom()
function! InsertIfTerminalBottom()
  if &buftype == 'terminal'
    let curline = getcurpos()[1]
    let lastline = prevnonblank(line('$'))
    if curline >= lastline
      startinsert
    endif
  endif
endfunction

" fzf
" TODO Esc to quit FZF somehow
" map ; :GFiles<CR>
" map <leader>g :Ag<CR>

" CtrlP
map ; :CtrlP<CR>
map z :CtrlPMRU<CR>
let g:ctrlp_switch_buffer='t'
let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:25'
"let g:ctrlp_match_func = {'match': 'cpsm#CtrlPMatch'}
"let g:ctrlp_use_caching = 0
"let g:ctrlp_user_command = 'ag %s --nocolor -g ""'
let g:ctrlp_user_command = {
  \ 'types': {
    \ 1: ['.git', 'cd %s && git ls-files -co --exclude-standard'],
    \ 2: ['.hg', 'hg --cwd %s locate -I .'],
    \ },
  \ 'fallback': 'find %s -type f'
  \ }

" CPSM
let g:cpsm_query_inverting_delimiter = " "
let g:cpsm_match_empty_query = 0

" Mundo
nnoremap <leader>u :MundoToggle<CR>
let g:mundo_preview_bottom=1

" airline
set laststatus=2
let g:airline_theme="base16"
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
" unicode symbols
let g:airline_left_sep = '▶'
let g:airline_right_sep = '◀'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.whitespace = 'Ξ'
let g:airline#extensions#default#layout = [ ['a','b','c'], ['x','z','warning' ] ]
let g:airline#extensions#branch#displayed_head_limit = 12

" git gutter
let g:gitgutter_override_sign_column_highlight=0
highlight SignColumn ctermbg=black

 " easymotion
let g:EasyMotion_do_mapping = 0
let g:EasyMotion_smartcase = 1
let g:EasyMotion_keys='aoeuhtnsidpgyfc.r,bjkx;zv'
map s <Plug>(easymotion-s2)
nmap s <Plug>(easymotion-overwin-f2)

 " easymotion + incsearch
function! s:config_easyfuzzymotion(...) abort
  return extend(copy({
  \   'converters': [incsearch#config#fuzzyword#converter()],
  \   'modules': [incsearch#config#easymotion#module({'overwin': 1})],
  \   'keymap': {"\<CR>": '<Over>(easymotion)'},
  \   'is_expr': 0,
  \   'is_stay': 1
  \ }), get(a:, 1, {}))
endfunction
noremap <silent><expr> <leader>s incsearch#go(<SID>config_easyfuzzymotion())

" argwrap
nnoremap <silent> <leader>a :ArgWrap<CR>

" neoterm
map <C-t> :Ttoggle<CR>
tnoremap <C-t> <C-\><C-n>:Ttoggle<CR>
let g:neoterm_autoinsert = 1
let g:neoterm_default_mod = "botright"

" neomake
" TODO Can we report success, indicate which command ran?
nnoremap <silent> <leader>l :Neomake<CR> " l is for lint
" autocmd! BufWritePost,BufReadPost * Neomake
"let g:neomake_verbose = 3
let g:neomake_open_list = 2
"let g:neomake_error_sign = { 'text': '✖', 'texthl': 'ErrorMsg' }
"let g:neomake_warning_sign = { 'text': '⚠', 'texthl': 'ErrorMsg' }
"let g:neomake_info_sign = { 'text': 'ℹ', 'texthl': 'ErrorMsg' }
let g:neomake_ruby_rubocop_maker = {'exe': 'rubocop', 'args': ['--format', 'emacs', '--force-exclusion', '-c', './.rubocop.yml'], "cwd": "."}
let g:neomake_ruby_enabled_makers = ['rubocop']
" TODO Javascript results parsing seems broken?
let g:neomake_javascript_eslint_maker  = {
	\ 'exe': './node_modules/.bin/eslint',
	\ 'args': ['-f', 'compact', '-c', './.eslintrc.json'],
	\ "cwd": ".",
	\ 'errorformat': '%E%f: line %l\, col %c\, Error - %m,' .
	\   '%W%f: line %l\, col %c\, Warning - %m,%-G,%-G%*\d problems%#'
	\ }
let g:neomake_javascript_enabled_makers = ['eslint']

" neomake-autolint
let g:neomake_autolint_enabled = 1

" deoplete
let g:deoplete#enable_at_startup = 1
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"

" vim-test
" TODO get it to parse jest output correctly for quickfix
nnoremap <silent> <leader>tt :TestNearest<CR>
nnoremap <silent> <leader>tf :TestFile<CR>
nnoremap <silent> <leader>ta :TestSuite<CR>
nnoremap <silent> <leader>tl :TestLast<CR>
nnoremap <silent> <leader>tv :TestVisit<CR>
let test#strategy = "neoterm"

" NERDcommenter
let NERDSpaceDelims=1

" lightline
let g:lightline = {
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'readonly', 'relativepath', 'modified' ] ],
      \  'right': [ [ 'lineinfo' ], [ 'percent' ] ]
      \ },
      \ 'inactive': {
      \   'left': [ [ 'readonly', 'relativepath', 'modified' ] ],
      \  'right': [ [ 'lineinfo' ], [ 'percent' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'fugitive#head'
      \ },
\ }