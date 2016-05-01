#!/usr/bin/env bash

ABS_PATH=`pwd`

ln -Tsi "$ABS_PATH/zsh/prezto" ~/.zprezto
ln -Tsi "$ABS_PATH/zsh/zpreztorc" ~/.zpreztorc
ln -Tsi "$ABS_PATH/zsh/zshenv" ~/.zshenv
ln -Tsi "$ABS_PATH/zsh/zshrc" ~/.zshrc

ln -Tsi "$ABS_PATH/git/gitconfig" ~/.gitconfig

ln -Tsi "$ABS_PATH/spacemacs/spacemacs" ~/.spacemacs

ln -Tsi "$ABS_PATH/intellij/ideavimrc" ~/.ideavimrc
