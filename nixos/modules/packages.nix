{ config, pkgs, ... }:

let
  # Godot export templates must match the engine version
  godot-templates = pkgs.godot.export-templates-bin;
  godot-templates-dir = builtins.replaceStrings [ "-" ] [ "." ] godot-templates.version;
  home = config.users.users.breakdown.home;
  # The SDK godot-mono wraps: one SDK for the editor and for dotnet build
  dotnet-sdk = pkgs.dotnetCorePackages.sdk_8_0-source;
  # Playwright cannot download browsers on NixOS; take the ones built for its driver
  playwright-browsers-unwrapped = pkgs.playwright-driver.browsers.override {
    withFirefox = false;
    withWebkit = false;
    withFfmpeg = false;
  };
  # Under WAYLAND_DISPLAY, ANGLE asks SwiftShader for a Wayland surface it lacks and headless WebGL dies
  playwright-browsers =
    pkgs.runCommand "playwright-browsers" { nativeBuildInputs = [ pkgs.makeWrapper ]; }
      ''
        mkdir $out
        for entry in ${playwright-browsers-unwrapped}/*; do
          ln -s "$(readlink -f "$entry")" "$out/$(basename "$entry")"
        done
        for dir in $out/chromium_headless_shell-*; do
          src=$(readlink -f "$dir")
          rm "$dir"
          cp -rs "$src" "$dir"
          chmod -R u+w "$dir"
          shell="$dir/chrome-headless-shell-linux64/chrome-headless-shell"
          rm "$shell"
          makeWrapper "$src/chrome-headless-shell-linux64/chrome-headless-shell" "$shell" --unset WAYLAND_DISPLAY
        done
      '';
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

  environment.sessionVariables = {
    PLAYWRIGHT_BROWSERS_PATH = "${playwright-browsers}";
    PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";
    # Godot .NET finds hostfxr through DOTNET_ROOT
    DOTNET_ROOT = "${dotnet-sdk}/share/dotnet";
    DOTNET_CLI_TELEMETRY_OPTOUT = "1";
  };

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
    (python3.withPackages (ps: [ ps.playwright ]))
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
    godot-mono
    dotnet-sdk
    gdscript-formatter
    butler
  ];
}
