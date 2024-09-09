# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  pkgs,
  lib,
  hostname,
  user,
  ...
}:
{
  imports = [
    ./boot.nix
    ./gnome.nix
    ./locals.nix
    ./nix.nix
    ./pipewire.nix
  ];

  # Set user
  users.users.user = user;
  systemd.services."user@".serviceConfig.Delegate = "memory pids cpu cpuset io";

  # Set default shell to zsh
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # Disable Nano editor
  programs.nano.enable = false;

  # Enable Home-Manager
  environment.systemPackages = with pkgs; [
    home-manager
  ];

  # Enable networking
  networking.networkmanager.enable = true;
  networking.hostName = hostname;
  networking.useDHCP = lib.mkDefault true;

  # Enable Hardware acceleration
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;
}
