# os-config

Конфигурация моей NixOS и домашние настройки: один репозиторий на всю машину.

- `nixos/` — система: flake, модули, `flake.lock`.
- `home/` — stow-пакет, содержимое ложится в `~`: сейчас neovim.
- `secrets/` — секреты проектов, в git только образец.

## Команды

```bash
sudo nixos-rebuild switch             # применить конфиг
sudo nixos-rebuild test               # попробовать, после перезагрузки откатится
sudo nixos-rebuild switch --rollback  # вернуть прошлую версию
nix flake update --flake ~/os-config/nixos  # обновить пакеты, затем switch
stow -d ~/os-config -t ~ home         # разложить настройки из home/
```

Новый файл в `nixos/` сначала `git add`: flake видит только файлы, известные git.

## Новая машина

```bash
git clone git@github.com:Breakdown08/os-config.git ~/os-config
sudo ln -sf ~/os-config/nixos/flake.nix /etc/nixos/flake.nix
sudo nixos-rebuild switch
stow -d ~/os-config -t ~ home
```

Перед первой сборкой сверь `nixos/modules/hardware-configuration.nix` с новым железом: `nixos-generate-config --show-hardware-config`.

## Секреты

Файл `secrets/<проект>.env` по образцу `secrets/example.env`, в `.envrc` проекта:

```bash
dotenv ~/os-config/secrets/<проект>.env
```

Затем `direnv allow`: переменные есть только внутри этого проекта. В `.nix`-файлы секреты не класть, всё оттуда попадает в `/nix/store`, открытый на чтение всем пользователям.
