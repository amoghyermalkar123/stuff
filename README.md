### Installing Nvim:
-  curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
-  chmod u+x nvim.appimage
-  sudo cp ./nvim.appimage /usr/bin/nvim
- cd /usr/bin/
- sudo chown -R <username>:<username> nvim

### Configuring Neovim
- create a directory `nvim` in `.config`
- Run `git clone https://github.com/amoghyermalkar123/stuff nvim`
- Open nvim and run `:PackerSync`
- Make sure gcc is installed - `sudo apt install gcc` if not.
- Install go, gopls, etc for LSP

### Installing Go and Gopls
- Run `wget https://go.dev/dl/go1.21.0.linux-amd64.tar.gz -O go.tar.gz`
- Run `sudo  tar -C /usr/local -xzvf go.tar.gz`
- Edit `~/.profile`
```export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
```
- Finally, `source ~/.profile`
- Install gopls in via `:Mason`

### Installing rust:
- Follow instructions on `https://www.rust-lang.org/tools/install`

