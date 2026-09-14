{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.android_sdk.accept_license = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; 
  # networking.proxy.default = "http://login:pass@x.x.x.x:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Moscow";

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

  services.xserver.enable = true;

  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.cinnamon.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    #jack.enable = true;
    #media-session.enable = true;
  };

  # services.xserver.libinput.enable = true;

  services.netbird.enable = true;


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."breakdown" = {
    isNormalUser = true;
    description = "breakdown";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  programs.firefox.enable = true;

  environment.variables = {
    NB_MANAGEMENT_URL = "https://vpn.example.com:443";
  };

  environment.etc."profile.d/load-user-profile.sh" = {
    text = ''
      # Загружаем .profile из домашней папки пользователя
      # Это работает для всех пользователей, но загружает их собственный .profile
      if [ -f "$HOME/.profile" ]; then
        # Используем set -a чтобы экспортировать все переменные
        set -a
        source "$HOME/.profile"
        set +a
      fi
    '';
    mode = "0755";
  };

  virtualisation.docker.enable = true;


  environment.systemPackages = with pkgs; [
    xclip
    stylua
    wget
    neovim
    git
    vivaldi
    chromium
    android-studio
    android-tools
    androidenv.androidPkgs.androidsdk
    androidenv.androidPkgs.emulator
    androidenv.androidPkgs.ndk-bundle
    jdk
    netbird-ui
    telegram-desktop
    obsidian
    godot
    stow
    clang
    uv
    python3
    ruff
    ty
    k3d
    kubectl
    tree
    gettext
  ];

  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  system.stateVersion = "26.05"; # Did you read the comment?

}
