# home-config

Personal configuration managed with [Nix Home Manager](https://github.com/nix-community/home-manager).

## Setup

### 1. Install Nix

Install Nix using the [Determinate Systems installer](https://determinate.systems/nix-installer/) — it handles macOS and Linux and is easier than the official installer.

### 2. Clone this repo

```bash
nix shell nixpkgs#git --command git clone https://github.com/cnewman111/home-config.git ~/.config/home-manager
```

### 3. Apply the config

Pick the profile for your machine:

| Machine type  | Profile    |
|---------------|------------|
| Mac           | `darwin`   |
| Linux desktop | `linux`    |
| Linux server  | `headless` |

The `-b backup` flag renames any existing shell config files (`.zshrc`, `.bashrc`, etc.) to `.zshrc.backup` before Home Manager writes its own. Always use it on first apply to avoid losing your existing config.

```bash
nix run home-manager/master -- switch -b backup --flake ~/.config/home-manager#<profile>
```

## Local overrides

Home Manager generates your shell config but sources local override files if they exist:

- `~/.zshrc.local` — machine-specific zsh config
- `~/.bashrc.local` — machine-specific bash config

Put anything you don't want in the repo here (work credentials, private aliases, machine-specific PATH entries, etc.). These files are never managed or overwritten by Home Manager.

## Usage

Apply changes or update packages:

```bash
# apply changes after editing a profile
nix run home-manager/master -- switch --flake ~/.config/home-manager#<profile>

# update all packages to latest
nix flake update ~/.config/home-manager
nix run home-manager/master -- switch --flake ~/.config/home-manager#<profile>
```

## GUI apps

These apps are installed outside of Nix. Run the script for your platform after applying the Nix config:

**Mac:**
```bash
./install-mac-apps.sh
```
Includes: Karabiner-Elements, JetBrains Toolbox, Raycast, 1Password, Brave, Chrome.

**Linux:**
```bash
./install-linux-apps.sh
```
Includes: JetBrains Toolbox, Brave, Chrome, 1Password* (all via snap).

*The snap version of 1Password has limitations: browser extension and app unlock separately, no system authentication, no SSH agent.

## Structure

```
home-config/
├── flake.nix          # entry point, pins nixpkgs and home-manager versions
├── common.nix         # packages, shell config, git, and aliases for all machines
├── zshrc              # existing zsh config (included by common.nix)
├── zprofile           # existing zsh profile (included by common.nix)
├── configs/
│   ├── karabiner.json # karabiner key mapping template (seeded on first run)
│   └── nvim/lua/      # custom LazyVim plugin config
└── profiles/
    ├── darwin.nix     # Mac desktop
    ├── linux.nix      # Linux desktop
    └── headless.nix   # Linux server / headless
```

Each profile imports `common.nix` and adds only what's specific to that platform.