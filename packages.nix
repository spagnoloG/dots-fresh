{ pkgs }:

let
  packageNames = [
    "stow"
    "brave"
    "discord"
    "spotify"
    "smug"
    "neovim"
    "joplin"
    "fira-code"
    "uget"
    "zathura"
    "gimp"
  ];
   config = {
    allowUnfree = true;
  };
  
  customPkgs = import <nixpkgs> { inherit config; };
in
  builtins.map (name: pkgs.${name}) packageNames
