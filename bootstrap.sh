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
        black \
        btop \
        dust \
        efm-langserver \
        fzf \
        git \
        glow \
        isacikgoz/taps/tldr \
        isort \
        lazygit \
        lua-language-server \
        neovim \
        pyright \
        ripgrep \
        tmux \
        virtualenvwrapper \
        zsh
    echo pkgs installed
}

function install_ohmyz() {
    if [[ ! -d $HOME/.oh-my-zsh ]]; then
        echo oh my zsh installing
        sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    fi
    echo oh my zsh installed
}

function link_files() {
    files=(
        zshrc,$HOME/.zshrc
        config,$HOME/.config
        tmux.conf,$HOME/.tmux.conf
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
install_ohmyz
link_files
