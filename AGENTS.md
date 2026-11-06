# os-config

You configure Kirill's working machine: NixOS, niri, neovim, the terminal. Your job is a configuration that is a pleasure to use every day: minimal, fast, driven from the keyboard. The repository is public and reads as a showcase.

Commands are in `README.md`. Layout: `nixos/` is the system, `home/` is the stow package for `~`, `secrets/` holds ignored secrets.

Talk to Kirill in Russian. Write commits and repository text in English.

## What we aim for

- **Minimalism.** Fewer packages, modules and lines. Before adding something, check that what is installed cannot already do it. New tools replace old ones rather than sit next to them.
- **Convenience over looks.** A frequent action is one key combination. The mouse is never required.
- **CLI and TUI over GUI.** Suggest a terminal tool when it is no worse: pick one that is simple, maintained and has sensible defaults.
- **Consistent hotkeys.** Vim motion `hjkl` wherever possible. A new binding does not clash with existing ones and goes into `README.md`.
- **Declarative.** Everything that can be is described in the repository and reproducible on a new machine. There are no manual steps, or they are in `README.md`.
- **Speak up.** If a setting can be simpler or a routine can become a hotkey, say so.

## How to work

- Before changing the system, evaluate the configuration and compare it with the running one:
  `nix eval --raw './nixos#nixosConfigurations.nixos.config.system.build.toplevel.outPath'` and `readlink -f /run/current-system`. A refactor does not change the path.
- Check a build without applying it: `nixos-rebuild build --flake ./nixos --no-link`. The niri configuration: `niri validate`.
- Run `git add` on a new file in `nixos/` first: a flake only sees files known to git.
- Kirill applies changes: `sudo nixos-rebuild switch`; for a risky change, `sudo nixos-rebuild test` first.
- Commits: Conventional Commits in English. Kirill pushes.
- Before every commit, run `git status`: only the files you changed.

## Boundaries

- No secrets, tokens or work addresses in git or in `.nix` files: the repository is public and `/nix/store` is world-readable. Secrets live in `secrets/`; do not read the values.
- Do not disable the sudo password: a rebuild without it would give root to any process.
- Do not change `system.stateVersion`.
- The Cinnamon session stays as the fallback until Kirill decides otherwise. A change that prevents logging in is the most expensive mistake.
- Changing the display manager, bootloader or partitioning happens only on Kirill's word and through `test`.

## Open

Check live under niri: login from LightDM, the clipboard between X11 and Wayland, screen sharing, the handbinder preview.
