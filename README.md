# home-config

Personal machine configuration managed with [Nix Home Manager](https://github.com/nix-community/home-manager).

## Structure

```
home-config/
├── flake.nix              # entry point, pins nixpkgs and home-manager versions
├── home.nix               # sets username and home directory, loads platform module
├── karabiner.json         # karabiner-elements key mapping template (Mac)
└── modules/
    ├── common-headless.nix  # CLI tools and config shared across all machines
    ├── common-gui.nix       # GUI apps shared between Mac and Linux desktop
    ├── darwin.nix           # Mac-specific apps and config (imports both common modules)
    └── linux.nix            # Linux-specific apps and config (imports both common modules)
```

### Module hierarchy

```
common-headless.nix   common-gui.nix
         ↑    ↗               ↑    ↗
    darwin.nix            linux.nix
```

- **common-headless** — CLI tools, shell config, git config, and aliases. Safe to use on any machine including headless servers.
- **common-gui** — GUI apps that work on both Mac and Linux (browsers, JetBrains Toolbox, 1Password).
- **darwin** — Mac-only tools and config (Ghostty, Raycast, Karabiner Elements). Imports both common modules.
- **linux** — Linux-only tools and config (Meld, ELF tools). Imports both common modules.

For a headless server, point Home Manager at `common-headless.nix` directly.

## Setup

### 1. Install Nix

```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

### 2. Clone this repo

```bash
git clone git@github.com:cnewman111/home-config.git ~/.config/home-manager
```

### 3. Apply the config

```bash
nix run home-manager/master -- switch --flake ~/.config/home-manager
```

After the first run, `home-manager` will be available directly:

```bash
home-manager switch --flake ~/.config/home-manager
```

## Making changes

Edit any module file, then apply:

```bash
home-manager switch --flake ~/.config/home-manager
```
