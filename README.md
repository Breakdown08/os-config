# os-config

My NixOS configuration and home settings: one repository for the whole machine.

- `nixos/` — the system: flake, modules, `flake.lock`.
- `home/` — a stow package installed into `~`: kitty, mako, neovim, niri, waybar.
- `secrets/` — per-project secrets; only the template is in git.

## Commands

### Apply the configuration

```bash
sudo nixos-rebuild switch
```

### Try it without keeping it

The system returns to the previous version after a reboot.

```bash
sudo nixos-rebuild test
```

### Roll back to the previous version

```bash
sudo nixos-rebuild switch --rollback
```

### Update packages

Then apply the configuration.

```bash
nix flake update --flake ~/os-config/nixos
```

### Delete old generations

Keeps only the running system and removes the others from the boot menu. Rolling back is no longer possible.

```bash
nixos-clean
```

### Install the settings from home/

```bash
stow -d ~/os-config -t ~ home
```

### Check the niri configuration

```bash
niri validate
```

Run `git add` on any new file in `nixos/` first: a flake only sees files known to git.

## niri

The default session. Cinnamon stays as the fallback: pick it on the login screen.

| Keys | Action |
|---|---|
| `Mod+/` | all keys |
| `Mod+Return` | terminal |
| `Mod+D` | app launcher |
| `Mod+H/J/K/L` | move focus |
| `Mod+Shift+H/J/K/L` | move window |
| `Mod+1..5` | workspaces |
| `Mod+O` | overview |
| `Mod+R` / `Mod+F` | column width / maximize |
| `Mod+Q` | close window |
| `Ctrl+Space` | keyboard layout |
| `Mod+N` / `Mod+Shift+N` | do not disturb / dismiss notifications |
| `Print` | screenshot of an area |
| `Mod+Alt+L` | lock |
| `Mod+Shift+E` | power menu: power off, reboot, log out |

Notifications pop up one at a time for five seconds. The bell on waybar counts them: click toggles do not disturb, right click dismisses all.

Edits to `home/.config/niri/config.kdl` apply immediately.

## kitty

`Ctrl+Shift+Enter` opens a window next to the current one, in the same directory.

## Neovim

Plugins are managed by the built-in `vim.pack`: the first start installs them at the revisions in `nvim-pack-lock.json`, `:lua vim.pack.update()` updates them.

Leader is `Space`. LSP uses the Nvim defaults: `grn` rename, `grr` references, `gri` implementation, `gra` code action, `K` hover.

| Keys | Action |
|---|---|
| `Space f` / `Space g` | find a file / search the project |
| `Space Space` | switch buffer |
| `Space d` | diagnostics in the file |
| `Space k` / `Space h` | search mappings / help |
| `Space r` | resume the last search |
| `Tab` | file explorer: edit the directory, save with `:w` |
| `Space [` / `Space ]` | explorer in the Neovim config / project root |
| `Ctrl+H/J/K/L` | move between windows |
| `Ctrl+Q` | close window |
| `gd` | go to definition |
| `van` / `in` | grow / shrink the selection by syntax node |
| `af` `if` `ac` `ic` `aa` `ia` | function, class, argument text objects |
| `]m` `[m` / `]]` `[[` | next / previous function / class |
| `Space a` / `Space A` | swap the argument with the next / previous one |
| `Space b` | build the C file |

## New machine

### 1. Clone the repository

```bash
git clone git@github.com:Breakdown08/os-config.git ~/os-config
```

### 2. Compare the hardware

Compare the output with `nixos/modules/hardware-configuration.nix`.

```bash
nixos-generate-config --show-hardware-config
```

### 3. Point the system at the flake

```bash
sudo ln -sf ~/os-config/nixos/flake.nix /etc/nixos/flake.nix
```

### 4. Build the system

```bash
sudo nixos-rebuild switch
```

### 5. Install the settings

```bash
stow -d ~/os-config -t ~ home
```

## Secrets

Never put secrets in `.nix` files: everything there lands in `/nix/store`, readable by all users. The variables are available only inside the project.

### 1. Create the file

```bash
cp ~/os-config/secrets/example.env ~/os-config/secrets/<project>.env
```

### 2. Connect it to the project

Run this in the project folder.

```bash
echo 'dotenv ~/os-config/secrets/<project>.env' >> .envrc
```

### 3. Allow it

```bash
direnv allow
```
