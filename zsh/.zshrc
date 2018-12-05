# don't use r to replay the last command typed
disable r

# TODO: antigen-hs everything
source $HOME/dotfiles/zsh/alias-tips/alias-tips.plugin.zsh
source $HOME/dotfiles/zsh/autoenv/activate.sh
source $HOME/dotfiles/zsh/prezto/init.zsh

source $HOME/.cargo/env
source $HOME/.workrc

# fzf
source "$FZF_PATH/share/fzf/completion.zsh"
source "$FZF_PATH/share/fzf/key-bindings.zsh"

# fasd
alias d='fasd -d'
alias f='fasd -f'

# aliases
alias la='ls -a'
alias gs='git status'
alias gd='git diff --word-diff=color'
alias gds='git diff --word-diff=color --staged'
