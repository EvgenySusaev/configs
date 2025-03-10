## install csharp_ls
## swap capslock and ctrl



## install nerd_fonts
wget -P ~/.local/share/fonts https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip \
&& cd ~/.local/share/fonts \
&& unzip JetBrainsMono.zip \
&& rm JetBrainsMono.zip \
&& fc-cache -fv

## install lua and lua rocks
sudo apt install lua5.1 liblua5.1-0-dev

# download lua rocks
wget https://luarocks.github.io/luarocks/releases/luarocks-3.11.0.tar.gz
tar zxpf luarocks-3.11.0.tar.gz
cd luarocks-3.11.0

# install lua rocks
./configure --lua-version=5.1 --with-lua-include=/usr/include/lua5.1
make
sudo make install


export PATH="$HOME/.dotnet/tools:$PATH"
dotnet tool install --global csharp-ls
sudo pacman -S fzf
sudo pacman -S wikiman
sudo pacman -S arch-wiki-docs
