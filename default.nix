let
	pkgs = import <nixpkgs> {};
in {
	myPackages = import ./packages.nix { inherit pkgs; };
}
