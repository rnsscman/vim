#!/bin/bash

if [[ $OSTYPE == 'linux-gnu' ]]; then
    PM_CMD='sudo apt'
    RC_ORG='.vimrc4linux.org'
elif [[ $OSTYPE == *'darwin'* ]]; then
    PM_CMD='brew'
    RC_ORG='.vimrc4darwin.org'
elif [[ $OSTYPE == 'cygwin' ]]; then
    PM_CMD='apt-cyg'
else
    echo 'This OS is not supported'
    exit 1
fi

$PM_CMD install vim

# plugin manager install
mkdir -p ~/.vim/autoload ~/.vim/bundle && \
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

# plugin install
if [ -d ~/.vim/bundle ]; then
    cd ~/.vim/bundle
    git clone https://github.com/kien/ctrlp.vim
    git clone https://github.com/scrooloose/nerdtree
    git clone https://github.com/scrooloose/nerdcommenter
    git clone https://github.com/majutsushi/tagbar
    git clone https://github.com/airblade/vim-gitgutter
if [[ $OSTYPE != 'cygwin' ]]; then
	git clone https://github.com/vim-airline/vim-airline
    git clone https://github.com/vim-airline/vim-airline-themes
fi
    cd -
fi

# gtags install
if [ -e .setup_gtags.sh ]; then
    . ./.setup_gtags.sh
fi

# .vimrc install
if [ -d vimrc ] && [ -e vimrc/$RC_ORG ]; then
    echo "let \$myvimrootdir= "\"$PWD\" > vimrc/.vimrc
    cat vimrc/$RC_ORG >> vimrc/.vimrc
    # why not work '.' after 'ln', so '$PWD' is used
    ln -svf $PWD/vimrc/.vimrc ~/.vimrc 
fi
