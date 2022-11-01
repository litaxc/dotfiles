call plug#begin('~/.vim/plugged')

" A fuzzy file finder
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
" Intellisense engine
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Indent guide
Plug 'lukas-reineke/indent-blankline.nvim'
" Git related
Plug 'lewis6991/gitsigns.nvim'
" TeX
Plug 'lervag/vimtex'
" terraform
Plug 'hashivim/vim-terraform'
" IPython
Plug 'jpalardy/vim-slime', { 'for': 'python' }
Plug 'hanschen/vim-ipython-cell', { 'for': 'python' }
" cypher syntax
Plug 'memgraph/cypher.vim'
" CSV
Plug 'mechatroner/rainbow_csv'
" hex color
Plug 'norcalli/nvim-colorizer.lua'

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
" coc.nvim
let g:python3_host_prog='/opt/homebrew/bin/python3'
let g:terraform_fmt_on_save=1

set updatetime=200
augroup coc
    autocmd BufWritePre *.go silent call CocAction('runCommand', 'editor.action.organizeImport')
    " autocmd BufWritePre *.py silent call CocAction('runCommand', 'editor.action.organizeImport')
    autocmd CursorHold * silent call CocActionAsync('highlight')
augroup end

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<cr>
nnoremap <silent><nowait> <space>l  :<C-u>CocList<cr>
inoremap <silent><expr> <c-n> coc#pum#visible() ? coc#pum#next(1) : coc#refresh()
inoremap <expr><c-p> coc#pum#visible() ? coc#pum#prev(1) : "<c-p>"
inoremap <silent><expr> <cr> coc#pum#visible() ? coc#pum#confirm() : "<CR>"

nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
    if CocAction('hasProvider', 'hover')
        call CocActionAsync('doHover')
    else
        call feedkeys('K','in')
    endif
endfunction

" Add `:Format` command to format current buffer.
function SortImportsAndFormat()
    call CocAction('runCommand', 'editor.action.organizeImport')
    call CocActionAsync('format')
endfunction
nnoremap <leader>F :call SortImportsAndFormat()<CR>

"
" TeX
filetype plugin indent on
syntax enable

"
" IPython
let g:slime_target = 'tmux'
let g:slime_python_ipython = 1
let g:slime_default_config = {
            \ 'socket_name': get(split($TMUX, ','), 0),
            \ 'target_pane': '{bottom}' }
let g:slime_dont_ask_default = 1
nnoremap <leader>r :IPythonCellRun<CR>
nnoremap <leader>c :IPythonCellExecuteCell<CR>
xmap <leader>c <Plug>SlimeRegionSend
nnoremap <leader>C :IPythonCellExecuteCellJump<CR>
nnoremap [c :IPythonCellPrevCell<CR>
nnoremap ]c :IPythonCellNextCell<CR>
nnoremap <leader>d :SlimeSend1 %debug<CR>


" other plugin settings in lua
lua require('plugins')
