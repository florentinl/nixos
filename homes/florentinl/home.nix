{ pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "florentinl";
  home.homeDirectory = "/home/florentinl";

  imports = [
    ./zsh.nix
  ];

  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      rust-lang.rust-analyzer
      asvetliakov.vscode-neovim
      github.copilot
      jnoortheen.nix-ide
      github.copilot-chat
    ];
  };

  home.packages = with pkgs; [
      alacritty
      microsoft-edge
      enpass

      git
      neovim

      zsh
      starship
      xclip
      xsel

      cargo
      rustc
      rustfmt
      clippy
      llvmPackages.libclang

      nixd
  ];

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
