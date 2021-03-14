" Interface
set confirm                " Raise a dialog when an operation has to be confirmed
set splitbelow             " Open splitpanes below
set splitright             " Open splitpanes to the right
set cursorline             " Highlight current line
set noshowmode             " Don't show the current mode
set updatetime=100         " Faster CursorHold
set signcolumn=yes         " Always show the signcolumn
set number                 " Display line numbers
set relativenumber         " Show the line number relative to the line with the cursor
set nohlsearch             " Stop the highlighting for the 'hlsearch'
set nowrap                 " Don't wrap long lines
set colorcolumn=80         " Set the colored vertical column
set cmdheight=2            " Set the command-line height to 2
set showbreak=↪\           " Show a symbol at the start of wrapped lines
set listchars=tab:→\ ,nbsp:␣,trail:•,eol:↲,precedes:«,extends:»
set list

" Toggle highlighting current line only in active splits
augroup toggle_current_line_hl
    autocmd!
    autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline
    autocmd WinLeave *                      setlocal nocursorline
augroup end

" Features
set mouse=a                " Enable mouse for all modes
set modeline               " Set filetype specific options via modelines
set undofile               " Enable persistent undo
set nobackup               " Disable backups
set nowritebackup          " Disable backups
set noswapfile             " Disable swapfiles
set ffs=unix,mac,dos       " Use Unix as the standard file format
set magic                  " Regex and search options
set foldmethod=syntax      " Syntax highlighting items specify folds
set foldlevelstart=99      " Always start editing with no folds closed

" Filetypes
filetype plugin indent on  " Enable file type detection and plugin loading

" Wrap lines to 72 characters in git commit messages and use 2 spaces for tab
augroup gitcommit_filetype_settings
    autocmd!
    autocmd FileType gitcommit setlocal spell textwidth=72 shiftwidth=2 tabstop=2 colorcolumn=+1 colorcolumn+=51
augroup end

" Editor
set expandtab              " Use the appropriate number of spaces to insert a <Tab>
set autoindent             " Copy indent from current line when starting a new line
set smarttab               " Makes tabbing smarter
set smartindent            " Makes indentation smarter
set tabstop=4              " Number of spaces in tab when displaying a file
set softtabstop=4          " Number of spaces in tab when editing a file
set shiftwidth=4           " Number of spaces to use for autoindent
set nojoinspaces           " Insert only one space with a join command
set shortmess+=c           " Don't pass messages to |ins-completion-menu|
set completeopt+=menuone   " Don't select the first completion item; show even if there's only one match

" Global
let g:python3_host_prog = '/usr/bin/python3'
