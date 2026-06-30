# LinuxMintHyprlandConfig

A personal dotfile suite for debian | arch | fedora — Hyprland  setups
Its dark, minimal, and opinionated. Ships with a full installer that handles symlinks, backups, packages, and optional apps across Debian, Arch, and Fedora based systems.

---
> [!CAUTION]
> **Check Hyprland support for your distro version BEFORE installing.**
> Running this on an unsupported distro version will waste your time —
> packages won't exist, dependencies will conflict, and the install will fail halfway through.
>
> Verified working:
> - **Arch** — always up to date, no version concerns
> - **Fedora [ 40, 41, 42 ]** — supported via `solopasha/hyprland` COPR
> - **Fedora [ 43, 44+ ]** — ⚠ COPR not updated yet, Hyprland will fail to install
> - **Linux Mint [ 21 / 22 ]** — supported via JaKooLit's script
> - **Ubuntu [ 22.04 / 24.04 ]** — supported via JaKooLit's script
>
> Before installing on Fedora, check if your version is supported:
> [solopasha/hyprland COPR](https://copr.fedorainfracloud.org/coprs/solopasha/hyprland/)
>
> Before installing on Debian/Mint, check JaKooLit has a branch for your base version:
> [JaKooLit/Ubuntu-Hyprland branches](https://github.com/JaKooLit/Ubuntu-Hyprland/branches)

> [!WARNING]
> **Do not run as root.** Symlinks will be created owned by root inside your home directory.
> Run as your normal user — `sudo` is invoked internally only where needed.

> [!NOTE]
> Recommended to run this **after** Hyprland is already installed and you are inside a Hyprland session.
> On **Debian/Mint**, Hyprland is not installed by this script — see the [Installing Hyprland](#installing-hyprland-on-linux-mint) section first.
> On **Arch** and **Fedora**, Hyprland is installed automatically by the script.
---

# Preview

![Preview 1](previewimage.png)

---

![Preview 2](previewimage2.png)

---

![Preview 3](previewimage3.png)

---

# Installing Hyprland on Linux Mint

> Skip this section if you are on Arch or Fedora — the install script handles Hyprland for those distros automatically.

<details>
<summary><b>Click to expand — Debian / Linux Mint installation steps</b></summary>

This guide covers installing Hyprland on Linux Mint using JaKooLit's automated script.

> [!NOTE]
> **Credits:** This setup uses scripts maintained by **JaKooLit**.
> Consider starring the original repo to support the developer.
>
> **Original Repository:** [JaKooLit/Ubuntu-Hyprland](https://github.com/JaKooLit/Ubuntu-Hyprland)

---

### Step 1 — Prepare Dependencies

```bash
sudo apt update && sudo apt upgrade -y
sudo apt install git make cmake -y
```

### Step 2 — Identify Your Mint Version Base

Linux Mint is built on top of Ubuntu LTS — clone the branch that matches:

- **Linux Mint 22** → Ubuntu 24.04 base → use branch `24.04`
- **Linux Mint 21 / 21.1 / 21.2 / 21.3** → Ubuntu 22.04 base → use branch `22.04`

### Step 3 — Clone the Correct Branch

**Mint 22:**
```bash
cd ~
git clone -b 24.04 --depth 1 https://github.com/JaKooLit/Ubuntu-Hyprland.git
```

**Mint 21:**
```bash
cd ~
git clone -b 22.04 --depth 1 https://github.com/JaKooLit/Ubuntu-Hyprland.git
```

### Step 4 — Run the Installer

```bash
cd Ubuntu-Hyprland
chmod +x install.sh
./install.sh
```

### Step 5 — Follow Prompts and Reboot

1. Enter your `sudo` password when prompted
2. Select options matching your hardware — pay attention if you are on **Nvidia**
3. Reboot once complete

### Step 6 — Log Into Hyprland

1. On the login screen, select your username
2. Click the session icon (small gear near the password field)
3. Select **Hyprland** from the list
4. Log in

---

**Resources**
- [JaKooLit Ubuntu-Hyprland Repository](https://github.com/JaKooLit/Ubuntu-Hyprland)

</details>

---

# Installation

## Quick Start

```bash
# 1. Clone the repository
git clone https://github.com/yourusername/LinuxMintHyprlandConfig.git
cd LinuxMintHyprlandConfig

# 2. Make executable
chmod +x install.sh

# 3. Run with your distro flag
./install.sh --debian     # Debian / Ubuntu / Linux Mint
./install.sh --arch       # Arch 
./install.sh --fedora     # Fedora
```

## Install Script Flags

| Flag | Short | Description |
|---|---|---|
| `--help` | `-h` | Show usage and exit |
| `--restore` | `-r` | Remove symlinks and restore backed up configs |
| `--update` | `-u` | Pull latest changes and re-apply symlinks |
| `--yes-optional` | `-y` | Automaticaly installs optional app no [y/n] |
| `--no-optional` | `-n` | Skip optional app installs |
| `--debian` | `-d` | Install for Debian / Ubuntu / Linux Mint (apt) |
| `--arch` | `-a` | Install for Arch (pacman + yay) |
| `--fedora` | `-f` | Install for Fedora (dnf + COPR) |

**Examples:**
```bash
# install on Arch, skip optional apps
./install.sh --no-optional --arch 

# install on Arch, install all optional apps
./install.sh --yes-optional --arch

# restore original configs
./install.sh --restore

# update after new changes
updateproject --update
```

## What the Installer Does

In order:

1. Checks you are in the correct directory and running on the right distro
2. Writes `DOTFILE_SYSTEM=<distro>` to `~/.bashrc` for use by `updateproject`
3. Installs system packages via your distro's package manager
4. Copies the repo to `~/.local/share/LinuxMintHyprlandConfig/` (permanent home)
5. Adds current user to `i2c` group for DDC-CI brightness control
6. Backs up any existing configs from `~/.config/` to a timestamped backup folder
7. Creates symlinks in `~/.config/` pointing to the repo configs
8. Creates symlinks in `~/.local/bin/` pointing to the custom scripts
9. Appends environment variables and PATH exports to `~/.bashrc`
10. Applies the GTK theme via `gsettings` / `xfconf-query` based on your desktop session
11. Optionally prompts to install: Hyprshot, Walk, Obsidian, Zen Browser, VSCode
12. Optionally symlinks `install.sh` as `updateproject` in `~/.local/bin`

## After Install Checklist

```bash
# 1. Source your shell in the current terminal
source ~/.bashrc

# 2. Verify commands are reachable
which custombrightnessctl
which updateproject

# 3. Log out and back into Hyprland
#    configs are symlinked but Hyprland needs a fresh session to pick them up

# 4. i2c group (for brightness) takes effect after re-login
groups | grep i2c
```

---

# Distro Notes

## Debian / Ubuntu / Linux Mint

Hyprland is **not** installed by this script on Debian-based systems — too many version and hardware variables to automate reliably. Install it first via [JaKooLit's script](#installing-hyprland-on-linux-mint), then run this installer.

Packages installed via `apt`:
`git` `ddcutil` `btop` `htop` `libnotify-bin` `pavucontrol` `wireplumber` `pipewire` `playerctl` `wofi` `swaybg` `alacritty` `evince` `xed` `nemo` `mpv` `curl`

## Arch 

Hyprland and all related Wayland packages are installed via `pacman`. AUR packages (Obsidian, VSCode) require `yay` — the script installs it automatically if not found.

Packages installed via `pacman`:
`git` `ddcutil` `btop` `htop` `libnotify` `pavucontrol` `wireplumber` `pipewire` `pipewire-pulse` `playerctl` `wofi` `swaybg` `alacritty` `evince` `gedit` `nemo` `mpv` `curl` `hyprland` `hyprlock` `hypridle` `hyprpaper` `waybar` `swaync` `polkit-gnome` `xdg-desktop-portal-hyprland` `uwsm`

## Fedora

The installer enables the `solopasha/hyprland` COPR repository automatically before installing packages. You will be prompted to confirm this by dnf.

Packages installed via `dnf`:
`git` `ddcutil` `btop` `htop` `libnotify` `pavucontrol` `wireplumber` `pipewire` `pipewire-pulse` `playerctl` `wofi` `swaybg` `alacritty` `evince` `xed` `nemo` `mpv` `curl` `hyprland` `hyprlock` `hypridle` `hyprpaper` `waybar` `SwayNotificationCenter` `polkit-gnome` `xdg-desktop-portal-hyprland` `uwsm`

---

# Updating

After install, the script optionally symlinks itself as `updateproject` into `~/.local/bin` — so you can update the dotfiles at any time without needing the original cloned repo.

```bash
updateproject --update
```

This will:
1. `git pull` the latest changes from `~/.local/share/LinuxMintHyprlandConfig/`
2. Re-run the full install for your distro — asking user for updating optional apps and take the confirmation prompt
3. Re-apply all symlinks to pick up any new config files added in the update

> [!NOTE]
> `updateproject` reads `$DOTFILE_SYSTEM` from your environment to know which distro installer to call.
> This variable is written to `~/.bashrc` automatically during first install.
> If the command fails with "DOTFILE_SYSTEM not set", run `source ~/.bashrc` first and try again.

---

# Restoring

To undo the installation — remove all symlinks and restore your original configs:

```bash
./install.sh --restore
# or if updateproject is set up:
updateproject --restore
```

This will:
1. Remove all symlinks from `~/.config/` and `~/.local/bin/`
2. Move your original config folders back from the backup to `~/.config/`
3. Print the manual uninstall command for packages

> [!NOTE]
> Installed packages and applications are **not** removed automatically.
> The restore output will print the exact command to remove them for your distro.

**Backup location:**
```
~/.local/share/LinuxMintHyprlandConfig/backupConfigs/backup_<YYYYMMDD_HHMMSS>/
```
Multiple backups are kept. `--restore` always uses the most recent one.

---

# Repository Structure

All configs, scripts, and themes live in a single directory and are linked to their target locations via symlinks — nothing is duplicated outside the repo.

```
LinuxMintHyprlandConfig/
├── bin/                              # Custom scripts (→ ~/.local/bin/)
│   ├── custombrightnessctl.sh       # DDC-CI brightness control via ddcutil
│   ├── custombtoplauncher.sh        # Custom btop terminal launcher
│   ├── customhyprlandexit.sh        # Hyprland session exit handler
│   ├── customlinkopenr.sh           # Open URLs from keybind
│   ├── customwofisearch.sh          # Wofi search launcher
│   └── startup.sh                   # Exec-once startup script
├── config/                          # App configs (→ ~/.config/)
│   ├── hypr/                        # Hyprland compositor
│   │   ├── hyprland.conf            # Main config
│   │   ├── hypridle.conf            # Idle and screen lock behavior
│   │   ├── hyprlock.conf            # Lock screen config
│   │   ├── webappsbinds.conf        # Web app keybindings
│   │   └── workspace.conf           # Workspace and monitor setup
│   ├── waybar/                      # Status bar
│   │   ├── config.jsonc
│   │   └── style.css
│   ├── wofi/                        # App launcher
│   │   ├── config
│   │   ├── style.css
│   │   └── SearchBarStyle.css
│   ├── btop/                        # System monitor
│   │   ├── btop.conf
│   │   └── theme/
│   └── swaync/                      # Notification daemon
├── theme/                           # Theming
│   ├── gtkThemes/
│   │   └── Graphite-Dark/           # GTK theme (→ ~/.themes/)
│   └── Obsidian/
│       └── pitchBlack/              # Obsidian theme (manual install)
├── wallpaper/                       # Desktop wallpapers
├── backupConfigs/                   # Created on install — timestamped backups of original configs
├── bashAppend.sh                    # Appended to ~/.bashrc on install
├── install.sh                       # Main installer (also symlinked as updateproject)
└── README.md
```

## What Gets Symlinked

| Source                           | Target                                 | Notes                              |
| -------------------------------- | -------------------------------------- | ---------------------------------- |
| `config/hypr/`                   | `~/.config/hypr`                       | Entire folder symlinked            |
| `config/waybar/`                 | `~/.config/waybar`                     | Entire folder symlinked            |
| `config/wofi/`                   | `~/.config/wofi`                       | Entire folder symlinked            |
| `config/btop/`                   | `~/.config/btop`                       | Entire folder symlinked            |
| `config/swaync/`                 | `~/.config/swaync`                     | Entire folder symlinked            |
| `config/alacritty/`              | `~/.config/alacritty`                  | Entire folder symlinked            |
| `theme/gtkThemes/Graphite-Dark/` | `~/.themes/Graphite-Dark`              | Theme folder symlinked             |
| `bin/custombrightnessctl.sh`     | `~/.local/bin/custombrightnessctl`     | Individual binary symlink          |
| `bin/custombtoplauncher.sh`      | `~/.local/bin/custombtoplauncher`      | Individual binary symlink          |
| `bin/customhyprlandexit.sh`      | `~/.local/bin/customhyprlandexit`      | Individual binary symlink          |
| `bin/customlinkopenr.sh`         | `~/.local/bin/customlinkopenr`         | Individual binary symlink          |
| `bin/customwofisearch.sh`        | `~/.local/bin/customwofisearch`        | Individual binary symlink          |
| `bin/customwallpaperswitcher.sh` | `~/.local/bin/customwallpaperswitcher` | Individual binary symlink          |
| `install.sh`                     | `~/.local/bin/updateproject`           | Optional — prompted during install |

---

# GTK Theme

The **Graphite-Dark** GTK theme is bundled in this repo and applied automatically during install. It works across Hyprland, GNOME, Cinnamon, and XFCE sessions.

## Manual Application

```bash
mkdir -p ~/.themes
cp -r ./theme/gtkThemes/Graphite-Dark ~/.themes/
```

**Via command line (pick your desktop):**
```bash
# Hyprland / GNOME
gsettings set org.gnome.desktop.interface gtk-theme "Graphite-Dark"

# Cinnamon (Linux Mint default)
gsettings set org.cinnamon.desktop.interface gtk-theme "Graphite-Dark"

# XFCE
xfconf-query -c xsettings -p /Net/ThemeName -s "Graphite-Dark"
```

**Via Linux Mint GUI:**
System Settings → Appearance → Themes → select **Graphite-Dark**

## Troubleshooting

**Theme applied in gsettings but not showing:**
```bash
# log out and back in — Hyprland needs a fresh session
# verify gsettings actually has the value
gsettings get org.gnome.desktop.interface gtk-theme
```

**Reverting to default:**
```bash
gsettings reset org.gnome.desktop.interface gtk-theme
gsettings reset org.cinnamon.desktop.interface gtk-theme
```

---

# Wallpapers

<details>
  <summary>Wallpaper 1 — Full Blank Background</summary>
  <br>
  <img src="wallpaper/wall1.png" alt="Wallpaper 1" width="100%">
</details>

<details>
  <summary>Wallpaper 2 — Dark Ocean Current</summary>
  <br>
  <img src="wallpaper/wall2.png" alt="Wallpaper 2" width="100%">
</details>

<details>
  <summary>Wallpaper 3 — Classic Nokia Handshake</summary>
  <br>
  <img src="wallpaper/wall3.png" alt="Wallpaper 3" width="100%">
</details>

<details>
  <summary>Wallpaper 4 — Solo Rei Ayanami</summary>
  <br>
  <img src="wallpaper/wall4.png" alt="Wallpaper 4" width="100%">
</details>

<details>
  <summary>Wallpaper 5 — Rei and Asuka Manga Version</summary>
  <br>
  <img src="wallpaper/wall5.png" alt="Wallpaper 5" width="100%">
</details>

---

# Hyprshot

Screenshot utility integrated via keybindings.

| Keybinding | Action |
|---|---|
| `Print` | Capture current monitor |
| `Super + Print` | Capture active window |
| `Shift + Print` | Capture region (drag to select) |

Screenshots are saved to `~/Pictures/Screenshots/` by default.

## Installation

The install script prompts automatically. Select **1** to auto-install.

### Manual Installation

```bash
git clone https://github.com/Gustash/hyprshot.git ~/Hyprshot
chmod +x ~/Hyprshot/hyprshot
mkdir -p ~/.local/bin
ln -s ~/Hyprshot/hyprshot ~/.local/bin/hyprshot
hyprshot --help
```

## Usage

```bash
hyprshot -m output                  # capture monitor
hyprshot -m window                  # capture window
hyprshot -m region                  # capture region
hyprshot -m region -o ~/custom.png  # save to custom path
```

## Uninstalling

```bash
rm ~/.local/bin/hyprshot
rm -rf ~/Hyprshot
```

**Resources:** [Hyprshot Repository](https://github.com/Gustash/hyprshot) · [Hyprland Bindings Wiki](https://wiki.hyprland.org/Configuring/Binds/)

---

# Walk

Minimal terminal file manager — navigate your filesystem interactively and `cd` directly into directories.

## Installation

The install script prompts automatically. Select **1** to auto-install.

The script clones `~/walk` and runs its bundled `install.sh` which handles the build and binary placement.

### Manual Installation

```bash
git clone https://github.com/antonmedv/walk.git ~/walk
chmod +x ~/walk/install.sh
bash ~/walk/install.sh
walk --help
```

## Usage

```bash
walk            # browse current directory
walk ~/docs     # browse a specific path
cd $(walk)      # navigate and cd into selected directory
```

## Uninstalling

```bash
rm -rf ~/walk
which walk && rm "$(which walk)"
```

**Resources:** [Walk Repository](https://github.com/antonmedv/walk)

---

# Obsidian

Note-taking app — not available in standard repos. The script fetches the latest `.deb` / `.rpm` from GitHub releases and installs via your package manager.

A **Pitch Black** Obsidian theme is also bundled in this repo under `theme/Obsidian/pitchBlack/`.

## What the Install Script Does

1. Checks if `obsidian` is already installed — skips if found
2. Fetches the latest version from the GitHub API
3. Downloads the appropriate package to `/tmp/`
4. Installs via `apt` / `dnf` / AUR (`yay`)
5. Cleans up the package file from `/tmp/`

## Installation

The install script prompts automatically. Select **1** to auto-install.

### Manual Installation

```bash
# Debian/Ubuntu/Mint — replace version number
curl -L https://github.com/obsidianmd/obsidian-releases/releases/download/v1.5.12/obsidian_1.5.12_amd64.deb \
    -o /tmp/obsidian.deb
sudo apt install -y /tmp/obsidian.deb
rm /tmp/obsidian.deb
```

## Applying the Bundled Pitch Black Theme

```bash
# replace YourVault with your actual vault folder name
mkdir -p ~/YourVault/.obsidian/themes/
cp -r ~/.local/share/LinuxMintHyprlandConfig/theme/Obsidian/pitchBlack \
    ~/YourVault/.obsidian/themes/
```

Then inside Obsidian: **Settings → Appearance → Themes** → select **Pitch Black**.

## Uninstalling

```bash
sudo apt remove obsidian       # Debian
sudo dnf remove obsidian       # Fedora
yay -Rns obsidian              # Arch
```

**Resources:** [Obsidian Download](https://obsidian.md/download) · [GitHub Releases](https://github.com/obsidianmd/obsidian-releases/releases)

---

# Zen Browser

Firefox-based browser with a minimal, distraction-free UI. Not in standard repos — the script downloads and extracts the official tarball.

> [!NOTE]
> Zen lives at `~/zen-browser/`. Do not delete this folder — `~/.local/bin/zen` symlinks directly to the binary inside it.
> On Arch, `yay` installs `zen-browser-bin` from the AUR instead, which handles updates automatically.

## What the Install Script Does

1. Checks if `zen` is already installed — skips if found
2. **Arch:** installs `zen-browser-bin` via `yay`
3. **Debian/Fedora:** downloads `zen.linux-x86_64.tar.xz` from GitHub to `/tmp/`
4. Extracts to `~/zen-browser/`
5. Symlinks `~/zen-browser/zen` → `~/.local/bin/zen`
6. Cleans up the tarball

## Installation

The install script prompts automatically. Select **1** to auto-install.

### Manual Installation

```bash
curl -L https://github.com/zen-browser/desktop/releases/latest/download/zen.linux-x86_64.tar.xz \
    -o /tmp/zen.tar.xz
mkdir -p ~/zen-browser
tar -xf /tmp/zen.tar.xz -C ~/zen-browser --strip-components=1
ln -sfn ~/zen-browser/zen ~/.local/bin/zen
rm /tmp/zen.tar.xz
zen --version
```

## Troubleshooting

```bash
ls -la ~/.local/bin/zen        # check symlink exists
ls -la ~/zen-browser/zen       # check binary exists
echo $PATH | grep .local/bin   # check PATH

# missing dependencies
sudo apt install libgtk-3-0 libdbus-glib-1-2
```

## Uninstalling

```bash
rm ~/.local/bin/zen
rm -rf ~/zen-browser
```

**Resources:** [Zen Browser GitHub](https://github.com/zen-browser/desktop) · [Zen Browser Website](https://zen-browser.app)

---

# VSCode

Not in standard repos by default. The script downloads the latest stable `.deb` / `.rpm` directly from Microsoft and installs it via your package manager. The **Pitch Black** theme extension is also installed automatically.

## What the Install Script Does

1. Checks if `code` is already installed — skips if found
2. **Arch:** installs `visual-studio-code-bin` via `yay`
3. **Debian/Fedora:** downloads latest stable package from Microsoft to `/tmp/`
4. Installs via `apt` / `dnf`
5. Cleans up the package file
6. Installs the Pitch Black theme extension via `code --install-extension`
7. Writes the theme to `~/.config/Code/User/settings.json`

## Installation

The install script prompts automatically. Select **1** to auto-install.

### Manual Installation

```bash
# always gets latest stable
curl -L "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64" \
    -o /tmp/vscode.deb
sudo apt install -y /tmp/vscode.deb
rm /tmp/vscode.deb
code --version

# install theme
code --install-extension viktorqvarfordt.vscode-pitch-black-theme
```

## Applying the Pitch Black Theme

```
Ctrl + Shift + P → Color Theme → Pitch Black
```

## Uninstalling

```bash
sudo apt remove code       # Debian
sudo dnf remove code       # Fedora
yay -Rns visual-studio-code-bin  # Arch
```

**Resources:** [VSCode Download](https://code.visualstudio.com/Download) · [Pitch Black Theme](https://marketplace.visualstudio.com/items?itemName=viktorqvarfordt.vscode-pitch-black-theme)
