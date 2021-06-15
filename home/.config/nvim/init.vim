call plug#begin('~/.local/share/nvim/plugged')
Plug 'iCyMind/NeoSolarized'
Plug 'kien/ctrlp.vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'simnalamburt/vim-mundo'
Plug 'scrooloose/nerdcommenter'
Plug 'tpope/tpope-vim-abolish'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'haya14busa/incsearch.vim'
Plug 'FooSoft/vim-argwrap'
Plug 'kassio/neoterm'
Plug 'Shougo/deoplete.nvim'
Plug 'janko-m/vim-test'
Plug 'maxbrunsfeld/vim-yankstack'
Plug 'machakann/vim-highlightedyank'
Plug 'vim-scripts/ruby-matchit'

Plug 'mxw/vim-jsx'
Plug 'isRuslan/vim-es6'
Plug 'elixir-editors/vim-elixir'
Plug 'rust-lang/rust.vim'
Plug 'vmchale/just-vim'
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'
Plug 'hashivim/vim-terraform'
call plug#end()

" Detect OS
if !exists("g:os")
  if has("win64") || has("win32") || has("win16")
    let g:os = "Windows"
  else
    let g:os = substitute(system('uname'), '\n', '', '')
  endif
endif


let mapleader=","

set showcmd      " Show (partial) command in status line.
set showmatch    " Show matching brackets.
set ignorecase   " Do case insensitive matching
set smartcase    " Do smart case matching
set incsearch    " Incremental search
set autowrite    " Automatically save before commands like :next and :make
set autoread     " Automatically reload files on checktime
set hidden       " Hide buffers when they are abandoned
set mouse=a      " Enable mouse usage (all modes)
set ruler        " Always show current position
set autoindent   " Automatically copy indent to new lines
set nohlsearch   " Highlight search results
set shiftround   " Don't allow uneven indentation
set nolazyredraw " Better cursor movement
set inccommand=nosplit " Preview substitution

" True color in terminal
set termguicolors

" Shortcuts to work with OS clipboard
if g:os == "Darwin"
  map <leader>xc :w !pbcopy<CR><CR>
  map <leader>xp :r!pbpaste<CR>
else
  map <leader>xc :w !xsel --clipboard --input<CR><CR>
  map <leader>xp :r!xsel --clipboard --output<CR>
endif

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
autocmd Filetype typescript setlocal comments=s1:/*,mb:*,ex:*/,://.,://
autocmd Filetype typescript.tsx setlocal comments=s1:/*,mb:*,ex:*/,://.,://

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
set background=light
"let g:neosolarized_contrast="high"
let g:neosolarized_visibility="high"
colorscheme NeoSolarized

" Use terminal native background
highlight Normal ctermbg=none guibg=none
highlight NonText ctermbg=none guibg=none

" TODO Pick a terminal color, and use iterm2-random-bg to set that color
" to a little darker than the random bg color
highlight CursorLine ctermbg=none guibg=none
highlight CursorLineNr ctermbg=none guibg=none
highlight CursorColumn ctermbg=none guibg=none
highlight ColorColumn ctermbg=none guibg=none
highlight SignColumn ctermbg=none guibg=none
highlight LineNr ctermbg=none guibg=none

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

" When pasting in visual mode, don't send replaced text to the default register
xnoremap p "_dP

" Don't want to run another vim inside vim neoterm
let $EDITOR = 'nano'

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

" Remember last cursor position when opening a file again
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" Use dumb autoindent on TSX and ruby
autocmd FileType typescript.tsx setlocal indentexpr=
autocmd FileType rb setlocal indentexpr=

" Triger `autoread` when files changes on disk
" https://unix.stackexchange.com/questions/149209/refresh-changed-content-of-file-opened-in-vim/383044#383044
" https://vi.stackexchange.com/questions/13692/prevent-focusgained-autocmd-running-in-command-line-editing-mode
autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() != 'c' | checktime | endif
" Notification after file change
" https://vi.stackexchange.com/questions/13091/autocmd-event-for-autoread
autocmd FileChangedShellPost *
  \ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None

" editorconfig
let g:EditorConfig_exclude_patterns = ['fugitive://.*']

" yankstack
let g:yankstack_map_keys = 0
call yankstack#setup()
nmap <leader>p <Plug>yankstack_substitute_older_paste
nmap <leader>P <Plug>yankstack_substitute_newer_paste

" CtrlP
map ; :CtrlP<CR>
map z :CtrlPMRU<CR>
let g:ctrlp_switch_buffer='t'
let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:25'
let g:ctrlp_user_command = {
  \ 'types': {
    \ 1: ['.git', 'cd %s && git ls-files -co --exclude-standard'],
    \ 2: ['.hg', 'hg --cwd %s locate -I .'],
    \ },
  \ 'fallback': 'ag %s -l --nocolor -g ""'
  \ }

" Mundo
nnoremap <leader>u :MundoToggle<CR>
let g:mundo_preview_bottom=1

" git gutter
let g:gitgutter_override_sign_column_highlight=1
let g:gitgutter_realtime=0
let g:gitgutter_eager=0
highlight SignColumn ctermbg=black

map / <Plug>(incsearch-forward)
map ? <Plug>(incsearch-backward)

" argwrap
nnoremap <silent> <leader>a :ArgWrap<CR>

" neoterm
map <C-t> :Ttoggle<CR>
tnoremap <C-t> <C-\><C-n>:Ttoggle<CR>
tnoremap <ESC> <C-\><C-n>
let g:neoterm_autoinsert = 1
let g:neoterm_default_mod = "botright"

" deoplete
let g:deoplete#enable_at_startup = 1
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"

" vim-test
nnoremap <silent> <leader>tt :TestNearest<CR>
nnoremap <silent> <leader>tf :TestFile<CR>
nnoremap <silent> <leader>tl :TestLast<CR>
nnoremap <silent> <leader>tv :TestVisit<CR>
let test#strategy = "neoterm"

" NERDcommenter
let NERDSpaceDelims=1
