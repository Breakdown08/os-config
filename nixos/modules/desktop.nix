{ config, pkgs, ... }:

{
  services.xserver.enable = true;
  # xterm is the X11 default, kitty replaces it and Cinnamon does not need it
  services.xserver.excludePackages = [ pkgs.xterm ];

  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.cinnamon.enable = true;
  # mpv replaces Cinnamon's Celluloid
  environment.cinnamon.excludePackages = [ pkgs.celluloid ];

  # niri is the default session, Cinnamon stays on the login screen as the fallback; settings in home/.config/niri
  programs.niri.enable = true;
  services.displayManager.defaultSession = "niri";
  # niri does not create the screenshot-path directory and drops the file without it
  systemd.tmpfiles.rules = [
    "d ${config.users.users.breakdown.home}/Pictures/Screenshots 0755 breakdown users -"
  ];
  security.pam.services.swaylock = { };
  # Browsers and Electron run native Wayland under niri; the variable does nothing under X11
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  # shared-mime-info names mkv video/matroska, mpv only declares video/x-matroska and xdg-open under niri finds nothing
  xdg.mime.defaultApplications."video/matroska" = "mpv.desktop";
  environment.systemPackages = with pkgs; [
    xwayland-satellite # X11 apps under niri, niri starts it itself
    wl-clipboard
    fuzzel
    waybar
    mako
    swaylock
    brightnessctl
    mpv
  ];

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  fonts.packages = with pkgs; [
    nerd-fonts.hurmit
  ];
}
