#!/bin/bash
# Install neovim-python; vim-plug requires neovim-python
if [[ "$(which pip2)" != "" ]]; then
  pip2 install --user neovim jedi
elif [[ "$(which pip3)" != "" ]]; then
  pip3 install --user neovim jedi
elif [[ "$(which pip)" != "" ]]; then
  pip install --user neovim jedi
else
  echo 'You need to install python-pip first'
  exit
fi

# Install vim-plug
VIM_PLUG_URL=https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
mkdir -p nvim/autoload
curl -Lo nvim/autoload/plug.vim "$VIM_PLUG_URL"

# Link neovim configuration to ~/.config/nvim
xdg_config_dir="$HOME/.config"
nvimrc_name="init.nvim"
src_nvim_dir="$(pwd)/$(dirname "$0")/nvim"
src_nvimrc="$src_nvim_dir/$nvimrc_name"
dst_nvim_dir="$xdg_config_dir/nvim"
dst_nvimrc="$dst_nvim_dir/$nvimrc_name"
echo "Neovim configuration directory: $dst_nvim_dir"
if [[ ! -f "$dst_nvimrc" || "$(cat "$src_nvimrc")" != "$(cat "$dst_nvimrc")" ]]
then
  rm -f "$dst_nvim_dir"
  mkdir "$xdg_config_dir"
  ln -sfi "$src_nvim_dir" "$dst_nvim_dir"
fi

# Install plugins using vim-plug
nvim +PlugInstall +PlugUpdate +PlugClean! +qall
