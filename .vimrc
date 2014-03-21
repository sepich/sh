syntax on
map q :qa<CR>

"set mouse=a
set background=dark
set nowrap
set ruler
filetype indent on

set showcmd             " shows the command in the status line
set ch=2                " make command line 2 lines high
set ls=2                " status line always on

set statusline %<%f\ %h%m%r%=%{getcwd()}\ \ \ %-14.(%l,%c%V%)\ %P
