{ config, pkgs, ... }:

{
  services.xserver.enable = true;

  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.cinnamon.enable = true;

  # niri is a second session, picked on the login screen; settings in home/.config/niri
  programs.niri.enable = true;
  services.displayManager.defaultSession = "cinnamon";
  security.pam.services.swaylock = { };
  # Browsers and Electron run native Wayland under niri; the variable does nothing under X11
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.systemPackages = with pkgs; [
    xwayland-satellite # X11 apps under niri, niri starts it itself
    wl-clipboard
    fuzzel
    waybar
    mako
    swaylock
    brightnessctl
  ];

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  fonts.packages = with pkgs; [
    nerd-fonts.hurmit
  ];
}
