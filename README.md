### dots-fresh
Collection of my dotfiles.

Fristly install [nix-os package manager](https://github.com/dnkmmr69420/nix-installer-scripts).

## Usage
```bash
export NIXPKGS_ALLOW_UNFREE=1
nix-env -iA myPackages -f default.nix
stow -nvt ~ home_dir
```
## Screenshot
![screenshot](./screenshots/screenshot.png)
