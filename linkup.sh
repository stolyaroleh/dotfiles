#!/usr/bin/env zsh

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
pushd $SCRIPTPATH

stow git
stow intellij
stow spacemacs
stow xmonad
stow zsh

popd
