" マウスを使えるようにする
if has("mouse")
  set mouse=a
end

" シンタックスハイライトを有効化
syntax on

" エンコーディング
set encoding=utf8

setlocal textwidth=80
set incsearch
set ignorecase
set ruler
set wildmenu
set commentstring=\ #\ %s
set foldlevel=0

" 検索マッチテキストをハイライト
set hlsearch

" 検索文字に大文字がある場合は大文字小文字を区別
set smartcase

" Swap/Backupファイルを無効化
set nowritebackup
set nobackup
set noswapfile

" read/write a .viminfo file, don't store more than
set viminfo=!,'50,<1000,s100,\"50

" keep 100 lines of command line history
set history=100

set t_Sf=e[3%dm                     " xterm-256color
set t_Sb=e[4%dm                     " xterm-256color
set expandtab                       " change tab into space
set tabstop=4                       " tab width
set softtabstop=0                   " tab width
set shiftwidth=4                    " tab width
set shiftround                      " round indent
set modelines=0                     " line num in :set
set number                          " show line num
set autoindent                      " auto indent
set clipboard+=unnamed              " clipboard <=> yank
set list                            " highlight space/tab at the end of line
set listchars=tab:^\ ,trail:~       " highlight space/tab at the end of line
set visualbell t_vb=                " kill beep flash
set t_vb=                           " kill beep sound
set novisualbell                    " ベルの削除
set infercase                       " 補完時に大文字小文字を区別しない
set virtualedit=all                 " カーソルを文字が存在しない部分でも動けるようにする
set hidden                          " バッファを閉じる代わりに隠す（Undo履歴を残すために）
set switchbuf=useopen               " 新しく開く代わりに既に開いてあるバッファを開く
set showmatch                       " 対応する括弧などをハイライト表示
set matchtime=3                     " 対応括弧のハイライト表示を３秒にする
set wrap                            " 長いテキストの折り返し

" ESCを２回押すことでハイライトを消す
nnoremap <Esc><Esc> :nohlsearch<CR>

" 対応括弧に'<'と'>'のペアを追加
set matchpairs& matchpairs+=<:>

" バックスペースで何でも消せるようにする
set backspace=indent,eol,start

" クリップボードをデフォルトのレジスタとして指定。後にYankRingを使うので
" 'unnamedplus'が存在しているかどうか
if has('unnamedplus')
    " set clipboard& clipboard+=unnamedplus " 2013-07-03 14:30 unnamed 追加
        set clipboard& clipboard+=unnamedplus,unnamed 
else
    " set clipboard& clipboard+=unnamed,autoselect 2013-06-24 10:00 autoselect 削除
    set clipboard& clipboard+=unnamed
endif


" バックスラッシュらクエスチョンを状況に合わせ自動的にエスケープ
cnoremap <expr> / getcmdtype() == '/' ? '\/' : '/'
cnoremap <expr> ? getcmdtype() == '?' ? '\?' : '?'


" see :https://qiita.com/wadako111/items/755e753677dd72d8036d
" Anywhere SID.
function! s:SID_PREFIX()
  return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID_PREFIX$')
endfunction

" Set tabline.
function! s:my_tabline()  "{{{
  let s = ''
  for i in range(1, tabpagenr('$'))
    let bufnrs = tabpagebuflist(i)
    let bufnr = bufnrs[tabpagewinnr(i) - 1]  " first window, first appears
    let no = i  " display 0-origin tabpagenr.
    let mod = getbufvar(bufnr, '&modified') ? '!' : ' '
    let title = fnamemodify(bufname(bufnr), ':t')
    let title = '[' . title . ']'
    let s .= '%'.i.'T'
    let s .= '%#' . (i == tabpagenr() ? 'TabLineSel' : 'TabLine') . '#'
    let s .= no . ':' . title
    let s .= mod
    let s .= '%#TabLineFill# '
  endfor
  let s .= '%#TabLineFill#%T%=%#TabLine#'
  return s
endfunction "}}}
let &tabline = '%!'. s:SID_PREFIX() . 'my_tabline()'
set showtabline=2 " 常にタブラインを表示

" The prefix key.
nnoremap    [Tag]   <Nop>
nmap    t [Tag]
" Tab jump
for n in range(1, 9)
  execute 'nnoremap <silent> [Tag]'.n  ':<C-u>tabnext'.n.'<CR>'
endfor
" t1 で1番左のタブ、t2 で1番左から2番目のタブにジャンプ

map <silent> [Tag]c :tablast <bar> tabnew<CR>
" tc 新しいタブを一番右に作る
map <silent> [Tag]x :tabclose<CR>
" tx タブを閉じる
map <silent> [Tag]n :tabnext<CR>
" tn 次のタブ
map <silent> [Tag]p :tabprevious<CR>
" tp 前のタブ

