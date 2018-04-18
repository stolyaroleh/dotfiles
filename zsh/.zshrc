# don't use r to replay the last command typed
disable r

# set up terminal color scheme
BASE16_SHELL=$HOME/dotfiles/zsh/base16-shell
[ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"
base16_material-darker

# TODO: antigen-hs everything
source $HOME/dotfiles/zsh/alias-tips/alias-tips.plugin.zsh
source $HOME/dotfiles/zsh/autoenv/activate.sh
source $HOME/dotfiles/zsh/prezto/init.zsh

source $HOME/.cargo/env
source $HOME/.workrc

# fasd
alias d='fasd -d'
alias f='fasd -f'

# aliases
alias la='ls -a'
alias gs='git status'

