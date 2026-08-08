# home-config

Personal cross-machine config: [Home Manager](https://github.com/nix-community/home-manager) everywhere, plus [nix-darwin](https://github.com/nix-darwin/nix-darwin) on the Mac for system settings and core Homebrew casks.

Composed per machine — each host under `hosts/` picks the feature modules it wants from `modules/`.

| Machine      | Attribute                      | Switch with                                                        |
|--------------|--------------------------------|--------------------------------------------------------------------|
| Work laptop  | `cnewman@cnewman-5690-ubuntu`  | `home-manager switch --flake .`                                    |
| Work desktop | `cnewman@TODO-work-desktop`    | same (rename the host first — see [Adding a machine](#adding-a-machine)) |
| MacBook Pro  | `Colins-MacBook-Pro`           | `sudo darwin-rebuild switch --flake .#Colins-MacBook-Pro`          |

On Linux the attribute auto-detects from `$(whoami)@$(hostname -s)`, so no `#attr` is needed.

## Daily use

```bash
cd ~/sources/home-config

# apply changes
home-manager switch --flake .                                    # Linux
sudo darwin-rebuild switch --flake .#Colins-MacBook-Pro           # Mac

# update all packages, then re-apply
nix flake update
```

### Before you apply

```bash
# does every host still evaluate? (darwin one works from Linux too)
nix eval --raw '.#homeConfigurations."cnewman@cnewman-5690-ubuntu".activationPackage.drvPath'
nix eval --raw '.#darwinConfigurations."Colins-MacBook-Pro".system.drvPath'

# what would actually change?
nix build '.#homeConfigurations."cnewman@cnewman-5690-ubuntu".activationPackage'
nix run nixpkgs#nvd -- diff ~/.local/state/nix/profiles/home-manager ./result
```

The `nvd diff` is the useful one — for a pure refactor it should report no changes.

### Rollback

```bash
home-manager generations          # list
/nix/store/<hash>-home-manager-generation/activate    # activate an older one
```

## Structure

```
flake.nix              mkHome / mkDarwin factories, one entry per machine
hosts/                 one directory per machine
  cnewman-5690-ubuntu/   work laptop            → home.nix
  TODO-work-desktop/     work desktop (stub)    → home.nix
  Colins-MacBook-Pro/    MacBook                → system.nix + home.nix
modules/               composable features
  common.nix             always applied; pulls in git.nix + dev.nix
  aliases.nix            shared shell aliases (plain attrset, not a module)
  zsh.nix                main shell config (both platforms)
  bash.nix               minimal bash fallback (Linux: SSH, cron, Ctrl+Alt+T)
  git.nix                git identity, gh, nvimdiff difftool
  dev.nix                CLI tools, btop, LazyVim bootstrap
  gui.nix                fonts + ghostty config
  jetbrains.nix          JetBrains keymap sync (Linux)
  linux.nix              Linux-only user config (imports zsh.nix + bash.nix)
  darwin.nix             Mac-only user config (imports zsh.nix)
configs/               non-Nix config files
  jetbrains/keymap.xml   JetBrains keymap, synced to every IDE version dir
  karabiner.json         Karabiner key mapping (Mac)
  zprofile               pre-existing Mac zsh profile
  nvim/lua/              custom LazyVim config
```

How it composes:

- `modules/common.nix` is applied to every host by the factories in `flake.nix`. Everything else is opt-in via a host's `imports` list.
- A headless/server host is simply one that doesn't import `gui.nix`.
- zsh on both platforms. On Linux the login shell is still bash, so ghostty and the JetBrains terminals are pointed at zsh directly; `bash.nix` keeps SSH/cron shells usable.
- On the Mac, `system.nix` is the nix-darwin entry point and pulls in `home.nix` as a Home Manager module — one `darwin-rebuild switch` applies both layers.
- On Linux there's no system layer; hardware varies too much to manage declaratively.

## Local overrides

Home Manager generates your shell config but sources these if they exist. They are never managed or overwritten:

- `~/.zshrc.local`, `~/.zprofile.local` (both platforms)
- `~/.bashrc.local`, `~/.profile.local` (Linux bash fallback)

This is where machine-specific and private config belongs: work credentials, private aliases, per-machine PATH entries. Don't move their contents into the repo.

## Optional GUI apps

On the Mac every GUI app is declared as a Homebrew cask in `hosts/Colins-MacBook-Pro/system.nix` and installed by `darwin-rebuild switch`. There is no picker script.

Linux has no system layer, so its GUI apps are still installed by an interactive `fzf` picker outside Nix. Run **after** applying the config.

```bash
./install-linux-apps.sh   # JetBrains Toolbox, Ghostty, Brave, 1Password, Spotify, Slack, Zoom
```

Linux installs via snap. Note the snap 1Password unlocks separately from the browser extension and has no system authentication or SSH agent.

## First-time setup

1. **Install Nix** via the [Determinate Systems installer](https://determinate.systems/nix-installer/).

2. **Clone:**
   ```bash
   nix shell nixpkgs#git --command \
     git clone https://github.com/cnewman111/home-config.git ~/sources/home-config
   ```

3. **Move pre-existing dotfiles aside.** Home Manager refuses to overwrite an existing `~/.zshrc`. Merge anything you want to keep into the matching `.local` file.

4. **Apply** — first run needs the full flake URL, since `home-manager` isn't on PATH yet:
   ```bash
   nix run github:nix-community/home-manager -- switch --flake .        # Linux
   sudo nix run nix-darwin -- switch --flake .#Colins-MacBook-Pro       # Mac
   ```

### Adding a machine

1. `mkdir hosts/$(hostname -s)`, then copy `hosts/cnewman-5690-ubuntu/home.nix` as a starting point. Set `home.username` / `home.homeDirectory` and import the modules you want.
2. Add an entry to `homeConfigurations` in `flake.nix`, keyed `"<user>@<hostname>"`.
3. Apply.

The work desktop is stubbed as `hosts/TODO-work-desktop/`. On that machine, rename the directory to its real `hostname -s`, confirm the username, and update the matching key in `flake.nix`.

### Mac prerequisites

1. **Bootstrap Homebrew** — nix-darwin drives it but won't install it:
   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```
2. **`sudo` is required** — activation writes to `/etc/` and `/run/current-system`. If sudo can't find `nix`, use the `sudo nix run nix-darwin -- ...` form.
3. **Adopt existing casks.** If any declared cask (Karabiner-Elements, Raycast, Brave, JetBrains Toolbox, Ghostty, Chrome, Spotify, Discord, WhatsApp, Slack, Zoom, ProtonVPN) was installed outside Homebrew:
   ```bash
   brew install --cask --adopt <cask-name>
   ```
   Casks already installed via brew are fine — `brew bundle` skips them.
