# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports = [
    ./boot.nix
    ./gnome.nix
    ./locals.nix
    ./pipewire.nix
    ./nix.nix
  ];

  # Enable Home-Manager
  environment.systemPackages = with pkgs; [
    home-manager
  ];

  # Enable networking
  networking.networkmanager.enable = true;
  networking.hostName = "flaptop";
  networking.useDHCP = lib.mkDefault true;
  
  # Enable Tailscale, but without auto-starting
  services.tailscale.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Keep the system updated
  services.fwupd.enable = true;
  system.autoUpgrade.enable = true;
}
