# home-config

Personal configuration managed with [Nix Home Manager](https://github.com/nix-community/home-manager). On macOS, [nix-darwin](https://github.com/nix-darwin/nix-darwin) layers on top to manage system-level config and core Homebrew casks.

## Setup

### 1. Install Nix

Install Nix using the [Determinate Systems installer](https://determinate.systems/nix-installer/) — it handles macOS and Linux and is easier than the official installer.

### 2. Clone this repo

Clone wherever you keep projects. The examples below assume `~/sources/home-config`.
```bash
nix shell nixpkgs#git --command git clone https://github.com/cnewman111/home-config.git ~/sources/home-config
```

### 3. Apply the config

| Machine type   | Profile    | Command                                                                                  |
|----------------|------------|------------------------------------------------------------------------------------------|
| Mac            | `darwin`   | `sudo nix run nix-darwin -- switch --flake ~/sources/home-config#darwin`                 |
| Linux desktop  | `linux`    | `nix run home-manager/master -- switch --flake ~/sources/home-config#linux`              |
| Linux headless | `headless` | `nix run home-manager/master -- switch --flake ~/sources/home-config#headless`           |

**Mac prerequisites:**

1. Install [Homebrew](https://brew.sh) — nix-darwin's homebrew module drives it but does not bootstrap it.
   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```
2. `sudo` is required because system activation writes to `/etc/` and `/run/current-system`. If sudo can't find `nix` on its PATH, use:
   ```bash
   sudo $(which nix) run nix-darwin -- switch --flake ~/sources/home-config#darwin
   ```
3. If any core cask (Karabiner-Elements, Raycast, Brave, JetBrains Toolbox) is already installed *outside* of Homebrew, run this once per app to hand ownership to brew without re-downloading:
   ```bash
   brew install --cask --adopt <cask-name>
   ```
   Casks already installed via brew are fine — `brew bundle` skips them.

The Mac command installs nix-darwin, then runs home-manager and the core casks in one switch.

After the first apply, the Mac command shortens to:
```bash
sudo darwin-rebuild switch --flake ~/sources/home-config#darwin
```

**Pre-existing dotfiles:** home-manager will refuse to overwrite an existing `~/.zshrc`, `~/.bashrc`, etc. Move them aside (or merge what you want into `~/.zshrc.local`) before applying.

### 4. Optional GUI apps

Apps that aren't on every machine live in interactive install scripts. Run **after** applying the Nix config.

**Mac:**
```bash
./install-mac-apps.sh
```
Optional picks: 1Password, Chrome, Spotify, Discord, WhatsApp, Slack, Zoom, ProtonVPN.

**Linux:**
```bash
./install-linux-apps.sh
```
Includes: JetBrains Toolbox, Brave, Chrome, 1Password*, Spotify, Slack, Zoom (all via snap).

*The snap version of 1Password has limitations: browser extension and app unlock separately, no system authentication, no SSH agent.

## Local overrides

Home Manager generates your shell config but sources local override files if they exist:

- `~/.zshrc.local` — machine-specific zsh config
- `~/.bashrc.local` — machine-specific bash config

Put anything you don't want in the repo here (work credentials, private aliases, machine-specific PATH entries, etc.). These files are never managed or overwritten by Home Manager.

## Usage

Apply changes or update packages:

```bash
# Mac — apply changes after editing any Mac config
sudo darwin-rebuild switch --flake ~/sources/home-config#darwin

# Linux — apply changes after editing the profile
nix run home-manager/master -- switch --flake ~/sources/home-config#<profile>

# update all packages to latest (any platform)
nix flake update ~/sources/home-config
# then re-run the switch command above
```

## Structure

```
home-config/
├── flake.nix                     # entry point, pins nixpkgs, home-manager, nix-darwin
├── common.nix                    # packages, shell config, git, aliases shared across machines
├── zprofile                      # existing zsh profile (included by common.nix)
├── install-mac-apps.sh           # optional Mac GUI apps (brew casks)
├── install-linux-apps.sh         # optional Linux GUI apps (snap)
├── configs/
│   ├── karabiner.json            # karabiner key mapping template (seeded on first run)
│   └── nvim/lua/                 # custom LazyVim plugin config
└── profiles/
    ├── darwin.nix                # Mac home-manager (user) config
    ├── darwin-system.nix         # Mac nix-darwin (system) config + core casks
    ├── linux.nix                 # Linux desktop
    └── headless.nix              # Linux server / headless
```

- On Mac, `darwin-system.nix` is the entry point and pulls in `darwin.nix` as a home-manager module. 
- On Linux, because there is more variety in system hardware, we do not adjust system settings. All modules are installed via the script.
