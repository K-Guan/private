" must be first, changes behaviour of other settings
set nocompatible

" 256 colors
set t_Co=256

" sane text files
set fileformat=unix
set encoding=utf-8

" sane tabs
set tabstop=4
set shiftwidth=4
set softtabstop=4

" convert all typed tabs to spaces
set expandtab

" set the background color
set background=dark

" syntax highlighting
syntax on 

" set color scheme
color molokai

let g:rehash256 = 1
let g:molokai_original = 1

" disable <Leader> timeout
set notimeout 
set ttimeout

" set ignorecase when use <C-N>
set ignorecase
set infercase

" allow backgrounding buffers without writing them
" and remember marks/undo for backgrounded buffers
set hidden

" apply operations to all of selection including last char                                                                          
set selection=inclusive

" for regular expressions turn magic on
set magic

" keep more context when scrolling off the end of a buffer
set scrolloff=3

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" no line wrapping
set nowrap

" line numbers
set number

" when joining lines, don't insert two spaces after punctuation
set nojoinspaces

" make searches case-sensitive only if they contain upper-case characters
set ignorecase
set smartcase

" show search matches as the search pattern is typed
set incsearch

" search-next wraps back to start of file
set wrapscan

" set the indent
set smartindent

" make tab completion for files/buffers act like bash
set wildmenu

" display cursor co-ords at all times
set ruler
set cursorline

" display number of selected chars, lines, or size of blocks.
set showcmd

" do not auto add space when merge Chinese
set formatoptions+=B

" enables filetype specific plugins
filetype indent plugin on

" places to look for tags files: set tags=./tags,tags

" recursively search file's parent dirs for tags file
" set tags+=./tags;/
" recursively search cwd's parent dirs for tags file
set tags+=tags;/

" set the status line always show
set laststatus=2

" map the some keys
imap <C-l> <C-x><C-l>
imap <C-f> <C-x><C-f>


"" =====================

" use the pathogen
execute pathogen#infect()

" set the vim multi cursor
let g:multi_cursor_start_key = 'g<C-n>'
let g:multi_cursor_start_word_key = '<C-n>'
let g:multi_cursor_exit_from_insert_mode = 0
let g:multi_cursor_exit_from_visual_mode = 0

" set the airline
let g:airline_powerline_fonts = 1
let g:airline_theme='serene'

" set the rainbow_parentheses
let g:rbpt_colorpairs = [
            \ ['brown',       'RoyalBlue3'],
            \ ['Darkblue',    'SeaGreen3'],
            \ ['darkgray',    'DarkOrchid3'],
            \ ['darkgreen',   'firebrick3'],
            \ ['darkcyan',    'RoyalBlue3'],
            \ ['darkred',     'SeaGreen3'],
            \ ['darkmagenta', 'DarkOrchid3'],
            \ ['brown',       'firebrick3'],
            \ ['gray',        'RoyalBlue3'],
            \ ['darkmagenta', 'DarkOrchid3'],
            \ ['Darkblue',    'firebrick3'],
            \ ['darkgreen',   'RoyalBlue3'],
            \ ['darkcyan',    'SeaGreen3'],
            \ ['darkred',     'DarkOrchid3'],
            \ ['red',         'firebrick3'],
            \ ]

let g:rbpt_max = 16
let g:rbpt_loadcmd_toggle = 0
au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces

" set the easymotion
let g:EasyMotion_smartcase = 1
let g:EasyMotion_startofline = 0

map  / <Plug>(easymotion-sn)
omap / <Plug>(easymotion-tn)

" These `n` & `N` mappings are options. You do not have to map `n` & `N` to EasyMotion.
" Without these mappings, `n` & `N` works fine. (These mappings just provide
" different highlight method and have some other features )
map  n <Plug>(easymotion-next)
map  N <Plug>(easymotion-prev)

" set pymode
let g:pymode_rope = 0
let g:pymode_python = 'python3'
let g:pymode_breakpoint_cmd = "__import__('bpdb').set_trace()"

" ##### auto fcitx  ###########
let g:input_toggle = 1
function! Fcitx2en()
    let s:input_status = system("fcitx-remote")
    if s:input_status == 2
        let g:input_toggle = 1
        let l:a = system("fcitx-remote -c")
    endif
endfunction

set ttimeoutlen=150

" exit the insert mode
autocmd InsertLeave * call Fcitx2en()
" ##### auto fcitx end ######
