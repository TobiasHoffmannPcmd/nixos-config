{ config, pkgs, ... }:


{
  home.username = "crdy";
  home.homeDirectory = "/home/crdy";
  home.packages = with pkgs; [
    # system-wide installed
    fastfetch
    direnv
    git
    claude-code

    # for neovim
    nerd-fonts.jetbrains-mono
  ];

  programs.bash.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    config.global.hide_env_diff = true;
  };

  programs.git = {
    enable = true;
    settings.user.name = "TobiasHoffmannPcmd";
    settings.user.email = "tp@globalwindsafety.org";
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      nvim-treesitter.withAllGrammars
    ];
    extraPackages = with pkgs; [
      git
      ripgrep
      fd
      gcc
      nodejs       # for Mason LSP installer
      lua-language-server
      nil          # nix LSP
    ];
  };

  xdg.configFile."nvim/init.lua".text = ''
    -- Bootstrap lazy.nvim
    local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
    if not (vim.uv or vim.loop).fs_stat(lazypath) then
      local lazyrepo = "https://github.com/folke/lazy.nvim.git"
      local out = vim.fn.system({
        "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath
      })
      if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
          { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
          { out, "Warn" },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
      end
    end
    vim.opt.rtp:prepend(lazypath)

    require("lazy").setup({
      spec = {
        -- LazyVim base
        { "LazyVim/LazyVim", import = "lazyvim.plugins" },
        -- LazyVim extras (uncomment what you want)
        -- { import = "lazyvim.plugins.extras.lang.typescript" },
        -- { import = "lazyvim.plugins.extras.lang.python" },
        -- { import = "lazyvim.plugins.extras.lang.nix" },
        -- { import = "lazyvim.plugins.extras.ui.mini-starter" },
        -- Grammars come pre-compiled from Nix; disable runtime install
        { "nvim-treesitter/nvim-treesitter",
          opts = { auto_install = false, ensure_installed = {} },
        },
      },
      defaults = { lazy = false, version = false },
      install = { colorscheme = { "tokyonight", "habamax" } },
      checker = { enabled = true },
      performance = {
        rtp = {
          disabled_plugins = {
            "gzip", "tarPlugin", "tohtml", "tutor", "zipPlugin",
          },
        },
      },
    })
  '';

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
