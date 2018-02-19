#!/usr/bin/env zsh

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
pushd $SCRIPTPATH

stow --target=/etc/nixos nixos

stow git
stow intellij
stow spacemacs
stow xmonad
stow --target=$HOME/.config/termite termite
stow zsh
stow --target=$HOME/.config vscode

popd
