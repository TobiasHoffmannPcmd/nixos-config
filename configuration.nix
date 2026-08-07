{ config, lib, pkgs, ... }:
{
  wsl.enable = true;
  wsl.defaultUser = "crdy";

  networking.hostName = "crdy";

  users.users.crdy = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  environment.systemPackages = with pkgs; [ vim ];
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "claude-code"
    ];


  system.stateVersion = "26.05";
}
