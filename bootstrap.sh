function install_brew() {
    if [[ ! $(which brew) ]]; then
        echo brew installing
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        eval $(/opt/homebrew/bin/brew shellenv)
    fi
    echo brew installed
}

function install_pkgs() {
    echo pkgs installing
    brew update && brew install -q \
        btop \
        dust \
        fish \
        fzf \
        git \
        glow \
        isacikgoz/taps/tldr \
        lazygit \
        lua-language-server \
        neovim \
        pipx \
        ripgrep \
        tmux \
        virtualfish

    pipx install -q basedpyright
    echo pkgs installed
}

function link_files() {
    files=(
        config,$HOME/.config
        .gitconfig,$HOME/.gitconfig
        .gitignore_global,$HOME/.gitignore_global
    )

    BACKUP_DIR=$HOME/.dotfiles-$(date +%Y-%m-%dT%H:%M:%S)
    for i in "${files[@]}"; do
        IFS=","
        set -- $i

        if [[ -L $2 ]]; then
            # remove existing symbolic link $2
            rm $2
        elif [[ -f $2 ]]; then
            # backup regular file $2
            mkdir -p $BACKUP_DIR
            mv $2 $BACKUP_DIR/
        fi

        echo linking $2
        ln -s `pwd`/$1 $2
    done
    echo linking done
}


install_brew
install_pkgs
link_files
