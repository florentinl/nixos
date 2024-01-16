{ pkgs, ... }:

{
    programs.dconf.enable = true;
    programs.steam.enable = true;
    programs.zsh.enable = true;

    fonts.packages = with pkgs; [
      (nerdfonts.override { fonts = [ "CascadiaCode" ]; })
    ];

    # Required for Systray Icons
    services.udev.packages = with pkgs; [
      gnome.gnome-settings-daemon
    ];
}