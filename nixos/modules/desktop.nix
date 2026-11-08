{ config, pkgs, ... }:

{
  services.xserver.enable = true;

  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.cinnamon.enable = true;

  # niri is the default session, Cinnamon stays on the login screen as the fallback; settings in home/.config/niri
  programs.niri.enable = true;
  services.displayManager.defaultSession = "niri";
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
