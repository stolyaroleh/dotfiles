#!/usr/bin/env zsh

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
pushd $SCRIPTPATH

stow --target=/etc/nixos nixos

stow git
stow intellij
stow spacemacs
stow xmonad
mkdir -p $HOME/.config/kitty
stow --target=$HOME/.config/kitty kitty
stow zsh
stow --target=$HOME/.config vscode

popd
