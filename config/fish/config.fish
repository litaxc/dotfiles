fish_add_path /opt/homebrew/bin $HOME/.local/bin

set -x LC_ALL en_US.UTF-8
set -x EDITOR nvim
set -x XDG_CONFIG_HOME $HOME/.config
set -x FZF_DEFAULT_COMMAND 'rg --files'

if status is-interactive
    # Commands to run in interactive sessions can go here
    abbr l "ls -lAh"
    abbr v nvim
    abbr vi nvim
    abbr lg lazygit
    abbr py python
    abbr ipy ipython
    abbr k kubectl
    abbr tt "tmux -CC a -t"
    abbr tn "tmux -CC new -s"

    vf install
    vf addplugins auto_activation
end
