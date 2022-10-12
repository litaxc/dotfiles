set number relativenumber
set mouse=n
set list
set expandtab
set tabstop=4
set shiftwidth=4

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


" remember last position
augroup remember-cursor-position
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
augroup END

if !exists('g:vscode')
    runtime plugins.vim
endif
