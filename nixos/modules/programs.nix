{ config, pkgs, ... }:

{
  programs.firefox.enable = true;
  programs.yazi.enable = true;
  programs.obs-studio.enable = true;

  programs.nix-ld = {
    enable = true;
  };

  # Секреты проектов: secrets/ в корне репозитория, см. README
  programs.direnv.enable = true;
}
