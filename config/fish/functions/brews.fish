function brews -d "List all installed brew pkg and its dependencies."
    set FORMULAE "$(brew leaves | xargs brew deps --for-each)"
    set CASKS "$(brew list --cask 2>/dev/null)"
    echo "$(set_color blue)==>$(set_color normal) $(set_color -o)Formulae$(set_color normal)"
    echo $FORMULAE | sed s"/^\(.*\):\(.*\)\$/\1$(set_color blue)\2$(set_color normal)/"
    echo -e "\n$(set_color blue)==>$(set_color normal) $(set_color -o)Casks$(set_color normal)\n$CASKS"
end
