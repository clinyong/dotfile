"Create by LeoChan
"2014/3/10

"==========================================
" General Settings 基础设置
"==========================================
"

"import vundle setting
source ~/.vim/vundles.vim

"不兼容vi
set nocompatible

"文件修改之后自动载入
set autoread

"在insert模式下用退格键删除
set bs=2 

"历史记录数
set history=200 

"去掉输入错误的提示声音
set noerrorbells         " don't beep

set completeopt-=preview "自动补全时不出现顶部的preview窗口

" leaving modified buffer
set hidden

"use the same clipboard with system
"set clipboard=unnamedplus

"==========================================
" Display Settings 展示/排版等界面格式设置
"==========================================
"

"主题
set t_Co=256
" colorscheme zenburn
let g:rehash256 = 1

"display line number
set nu 

"为光标所在行加下划线
set cursorline 

" Always show the status line - use 2 lines for the status bar
set laststatus=2

" 括号匹配
set showmatch
set matchtime=1             " 匹配高亮时间（单位是十分之一秒）
runtime macros/matchit.vim  "启用matchit插件，增加匹配

"search setting
set ignorecase "检索时忽略大小写
set incsearch "激活增量查找功能，实现预览搜索
set hls "激活搜索高亮
set smartcase "有一个或以上大写字母时仍大小写敏感

"缩进设置
set autoindent "自动缩进
set smartindent "智能缩进
set cindent "c风格缩进
set indentkeys-=<:> " 按:不缩进

set expandtab " 将tab转为空格
set tabstop=4 "设置Tab键的宽度 [等同的空格个数]
set shiftwidth=4 "每一次缩进对应的空格数
set softtabstop=4 "按退格键时可以一次删掉 4 个空格

autocmd Filetype javascript setlocal ts=2 sts=2 sw=2

syntax enable "syntax hightlight
set guifont=Meslo\ LG\ S\ Regular\ for\ Powerline:h20

"折叠设置
set nofoldenable

" 5 lines above/below cursor when scrolling
set scrolloff=5

" Open new split panes to right and bottom
set splitbelow
set splitright

"自动检测文件类型并加载相应设置
filetype plugin indent on
autocmd FileType python setlocal et sta sw=4 sts=4

"==========================================
" FileEncode Settings 文件编码,格式
"==========================================
"

" 设置新文件的编码为 UTF-8
set encoding=utf-8

" Use Unix as the standard file type
set ffs=unix,dos,mac

" 合并两行中文时，不在中间加空格：
set formatoptions+=B

"encoding for Chinese format
set fileencodings=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936
set termencoding=utf-8
set encoding=utf-8

"==========================================
" HotKey Settings  自定义快捷键设置
"==========================================
"

" 防止在终端Vim输入F1等键出现意外情况
map <Esc>OP <F1>
map <Esc>OQ <F2>
map <Esc>OR <F3>
map <Esc>OS <F4>
map <Esc>[16~ <F5>
map <Esc>[17~ <F6>
map <Esc>[18~ <F7>
map <Esc>[19~ <F8>
map <Esc>[20~ <F9>
map <Esc>[21~ <F10>
map <Esc>[23~ <F11>
map <Esc>[24~ <F12>

"上排F功能键
" F1 废弃这个键,防止调出系统帮助
" F2 行号开关，用于鼠标复制代码用
" F3 粘贴模式paste_mode开关,用于有格式的代码粘贴
" F4 语法开关，关闭语法可以加快大文件的展示

"禁用F1键，防止误按
noremap <F1> <Esc>"

""为方便复制，用<F2>开启/关闭行号显示:
function! HideNumber()
  if(&relativenumber == &number)
    set relativenumber! number!
  elseif(&number)
    set number!
  else
    set relativenumber!
  endif
  set number?
endfunc
nnoremap <F2> :call HideNumber()<CR>

"set paste
set pastetoggle=<F3>            "    when in insert mode, press <F3> to go to
                                "    paste mode, where you can paste mass data
                                "    that won't be autoindented

" disbale paste mode when leaving insert mode
au InsertLeave * set nopaste

nnoremap <F4> :exec exists('syntax_on') ? 'syn off' : 'syn on'<CR>

" Go to home and end using capitalized directions
noremap H ^
noremap L $

" ctags 跳转到定义
nnoremap <C-]> g<C-]> "当跳转出现多个匹配可以用列表中选择
nnoremap <C-[> <C-T> "Jump back

" 绑定<Leader>键
let mapleader = ","

"conf for tabs, 为标签页进行的配置，通过ctrl h/l切换标签等
"nnoremap <C-l> gt
"nnoremap <C-h> gT

"禁用光标键
noremap <Up>  <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>

"Treat long lines as break lines (useful when moving around in them)
"se swap之后，同物理行上线直接跳
nnoremap k gk
nnoremap gk k
nnoremap j gj
nnoremap gj j

"Smart way to move between windows 分屏窗口移动
noremap <C-j> <C-W>j
noremap <C-k> <C-W>k
noremap <C-h> <C-W>h
noremap <C-l> <C-W>l

"Map ; to : and save a million keystrokes
" ex mode commands made easy 用于快速进入命令行
"nnoremap ; :
"nnoremap : ;

" 命令行模式增强，ctrl - a到行首， -e 到行尾
cnoremap <C-j> <t_kd>
cnoremap <C-k> <t_ku>
cnoremap <C-a> <Home>
cnoremap <C-e> <End>

"Keep search pattern at the center of the screen."
nnoremap <silent> n nzz
nnoremap <silent> N Nzz
nnoremap <silent> * *zz
nnoremap <silent> # #zz
nnoremap <silent> g* g*zz

" 去掉搜索高亮
nnoremap <silent><leader><CR> :nohls<CR>

" 用Tab键切换buf
nnoremap <S-Tab> :bp<CR>
nnoremap <Tab> :bn<CR>

" 用leader-c-w关闭buffer
nnoremap <leader><c-w> :bd<CR>
" 用leader-c-w关闭buffer
nnoremap <leader><c-o> :BufOnly<CR>

" y$ -> Y Make Y behave like other capitals
nnoremap Y y$

" select all
nnoremap <C-a> ggVG

" remap U to <C-r> for easier redo
nnoremap U <C-r>

"Basically you press * or # to search for the current selection !! Really
"useful
vnoremap <silent> * :call VisualSearch('f')<CR>
vnoremap <silent> # :call VisualSearch('b')<CR>

"Reselect visual block after indent/outdent.调整缩进后自动选中，方便再次操作
vnoremap < <gv
vnoremap > >gv

" select block
nnoremap <leader>v V`}

" 快速编辑vimrc
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
" 快速生效vimrc
nnoremap <leader>sv :source $MYVIMRC<cr>

" js/html/css formatter

"==========================================
" Abbreviations Settings  自定义缩写
"==========================================
"

autocmd FileType python     :iabbrev <buffer> iff if:<left>
autocmd FileType javascript :iabbrev <buffer> iff if ()<left>
