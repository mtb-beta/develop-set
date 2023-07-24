if has("mouse")
  set mouse=a
end

syntax on
set encoding=utf8
set incsearch
set ignorecase
set ruler
set wildmenu
set commentstring=\ #\ %s
set foldlevel=0
set hlsearch
set smartcase
set nowritebackup
set nobackup
set noswapfile
set viminfo=!,'50,<1000,s100,\"50
set history=100
set t_Sf=e[3%dm                     " xterm-256color
set t_Sb=e[4%dm                     " xterm-256color
set expandtab                       " change tab into space
set tabstop=4                       " tab width
set softtabstop=4                   " tab width
set shiftwidth=4                    " tab width
set shiftround                      " round indent
set modelines=0                     " line num in :set
set nomodeline
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
set backspace=indent,eol,start
set foldlevel=0

" ESCを２回押すことでハイライトを消す
nnoremap <Esc><Esc> :nohlsearch<CR>

" 対応括弧に'<'と'>'のペアを追加
set matchpairs& matchpairs+=<:>

" クリップボードをデフォルトのレジスタとして指定。後にYankRingを使うので
if has('unnamedplus')
    set clipboard& clipboard+=unnamedplus,unnamed 
else
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
nnoremap [Tag]   <Nop>
nmap t [Tag]
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

" ショートカット
ca tn tabnew

augroup fileTypeIndent
    autocmd!
    autocmd BufNewFile,BufRead *.py setlocal tabstop=4 softtabstop=4 shiftwidth=4
    autocmd BufNewFile,BufRead *.html setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.css setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.js setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.jsx setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.tsx setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.ts setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.vue setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.prisma setlocal tabstop=2 softtabstop=2 shiftwidth=2
augroup END

" vim-plug Automatic installation
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
    silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" vim-plug
if has('vim')
    " Vimの場合
    call plug#begin('~/.vim/plugged')
else
    " Neovimの場合
    call plug#begin('~/.local/share/nvim/plugged')
endif

" NeoVimではcoc.nvim, Vimではvim-lsp
if has('vim')
    Plug 'prabirshrestha/vim-lsp'
    Plug 'prabirshrestha/async.vim'
else
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    Plug 'github/copilot.vim'
endif

Plug 'scrooloose/syntastic'
Plug 'psf/black', { 'branch': 'stable' }
Plug 'mattn/emmet-vim'
Plug 'tpope/vim-pathogen'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'hashivim/vim-terraform'

" for TypeScript
Plug 'Shougo/vimproc.vim', {'do' : 'make'}
Plug 'Quramy/tsuquyomi'
Plug 'prettier/vim-prettier', { 'do': 'npm install', 'for': ['javascript', 'typescript', 'typescriptreact', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'yaml', 'html'] }

" for Prisma
Plug 'pantharshit00/vim-prisma'



call plug#end()

" 言語用Serverの設定
" vimの場合は、vim-lsp
if has('vim')
    " 参考にした https://kashewnuts.github.io/2019/01/28/move_from_jedivim_to_vimlsp.html
    augroup MyLsp
    autocmd!
    " pip install python-language-server
    if executable('pyls')
        " Python用の設定を記載
        " workspace_configで以下の設定を記載
        " - pycodestyleの設定はALEと重複するので無効にする
        " - jediの定義ジャンプで一部無効になっている設定を有効化
        autocmd User lsp_setup call lsp#register_server({
            \ 'name': 'pyls',
            \ 'cmd': { server_info -> ['pyls'] },
            \ 'whitelist': ['python'],
            \ 'workspace_config': {'pyls': {'plugins': {
            \   'pycodestyle': {'enabled': v:false},
            \   'jedi_definition': {'follow_imports': v:true, 'follow_builtin_imports': v:true},}}}
            \})
        autocmd FileType python call s:configure_lsp()
    endif
    augroup END
    " 言語ごとにServerが実行されたらする設定を関数化
    function! s:configure_lsp() abort
    setlocal omnifunc=lsp#complete   " オムニ補完を有効化
    " LSP用にマッピング
    nnoremap <buffer> <C-]> :<C-u>LspDefinition<CR>
    nnoremap <buffer> gd :<C-u>LspDefinition<CR>
    nnoremap <buffer> gD :<C-u>LspReferences<CR>
    nnoremap <buffer> gs :<C-u>LspDocumentSymbol<CR>
    nnoremap <buffer> gS :<C-u>LspWorkspaceSymbol<CR>
    nnoremap <buffer> gQ :<C-u>LspDocumentFormat<CR>
    vnoremap <buffer> gQ :LspDocumentRangeFormat<CR>
    nnoremap <buffer> K :<C-u>LspHover<CR>
    nnoremap <buffer> <F1> :<C-u>LspImplementation<CR>
    nnoremap <buffer> <F2> :<C-u>LspRename<CR>
    endfunction
    let g:lsp_diagnostics_enabled = 0  " 警告やエラーの表示はALEに任せるのでOFFにする
else
    " Configure coc.nvim plugin
    let g:coc_global_extensions = ['coc-tsserver', 'coc-python', 'coc-html', 'coc-json']

    " Configure mappings
    nmap <silent> gd <Plug>(coc-definition)
    nmap <silent> gy <Plug>(coc-type-definition)
    nmap <silent> gi <Plug>(coc-implementation)
    nmap <silent> gr <Plug>(coc-references)
    nmap <silent> K  <Plug>(coc-hover)

    " Use <Tab> and <S-Tab> to navigate through popup menu
    inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
    inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
endif



" synstastic用の設定
let flake8_repos = []
for repo in flake8_repos
    execute 'autocmd BufRead,BufNewFile ' . repo . '* let g:syntastic_python_checkers = ["flake8"]'
endfor
" synstastic用の設定
let pflake8_repos = []
for repo in flake8_repos
    execute 'autocmd BufRead,BufNewFile ' . repo . '* let g:syntastic_python_checkers = ["pflake8"]'
endfor

let g:syntastic_html_checkers = [] " htmlのチェッカーを無効化する

" CoffeeScriptのシンタックス
execute pathogen#infect()

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" Python/black用の設定
let g:black_linelength = 99
autocmd BufWritePre *.py execute ':Black'

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

" vim-prettier
autocmd BufWritePre *.ts execute ':Prettier'
autocmd BufWritePre *.tsx execute ':Prettier'
autocmd BufWritePre *.js execute ':Prettier'

" vim-emmetの設定
let g:user_emmet_install_global = 0
autocmd FileType html,css,javascript,javascript.jsx EmmetInstall

" terraformによる保存時の自動フォーマット
let g:terraform_fmt_on_save = 1
