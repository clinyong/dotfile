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

" close other buffers
" :BufOnly without an argument will unload all buffers but the current one.
Plugin 'vim-scripts/BufOnly.vim'

Plugin 'majutsushi/tagbar'
"tagbar{{
let g:tagbar_ctags_bin = "/usr/local/bin/ctags"
nnoremap <silent><C-r> :TagbarToggle<CR>

let g:tagbar_autoclose = 1
let g:tagbar_sort = 0
"}}

Plugin 'scrooloose/nerdtree'
 "NERDTree {{
 nnoremap <silent> <C-t> :exe 'NERDTreeTabsToggle'<CR> 
 let g:nerdtree_tabs_open_on_gui_startup=0
 "}}
 
Plugin 'jistr/vim-nerdtree-tabs'
"Plugin 'terryma/vim-multiple-cursors'
Plugin 'bling/vim-airline'
"airline{{
set laststatus=2
let g:airline_powerline_fonts=1
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme = "luna"
"}}

Plugin 'kien/ctrlp.vim'
"ctrlp{{
noremap <C-W><C-U> :CtrlPMRU<CR>
nnoremap <C-W>u :CtrlPMRU<CR>

" 用ag代替grep搜索
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor
  " Use ag in CtrlP for listing files.
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
  " Ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif

let g:ctrlp_custom_ignore = '\.git$\|\.hg$\|\.svn$\|.rvm$'
let g:ctrlp_working_path_mode=0
let g:ctrlp_match_window_bottom=1
let g:ctrlp_max_height=15
let g:ctrlp_match_window_reversed=0
let g:ctrlp_mruf_max=500
let g:ctrlp_follow_symlinks=1

Plugin 'rking/ag.vim'
"}}

"平滑滚动
Plugin 'yonchu/accelerated-smooth-scroll'

"}}

"lang{{

"php
Plugin 'vim-php/tagbar-phpctags.vim'
let g:tagbar_phpctags_bin='/usr/local/bin/phpCtags'
let g:tagbar_phpctags_memory_limit = '512M'
"php indent
Plugin '2072/PHP-Indenting-for-VIm'

"json
Plugin 'elzr/vim-json'
let g:vim_json_syntax_conceal = 0

"javascript {{
" Plugin 'jelera/vim-javascript-syntax'
" Plugin 'nathanaelkane/vim-indent-guides'
" Plugin 'Raimondi/delimitMate'

Plugin 'pangloss/vim-javascript'
Plugin 'mxw/vim-jsx'
let g:jsx_ext_required = 0

"js formatting
"Plugin 'maksimr/vim-jsbeautify'
"Plugin 'einars/js-beautify'
"map <leader>ff :call JsBeautify()<cr>
" }}

"golang
Plugin 'fatih/vim-go'
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

Plugin 'nvie/vim-flake8'
"nvie/vim-flake8 {{
"自动检查python语法
autocmd BufWritePost *.py call Flake8()
"}}

"}}


"code tools{{

"语法检查
Plugin 'scrooloose/syntastic'
"syntastic{{
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

" let g:syntastic_javascript_checkers = ['jshint']
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_html_tidy_ignore_errors=[" proprietary attribute \"ng-"]
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
"}}

"auto complete
Plugin 'ervandew/supertab'
"superTab{{
let g:SuperTabDefaultCompletionType = "<c-n>" "按tab键由上往下滚动
"}}

Plugin 'Valloric/YouCompleteMe'
"YouCompleteMe {{
"}}

Plugin 'tpope/vim-commentary'
"vim-commentary {{
autocmd FileType python,shell set commentstring=#\ %s " 设置Python注释字符
"}}

Plugin 'tpope/vim-surround'

" 代码段 {{
Plugin 'SirVer/ultisnips'

let g:UltiSnipsExpandTrigger="<C-e>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"
" }}

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

