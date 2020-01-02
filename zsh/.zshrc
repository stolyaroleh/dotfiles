# don't use r to replay the last command typed
disable r

# alias-tips
source "$HOME/dotfiles/zsh/alias-tips/alias-tips.plugin.zsh"

# prezto
source "$HOME/dotfiles/zsh/prezto/init.zsh"

if [[ -a "$HOME/.workrc" ]]; then
  source "$HOME/.workrc"
fi

# fasd
alias d='fasd -d'
alias f='fasd -f'

# fzf
source "$FZF_PATH/share/fzf/completion.zsh"
source "$FZF_PATH/share/fzf/key-bindings.zsh"

# misc aliases
alias la='ls -lahF'
alias gs='git status'
alias gd='git diff --word-diff=color'
alias gds='git diff --word-diff=color --staged'

export EDITOR=vim
export TERM=xterm-256color

alias cat='bat --decorations=never'
