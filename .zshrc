export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export CLICOLOR=true

export EDITOR=subl


# handy alias
alias py='python3 -q'
alias pip='pip3'
alias r="R -q --no-save"
alias ni="node --inspect-brk"
alias ssha="ssh -i ~/.ssh/awskeypair.pem -L 8889:127.0.0.1:8888"
alias scpa="scp -Ci ~/.ssh/awskeypair.pem"


# some zsh specific settings
# autoload -Uz promptinit
# promptinit
# prompt off
PROMPT='%B[%@]%#%b '

autoload -Uz compinit
compinit
precmd () {print -Pn "\e]2; %~/ \a"}


# proxies
export http_proxy="http://127.0.0.1:49254"
export https_proxy="http://127.0.0.1:49254"
export socks_proxy="socks5://127.0.0.1:49255"


# enable aws sdk completion
source '/usr/local/bin/aws_zsh_completer.sh'

# enable google cloud sdk completion
source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc'
source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc'


# always attach to an tmux session
[[ $TERM != 'screen' ]] && { tmux -CC attach || exec tmux -CC new-session -s base && exit; }
