{ config, pkgs, ... }:

let
  # Godot export templates must match the engine version
  godot-templates = pkgs.godot.export-templates-bin;
  godot-templates-dir = builtins.replaceStrings [ "-" ] [ "." ] godot-templates.version;
  home = config.users.users.breakdown.home;
in
{
  systemd.tmpfiles.rules = [
    # gh and butler keep their tokens here: readable only by the user
    "d ${home}/.config/gh 0700 breakdown users -"
    "d ${home}/.config/itch 0700 breakdown users -"
    # Godot looks for templates only in ~/.local/share/godot/export_templates/<version>
    "d ${home}/.local/share/godot 0755 breakdown users -"
    "d ${home}/.local/share/godot/export_templates 0755 breakdown users -"
    "L+ ${home}/.local/share/godot/export_templates/${godot-templates-dir} - - - - ${godot-templates}/share/godot/export_templates/${godot-templates-dir}"
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
    gh
    vivaldi
    chromium
    android-studio
    android-tools
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
    alsa-utils
    nix-index
    kitty
    tigervnc
    transmission_4-gtk
    godot
    gdscript-formatter
    butler
  ];
}
