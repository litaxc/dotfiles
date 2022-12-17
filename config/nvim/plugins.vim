call plug#begin('~/.vim/plugged')

" A fuzzy file finder
Plug 'ibhagwan/fzf-lua', {'branch': 'main'}
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
" cypher syntax
Plug 'memgraph/cypher.vim'
" CSV
Plug 'mechatroner/rainbow_csv'
" hex color
Plug 'norcalli/nvim-colorizer.lua'
" which-key
Plug 'folke/which-key.nvim'

" theme
Plug 'shaunsingh/nord.nvim'

call plug#end()

set background=dark
colorscheme nord


"
" fzf
nnoremap <c-p> <cmd>lua require('fzf-lua').files()<cr>
nnoremap <c-b> <cmd>lua require('fzf-lua').buffers()<cr>
nnoremap <leader>fg <cmd>lua require('fzf-lua').live_grep_native()<cr>

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
    silent! call CocAction('runCommand', 'editor.action.organizeImport')
    silent call CocActionAsync('format')
endfunction
nnoremap <leader>F :call SortImportsAndFormat()<CR>

"
" TeX
filetype plugin indent on
syntax enable

" other plugin settings in lua
lua require('plugins')
