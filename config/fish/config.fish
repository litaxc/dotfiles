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
    abbr n nerdctl

    vf install
    vf addplugins auto_activation
end
