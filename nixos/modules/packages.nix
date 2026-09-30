{ config, pkgs, pkgs-godot, ... }:

{
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
    vial
    qmk-udev-rules
    usbutils
    nix-index
    kitty
    tigervnc
    transmission_4-gtk
  ] ++ [
    # Godot 4.5.1 из зафиксированного коммита
    pkgs-godot.godot_4_5
  ];
}
