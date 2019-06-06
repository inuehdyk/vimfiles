#!/bin/bash
VIMRC_DIR=$(cd $(dirname $0);pwd)
mkdir -p ${VIMRC_DIR}/pack/my/start
mkdir -p ${VIMRC_DIR}/pack/my/opt
cd ${VIMRC_DIR}/pack/my/opt
git clone https://github.com/vim-jp/vimdoc-ja.git
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
	https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

