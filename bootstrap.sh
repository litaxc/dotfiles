# install brew
if [[ ! $(which brew) ]]; then
    echo brew installing
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval $(/opt/homebrew/bin/brew shellenv)
fi
echo brew installed

# install tools
echo tools installing
brew update && brew install -q \
    fzf \
    isacikgoz/taps/tldr \
    lazygit \
    neovim \
    node \
    ripgrep \
    zsh
echo tools installed

# install oh my zsh
if [[ ! -d $HOME/.oh-my-zsh ]]; then
    echo zsh installing
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi
echo zsh installed

# install vim plug
if [[ ! -d $HOME/.vim/plugged ]]; then
    echo vim plug installing
    sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
           https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
fi
echo vim plug installed

# link files to the right place
files=(
    zshrc,$HOME/.zshrc
    config,$HOME/.config
    .gitconfig,$HOME/.gitconfig
    .gitignore_global,$HOME/.gitignore_global
    lazygit-config.yml,$HOME/Library/Application\ Support/lazygit/config.yml
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
