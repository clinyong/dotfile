"vundle
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" " alternatively, pass a path where Vundle should install plugins
" "let path = '~/some/path/here'
" "call vundle#rc(path)
"
" " let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

"vim tools {{

Bundle 'majutsushi/tagbar'
"tagbar{{
let g:tagbar_ctags_bin = "/usr/local/Cellar/ctags/5.8/bin/ctags"
nnoremap <silent><C-r> :TagbarToggle<CR>

let g:tagbar_autoclose = 1
let g:tagbar_sort = 0
"}}

Bundle 'scrooloose/nerdtree'
 "NERDTree {{
 nnoremap <silent> <C-t> :exe 'NERDTreeTabsToggle'<CR> 
 let g:nerdtree_tabs_open_on_gui_startup=0
 "}}
 
Bundle 'jistr/vim-nerdtree-tabs'
"Bundle 'terryma/vim-multiple-cursors'
Bundle 'bling/vim-airline'
"airline{{
set laststatus=2
let g:airline_powerline_fonts=1
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme = "luna"
"}}

Bundle 'kien/ctrlp.vim'
"ctrlp{{
noremap <C-W><C-U> :CtrlPMRU<CR>
nnoremap <C-W>u :CtrlPMRU<CR>

let g:ctrlp_custom_ignore = '\.git$\|\.hg$\|\.svn$\|.rvm$'
let g:ctrlp_working_path_mode=0
let g:ctrlp_match_window_bottom=1
let g:ctrlp_max_height=15
let g:ctrlp_match_window_reversed=0
let g:ctrlp_mruf_max=500
let g:ctrlp_follow_symlinks=1
"}}

"平滑滚动
Bundle 'yonchu/accelerated-smooth-scroll'

"}}

"lang{{

"php
Bundle 'vim-php/tagbar-phpctags.vim'
let g:tagbar_phpctags_bin='/usr/local/bin/phpCtags'
let g:tagbar_phpctags_memory_limit = '512M'
"php indent
Bundle '2072/PHP-Indenting-for-VIm'

"json
Bundle 'elzr/vim-json'
let g:vim_json_syntax_conceal = 0

"js
Bundle 'jelera/vim-javascript-syntax'
Bundle 'marijnh/tern_for_vim'

"js formatting
"Bundle 'maksimr/vim-jsbeautify'
"Bundle 'einars/js-beautify'
"map <leader>ff :call JsBeautify()<cr>

"golang
Bundle 'fatih/vim-go'
"vim-golang{{
let g:go_disable_autoinstall = 0 "关闭自动安装依赖包
let g:go_fmt_autosave = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1

"golang for tagbar
let g:tagbar_type_go = {
    \ 'ctagstype' : 'go',
    \ 'kinds'     : [
        \ 'p:package',
        \ 'i:imports:1',
        \ 'c:constants',
        \ 'v:variables',
        \ 't:types',
        \ 'n:interfaces',
        \ 'w:fields',
        \ 'e:embedded',
        \ 'm:methods',
        \ 'r:constructor',
        \ 'f:functions'
    \ ],
    \ 'sro' : '.',
    \ 'kind2scope' : {
        \ 't' : 'ctype',
        \ 'n' : 'ntype'
    \ },
    \ 'scope2kind' : {
        \ 'ctype' : 't',
        \ 'ntype' : 'n'
    \ },
    \ 'ctagsbin'  : 'gotags',
    \ 'ctagsargs' : '-sort -silent'
\ }

"}}

"python

Bundle 'nvie/vim-flake8'
"nvie/vim-flake8 {{
"自动检查python语法
autocmd BufWritePost *.py call Flake8()
"}}

"}}


"code tools{{

"语法检查
Bundle 'scrooloose/syntastic'
"syntastic{{
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
"}}

"auto complete
Bundle 'ervandew/supertab'
"superTab{{
let g:SuperTabDefaultCompletionType = "<c-n>" "按tab键由上往下滚动
"}}

Bundle 'Valloric/YouCompleteMe'
"YouCompleteMe {{
"}}

" All of your Bundles must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :BundleList       - lists configured plugins
" :BundleInstall    - installs plugins; append `!` to update or just :BundleUpdate
" :BundleSearch foo - searches for foo; append `!` to refresh local cache
" :BundleClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Bundle stuff after this line

