move_nix_config:
	cp /etc/nixos/configuration.nix ./nix/ 


move_no_cuda_config:
	printf "Copying no_cuda config to nix folder\n"
	cp /etc/nixos/configuration.nix ./nix/no_cuda.nix
	printf "Copying home manager config to nix folder\n"
	cp ~/.config/home-manager/home.nix ./nix/home_no_cuda.nix
	
