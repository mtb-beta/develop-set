" =============================================================================
" 1. 基本設定
" =============================================================================
if has("mouse")
  set mouse=a
endif

syntax on
set encoding=utf8
set incsearch
set ignorecase
set smartcase
set ruler
set wildmenu
set commentstring=\ #\ %s
set foldlevel=0
set hlsearch
set nowritebackup
set nobackup
set noswapfile
set viminfo=!,'50,<1000,s100,\"50
set history=100
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set shiftround
set nomodeline
set number
set autoindent
set list
set listchars=tab:^\ ,trail:~
set visualbell t_vb=
set t_vb=
set novisualbell
set infercase
set virtualedit=all
set hidden
set switchbuf=useopen
set showmatch
set matchtime=3
set matchpairs& matchpairs+=<:>
set wrap
set backspace=indent,eol,start
set fileformat=unix
set fileformats=unix,dos,mac

" クリップボードをデフォルトのレジスタとして指定
if has('unnamedplus')
    set clipboard& clipboard+=unnamedplus,unnamed
else
    set clipboard& clipboard+=unnamed
endif

" =============================================================================
" 2. キーマップ
" =============================================================================
" ESCを２回押すことでハイライトを消す
nnoremap <Esc><Esc> :nohlsearch<CR>

" バックスラッシュやクエスチョンを状況に合わせ自動的にエスケープ
cnoremap <expr> / getcmdtype() == '/' ? '\/' : '/'
cnoremap <expr> ? getcmdtype() == '?' ? '\?' : '?'

" =============================================================================
" 3. タブUI
" =============================================================================
" see: https://qiita.com/wadako111/items/755e753677dd72d8036d
function! s:SID_PREFIX()
  return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID_PREFIX$')
endfunction

function! s:my_tabline()  "{{{
  let s = ''
  for i in range(1, tabpagenr('$'))
    let bufnrs = tabpagebuflist(i)
    let bufnr = bufnrs[tabpagewinnr(i) - 1]
    let no = i
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
set showtabline=2

nnoremap [Tag]   <Nop>
nmap t [Tag]
for n in range(1, 9)
  execute 'nnoremap <silent> [Tag]'.n  ':<C-u>tabnext'.n.'<CR>'
endfor

map <silent> [Tag]c :tablast <bar> tabnew<CR>
map <silent> [Tag]x :tabclose<CR>
map <silent> [Tag]n :tabnext<CR>
map <silent> [Tag]p :tabprevious<CR>
ca tn tabnew

" =============================================================================
" 4. ファイルタイプ別設定
" =============================================================================
augroup fileTypeIndent
    autocmd!
    autocmd BufNewFile,BufRead *.py setlocal tabstop=4 softtabstop=4 shiftwidth=4
    autocmd BufNewFile,BufRead *.html,*.css,*.js,*.jsx,*.ts,*.tsx,*.yaml,*.yml,*.toml setlocal tabstop=2 softtabstop=2 shiftwidth=2
augroup END

" =============================================================================
" 5. プラグイン
" =============================================================================
" vim-plug 自動インストール
let data_dir = '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
    silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" LSP
Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/async.vim'

" Git
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'

call plug#end()

" =============================================================================
" 6. LSP設定
" =============================================================================
augroup MyLsp
    autocmd!
    " pylsp: 補完・定義ジャンプ（pip install python-lsp-server）
    if executable('pylsp')
        autocmd User lsp_setup call lsp#register_server({
            \ 'name': 'pylsp',
            \ 'cmd': { server_info -> ['pylsp'] },
            \ 'allowlist': ['python'],
            \ 'workspace_config': {'pylsp': {'plugins': {
            \   'jedi_definition': {'follow_imports': v:true, 'follow_builtin_imports': v:true},
            \   'pyflakes': {'enabled': v:false},
            \   'pycodestyle': {'enabled': v:false},
            \   'mccabe': {'enabled': v:false},
            \   'autopep8': {'enabled': v:false},
            \   'yapf': {'enabled': v:false},
            \   }}}
            \})
    endif
    " ruff: リンティング・フォーマット（pip install ruff）
    if executable('ruff')
        autocmd User lsp_setup call lsp#register_server({
            \ 'name': 'ruff',
            \ 'cmd': { server_info -> ['ruff', 'server'] },
            \ 'allowlist': ['python'],
            \})
    endif
    autocmd FileType python call s:configure_lsp()
augroup END

function! s:configure_lsp() abort
    setlocal omnifunc=lsp#complete
    nnoremap <buffer> <C-]> :<C-u>tab LspDefinition<CR>
    nnoremap <buffer> gd :<C-u>tab LspDefinition<CR>
    nnoremap <buffer> gD :<C-u>LspReferences<CR>
    nnoremap <buffer> gs :<C-u>LspDocumentSymbol<CR>
    nnoremap <buffer> gS :<C-u>LspWorkspaceSymbol<CR>
    nnoremap <buffer> gQ :<C-u>LspDocumentFormat<CR>
    vnoremap <buffer> gQ :LspDocumentRangeFormat<CR>
    nnoremap <buffer> K :<C-u>LspHover<CR>
    nnoremap <buffer> <F1> :<C-u>LspImplementation<CR>
    nnoremap <buffer> <F2> :<C-u>LspRename<CR>
endfunction

let g:lsp_diagnostics_enabled = 1
