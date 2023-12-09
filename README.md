## nvim configs
Add these configs in the nvim folder.

- OS wise configuration directory paths
    - Ubuntu - .config/nvim
    - Windows - C:\Users\<windows-usern>\AppData\Local\nvim

- Install packer.nvim
    - linux - git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim
    - git clone https://github.com/wbthomason/packer.nvim "$env:LOCALAPPDATA\nvim-data\site\pack\packer\start\packer.nvim"

Repo for packer - https://github.com/wbthomason/packer.nvim

- open nvim by running `nvim`
    - press colon ":" then type "PackerSync" and hit enter

Every dependency will be installed 

Enjoy!
