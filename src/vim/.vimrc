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
