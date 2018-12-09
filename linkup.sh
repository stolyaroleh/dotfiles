#!/run/current-system/sw/bin/env nix-shell
#!nix-shell -p stow -i zsh

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
pushd $SCRIPTPATH

sudo mkdir -p /etc/nixos && sudo chown $USER /etc/nixos
stow --target=/etc/nixos nixos

mkdir -p $HOME/.config/kitty
stow --target=$HOME/.config/kitty kitty

mkdir -p $HOME/.config/plasma-workspace
stow --target=$HOME/.config/plasma-workspace plasma-workspace

mkdir -p $HOME/.config/vscode
stow --target=$HOME/.config/vscode vscode

stow git
stow intellij
stow spacemacs
stow xmonad
stow zsh

popd
