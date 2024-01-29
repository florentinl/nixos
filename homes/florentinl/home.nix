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

  programs.alacritty = {
    enable = true;
    package = pkgs.alacritty;
    settings = {
      font = {
        normal = {
          family = "CaskaydiaCove Nerd Font";
          style = "Regular";
        };
        bold = {
          family = "CaskaydiaCove Nerd Font";
          style = "Bold";
        };
      };
      key_bindings = [
        # Open a new tab
        { key = "N"; mods = "Control"; action = "SpawnNewInstance"; }
      ];
    };
  };

  dconf.settings = {
    "org/gnome/desktop/lockdown" = {
      disable-lock-screen = false;
    };

    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = [
        "BingWallpaper@ineffable-gmail.com"
        "clipboard-history@alexsaveau.dev"
        "appindicatorsupport@rgcjonas.gmail.com"
      ];
    };

    "org/gnome/desktop/wm/keybindings" = {
      switch-applications = [ "<Super>Tab" ];
      switch-applications-backward = [ "<Shift><Super>Tab" ];
      switch-windows = [ "<Alt>Tab" ];
      switch-windows-backward = [ "<Alt><Control>Tab" ];
    };
  };

  home.packages = with pkgs; [
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
    nixpkgs-fmt

    (nerdfonts.override { fonts = [ "CascadiaCode" ]; })

    gnomeExtensions.appindicator
    gnomeExtensions.bing-wallpaper-changer
    gnomeExtensions.clipboard-history

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
