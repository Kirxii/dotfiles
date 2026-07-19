# Installation guide

## Windows

Run PowerShell and run the following commands

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser; Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression; refreshenv; scoop bucket add main; scoop bucket add extras; scoop install main/neovim; scoop install main/git; scoop install main/clangd; scoop install extras/wezterm; refreshenv; git clone https://github.com/Kirxii/wezterm; cd ~/Appdata/Local/; git clone https://github.com/Kirxii/nvim; wezterm start -- nvim;
```
