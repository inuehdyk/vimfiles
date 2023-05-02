#!/bin/bash
VIMRC_DIR=$(cd $(dirname $0);pwd)
mkdir -p ${VIMRC_DIR}/pack/my/start
mkdir -p ${VIMRC_DIR}/pack/my/opt
cd ${VIMRC_DIR}/pack/my/opt
git clone https://github.com/vim-jp/vimdoc-ja.git
curl -fLo ${VIMRC_DIR}/autoload/jetpack.vim --create-dirs \
  https://raw.githubusercontent.com/tani/vim-jetpack/master/plugin/jetpack.vim

curl -fLo ${VIMRC_DIR}/color/solarized.vim --create-dirs \
  https://raw.githubusercontent.com/altercation/vim-colors-solarized/master/colors/solarized.vim
