# os-config

Конфигурация моей NixOS и домашние настройки: один репозиторий на всю машину.

- `nixos/` — система: flake, модули, `flake.lock`.
- `home/` — stow-пакет, содержимое ложится в `~`: neovim, niri, waybar.
- `secrets/` — секреты проектов, в git только образец.

## Команды

### Применить конфиг

```bash
sudo nixos-rebuild switch
```

### Попробовать без закрепления

После перезагрузки система вернётся к прошлой версии.

```bash
sudo nixos-rebuild test
```

### Вернуть прошлую версию

```bash
sudo nixos-rebuild switch --rollback
```

### Обновить пакеты

Затем примени конфиг.

```bash
nix flake update --flake ~/os-config/nixos
```

### Разложить настройки из home/

```bash
stow -d ~/os-config -t ~ home
```

### Проверить конфиг niri

```bash
niri validate
```

Новый файл в `nixos/` сначала `git add`: flake видит только файлы, известные git.

## niri

Рядом с Cinnamon: сессия выбирается на экране входа, по умолчанию остаётся Cinnamon.

| Клавиши | Действие |
|---|---|
| `Mod+Shift+/` | все клавиши |
| `Mod+Return` | терминал |
| `Mod+D` | запуск программ |
| `Mod+H/J/K/L` | фокус |
| `Mod+Shift+H/J/K/L` | перенос окна |
| `Mod+1..5` | рабочие столы |
| `Mod+O` | обзор |
| `Mod+R` / `Mod+F` | ширина колонки / на весь экран |
| `Mod+Q` | закрыть окно |
| `Ctrl+Space` | раскладка |
| `Print` | скриншот области |
| `Mod+Alt+L` | блокировка |
| `Mod+Shift+E` | выход из сессии |

Правки `home/.config/niri/config.kdl` применяются сразу.

## Новая машина

### 1. Склонировать репозиторий

```bash
git clone git@github.com:Breakdown08/os-config.git ~/os-config
```

### 2. Сверить железо

Сравни вывод с `nixos/modules/hardware-configuration.nix`.

```bash
nixos-generate-config --show-hardware-config
```

### 3. Указать flake

```bash
sudo ln -sf ~/os-config/nixos/flake.nix /etc/nixos/flake.nix
```

### 4. Собрать систему

```bash
sudo nixos-rebuild switch
```

### 5. Разложить настройки

```bash
stow -d ~/os-config -t ~ home
```

## Секреты

В `.nix`-файлы секреты не класть: всё оттуда попадает в `/nix/store`, открытый на чтение всем пользователям. Переменные будут доступны только внутри проекта.

### 1. Создать файл

```bash
cp ~/os-config/secrets/example.env ~/os-config/secrets/<проект>.env
```

### 2. Подключить к проекту

Выполни в папке проекта.

```bash
echo 'dotenv ~/os-config/secrets/<проект>.env' >> .envrc
```

### 3. Разрешить

```bash
direnv allow
```
