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

  environment.etc."profile.d/load-user-profile.sh" = {
    text = ''
      if [ -f "$HOME/.profile" ]; then
        set -a
        source "$HOME/.profile"
        set +a
      fi
    '';
    mode = "0755";
  };
}
