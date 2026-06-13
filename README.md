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

```bash
nix run home-manager/master -- switch --flake ~/.config/home-manager#<profile>
```

## Usage

Apply changes or update packages:

```bash
# apply changes after editing a profile
nix run home-manager/master -- switch --flake ~/.config/home-manager#<profile>

# update all packages to latest
nix flake update ~/.config/home-manager
nix run home-manager/master -- switch --flake ~/.config/home-manager#<profile>
```

## Structure

```
home-config/
├── flake.nix              # entry point, pins nixpkgs and home-manager versions
├── karabiner.json         # karabiner-elements key mapping template (Mac)
├── common/
│   ├── cli.nix            # CLI tools, git, shell config, and aliases
│   └── gui.nix            # GUI apps shared across desktop platforms
└── profiles/
    ├── darwin.nix         # Mac desktop
    ├── linux.nix          # Linux desktop
    └── headless.nix       # Linux server / headless
```

Profiles are the three user-facing machine configs. Each imports from `common/` and adds only what's specific to that platform.