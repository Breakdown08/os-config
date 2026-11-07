{ config, pkgs, pkgs-godot, ... }:

let
  # Godot export templates, from the same pin as the engine: the versions must match
  godot-templates = pkgs-godot.godot_4_5.export-templates-bin;
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
    neovim
    tree-sitter
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
    # Godot 4.5.1 from the pinned commit
    pkgs-godot.godot_4_5
  ];
}
