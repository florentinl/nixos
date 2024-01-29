{ pkgs, ... }:

{
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = [ "nvidia" ];

  # Required for Systray Icons
  services.udev.packages = with pkgs; [
    gnome.gnome-settings-daemon
  ];

  # Adwaita Icon Theme
  environment.systemPackages = with pkgs; [
    gnome.adwaita-icon-theme
  ];

  programs.dconf.enable = true;
}
