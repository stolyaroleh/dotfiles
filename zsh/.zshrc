# don't use r to replay the last command typed
disable r

# set up terminal color scheme
BASE16_SHELL=$HOME/dotfiles/base16-shell
[ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"

base16_material-darker

# TODO: antigen-hs everything
source ~/prezto/init.zsh
source ~/alias-tips/alias-tips.plugin.zsh

alias la='ls -a'
alias gs='git status'
