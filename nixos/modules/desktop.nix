{ config, pkgs, ... }:

{
  services.xserver.enable = true;

  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.cinnamon.enable = true;

  # niri — вторая сессия, выбирается на экране входа; настройки в home/.config/niri
  programs.niri.enable = true;
  services.displayManager.defaultSession = "cinnamon";
  security.pam.services.swaylock = { };
  # Браузеры и Electron — родным Wayland под niri, под X11 переменная не действует
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.systemPackages = with pkgs; [
    xwayland-satellite # X11-программы под niri, niri запускает его сам
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
