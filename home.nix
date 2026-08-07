{ config, pkgs, ... }:


{
  home.username = "crdy";
  home.homeDirectory = "/home/crdy";
  home.packages = with pkgs; [
    fastfetch
    direnv
    git
    neovim
    claude-code
  ];

  programs.bash.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    config.global.hide_env_diff = true;
  };

  programs.git = {
    enable = true;
    #    settings = {
    #	name = "TobiasHoffmannPcmd";
    #	email = "tp@globalwindsafety.org";
    #};
    #init.defaultBranch = "main";
  };

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Managerlease notes for a list of state version
  # changes in each release.
  home.stateVersion = "26.05";
}
