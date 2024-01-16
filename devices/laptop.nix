{ config, pkgs, ... }:

{
  # Enable fprintd
  services.fprintd.enable = true;
  services.fprintd.tod.enable = true;
  services.fprintd.tod.driver = pkgs.libfprint-2-tod1-goodix;

  # Configure Laptop Users
  users.users.florentinl = {
    isNormalUser = true;
    description = "Florentin Labelle";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };

  # Configure Home Manager Homes
  home-manager.users.florentinl = import ../homes/florentinl/home.nix;
}