{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ nixpkgs, home-manager, nixos-wsl, ... }:
  let
    hosts = {
      crdy = {
        username = "crdy";
        gitName = "TobiasHoffmannPcmd";
        gitEmail = "tp@globalwindsafety.org";
      };
      newUser-pc = {
        username = "doe";
        gitName = "doeGit";
        gitEmail = "doeGit@globalwindsafety.org";
      };
    };

    mkHost = hostName: user: nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs user; };
      modules = [
        nixos-wsl.nixosModules.default
        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
          networking.hostName = hostName;
          wsl.defaultUser = user.username;
          users.users.${user.username} = {
            isNormalUser = true;
            extraGroups = [ "wheel" ];
          };
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "hm-bak";
          home-manager.users.${user.username} = import ./home.nix;
          home-manager.extraSpecialArgs = { inherit user; };
        }
      ];
    };
  in {
    nixosConfigurations = nixpkgs.lib.mapAttrs mkHost hosts;
  };
}
