export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export CLICOLOR=true

export EDITOR=code
export GREP_OPTIONS='--color=always'

export PATH=$PATH:~/go/bin


# handy alias
alias py='python3 -q'
alias pip='pip3'
alias r="R -q --no-save"
alias ni="node --inspect-brk"
alias ssha="ssh -i ~/.ssh/awskeypair.pem -L 8889:127.0.0.1:8888"
alias scpa="scp -Ci ~/.ssh/awskeypair.pem"
alias vs=code  # vscode
alias k=kubectl  # kubectl


# some zsh specific settings
# autoload -Uz promptinit
# promptinit
# prompt off
PROMPT='%B[%@]%#%b '

# enable docker completion
fpath=(~/.zsh/completion $fpath)

autoload -Uz compinit
compinit
precmd () {print -Pn "\e]2; %~/ \a"}


# proxies
export no_proxy="10.41.75.56,10.41.75.77,10.41.75.78,127.0.0.1"
# export http_proxy="http://10.41.69.73:13128" export https_proxy="http://10.41.69.73:13128"
# export http_proxy="http://10.41.69.65:13128" export https_proxy="http://10.41.69.65:13128"
export http_proxy="http://127.0.0.1:49254" export https_proxy="http://127.0.0.1:49254" export socks_proxy="socks5://127.0.0.1:49255"
# export http_proxy="http://0.0.0.0:1087" export https_proxy="http://0.0.0.0:1087"


# enable aws sdk completion
# source '/usr/local/bin/aws_zsh_completer.sh'

# enable google cloud sdk completion
# source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc'
# source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc'

# enable kubernetes completion
# source <(kubectl completion zsh)

# always attach to an tmux session
# [[ $TERM != 'screen' ]] && { tmux -CC attach || exec tmux -CC new-session -s base && exit; }
