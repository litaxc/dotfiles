function csv
    cat $argv | sed -e 's/^,/^<NA>,/g; s/,/,<NA>/g; s/<NA>\([^,]\)/\1/g' | column -ts, | nvim +"
    map <right> 30zl
    map <left>  30zh
    map q :qa!<CR>
    set scrollopt=hor scrollbind nowrap
    1split
    winc w
    "
end
