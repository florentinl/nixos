{pkgs, ...}: {
  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.excludePackages = with pkgs; [
    xterm # No need for xterm with gnome terminal
  ];

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.gdm.wayland = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Exclude a few gnome packages
  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    yelp
    epiphany
  ];

  # Required for Systray Icons
  services.udev.packages = with pkgs; [
    gnome.gnome-settings-daemon
  ];

  # Adwaita Icon Theme
  environment.systemPackages = with pkgs; [
    adwaita-icon-theme
  ];

  programs.dconf.enable = true;
}
