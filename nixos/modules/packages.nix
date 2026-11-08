{ config, pkgs, ... }:

let
  # Godot export templates must match the engine version
  godot-templates = pkgs.godot.export-templates-bin;
  godot-templates-dir = builtins.replaceStrings [ "-" ] [ "." ] godot-templates.version;
in
{
  # Godot looks for templates only in ~/.local/share/godot/export_templates/<version>
  systemd.tmpfiles.rules = [
    "d ${config.users.users.breakdown.home}/.local/share/godot 0755 breakdown users -"
    "d ${config.users.users.breakdown.home}/.local/share/godot/export_templates 0755 breakdown users -"
    "L+ ${config.users.users.breakdown.home}/.local/share/godot/export_templates/${godot-templates-dir} - - - - ${godot-templates}/share/godot/export_templates/${godot-templates-dir}"
  ];

  environment.systemPackages = with pkgs; [
    xclip
    stylua
    wget
    tree-sitter
    lua-language-server
    fzf
    ripgrep
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
    godot
  ];
}
