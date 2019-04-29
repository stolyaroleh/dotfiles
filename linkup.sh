#!/run/current-system/sw/bin/env nix-shell
#!nix-shell -p stow -i zsh

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
pushd $SCRIPTPATH

sudo mkdir -p /etc/nixos && sudo chown $USER /etc/nixos
stow --target=/etc/nixos nixos

mkdir -p $HOME/.config/bat
stow --target=$HOME/.config/bat bat

mkdir -p $HOME/.config/kitty
stow --target=$HOME/.config/kitty kitty

mkdir -p $HOME/.config/plasma-workspace
stow --target=$HOME/.config/plasma-workspace plasma-workspace

mkdir -p $HOME/.config/vscode
stow --target=$HOME/.config/vscode vscode

mkdir -p $HOME/.ghc
stow --target=$HOME/.ghc ghc

stow git
stow intellij
stow spacemacs
stow ssh
stow xmonad
stow zsh

popd
