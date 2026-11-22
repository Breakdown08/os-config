{ config, pkgs, ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  # binary cache for llm-agents (Claude Code, Codex); flake nixConfig alone is ignored for untrusted users
  nix.settings.extra-substituters = [ "https://cache.numtide.com" ];
  nix.settings.extra-trusted-public-keys = [ "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g=" ];
  # weekly: drop generations older than two weeks, then hardlink identical store files
  nix.gc = { automatic = true; dates = "weekly"; options = "--delete-older-than 14d"; };
  nix.optimise = { automatic = true; dates = [ "weekly" ]; };

  nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # PSR1 exits on the eDP panel flash a strip along the top edge; costs a little idle battery
  boot.kernelParams = [ "i915.enable_psr=0" ];

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Ho_Chi_Minh";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ru_RU.UTF-8";
    LC_IDENTIFICATION = "ru_RU.UTF-8";
    LC_MEASUREMENT = "ru_RU.UTF-8";
    LC_MONETARY = "ru_RU.UTF-8";
    LC_NAME = "ru_RU.UTF-8";
    LC_NUMERIC = "ru_RU.UTF-8";
    LC_PAPER = "ru_RU.UTF-8";
    LC_TELEPHONE = "ru_RU.UTF-8";
    LC_TIME = "ru_RU.UTF-8";
  };

  # PipeWire
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.netbird.enable = true;

  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      default-address-pools = [
        {
          base = "10.201.0.0/16";
          size = 24;
        }
      ];
    };
  };

  # Docker copies the host's /etc/resolv.conf into containers when they start.
  # network-online.target is not enough here: nm-online -s returns when NetworkManager has
  # started, before Wi-Fi is connected (2026-11-18: docker at 8.36 s, Wi-Fi after it), and the
  # containers came up with no nameservers. Wait for a nameserver, at most 60 s, then start anyway.
  systemd.services.docker.serviceConfig.ExecStartPre = [
    (pkgs.writeShellScript "docker-wait-dns" ''
      for _ in $(${pkgs.coreutils}/bin/seq 60); do
        ${pkgs.gnugrep}/bin/grep -q '^nameserver' /etc/resolv.conf && exit 0
        ${pkgs.coreutils}/bin/sleep 1
      done
      echo "no nameserver after 60 s, starting docker anyway"
    '')
  ];

  # Udev rules for the keyboard
  services.udev.extraRules = ''
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="4c4b", ATTRS{idProduct}=="4643", MODE="0666", TAG+="uaccess"
  '';
}
