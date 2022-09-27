set number relativenumber
set mouse=a
set list
set expandtab
set tabstop=4
set shiftwidth=4

" treat underscore as different word
set iskeyword-=_

" fix clipboard issue
let $LANG='en_US.UTF-8'
set clipboard=unnamed

set foldmethod=syntax
set nofoldenable
highlight Folded ctermbg=None ctermfg=102

highlight DiffText ctermbg=1

set autoread
autocmd CursorHold * if getcmdwintype() == '' | checktime | endif


augroup filetypedetect
    autocmd BufRead,BufNewFile Jenkinsfile set filetype=groovy
    " autocmd BufRead,BufNewFile *.nomad set filetype=tf
    autocmd FileType json setlocal concealcursor=nc
    autocmd FileType groovy,json,yaml,typescript,javascript setlocal tabstop=2 shiftwidth=2 foldmethod=indent
    autocmd FileType python setlocal foldmethod=indent
    autocmd FileType go setlocal noexpandtab tabstop=8 shiftwidth=8
augroup END

inoremap <C-h> <Left>
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-l> <Right>
cnoremap <C-h> <Left>
cnoremap <C-j> <Down>
cnoremap <C-k> <Up>
cnoremap <C-l> <Right>
" tnoremap <Esc> <C-\><C-n>  " but conflict with floating window

" remember last position
augroup remember-cursor-position
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
augroup END

call plug#begin('~/.vim/plugged')

" A fuzzy file finder
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
" Intellisense engine
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Indent guide
Plug 'lukas-reineke/indent-blankline.nvim'
" Git related
Plug 'nvim-lua/plenary.nvim'
Plug 'lewis6991/gitsigns.nvim'
" TeX
Plug 'lervag/vimtex'
" terraform
Plug 'hashivim/vim-terraform'

" cypher syntax
Plug 'memgraph/cypher.vim'

" theme
Plug 'nikolvs/vim-sunbather'

call plug#end()

set background=light
colorscheme sunbather


"
" fzf
nnoremap <c-p> :Files<cr>
nnoremap <c-b> :Buffer<cr>

"
" indentLine
highlight IndentBlanklineChar ctermfg=255

"
" gitsigns
lua <<EOF
require('gitsigns').setup()
EOF

"
" coc.nvim
let g:python3_host_prog='/usr/local/bin/python3'
let g:terraform_fmt_on_save=1

set updatetime=200
autocmd BufWritePre *.go silent call CocAction('runCommand', 'editor.action.organizeImport')
autocmd BufWritePre *.py silent call CocAction('runCommand', 'pyright.organizeimports')
autocmd CursorHold * silent call CocActionAsync('highlight')

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<cr>
inoremap <silent><expr> <c-j>
            \ coc#pum#visible() ? coc#pum#next(1) :
            \ coc#refresh()
inoremap <expr><c-k> coc#pum#visible() ? coc#pum#prev(1) : "\<c-h>"
inoremap <silent><expr> <cr> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
    if CocAction('hasProvider', 'hover')
        call CocActionAsync('doHover')
    else
        call feedkeys('K','in')
    endif
endfunction

"
" TeX
filetype plugin indent on
syntax enable
