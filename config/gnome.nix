{ pkgs, ... }:
{
  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.excludePackages = with pkgs; [
    xterm # No need for xterm with gnome terminal
  ];

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Exclude a few gnome packages
  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    yelp
    epiphany
  ];

  # Required for Systray Icons
  services.udev.packages = with pkgs; [ gnome-settings-daemon ];

  # Required for GSConnect support
  programs.kdeconnect = {
    enable = true;
    package = pkgs.gnomeExtensions.gsconnect;
  };

  # Enable Wayland for Chromium derivatives and QT apps
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  # environment.sessionVariables.QT_QPA_PLATFORM = "wayland";

  programs.dconf.enable = true;
}
