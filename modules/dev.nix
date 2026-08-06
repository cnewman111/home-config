{ pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    neovim
    tmux
    ripgrep
    bat
    fzf
    fd
    curl
    lazygit
    tree-sitter
    _1password-cli
  ];

  programs.btop = {
    enable = true;
    settings = {
      # btop rewrites its config on quit, but Home Manager makes it a read-only
      # symlink into the store — that write would fail on every exit.
      save_config_on_exit = false;
      vim_keys = true;
      theme_background = false;
      truecolor = true;
      # Flat process list, not the tree. proc_aggregate only takes effect in
      # tree view, so it's left on for when the tree is toggled with `t`.
      proc_tree = false;
      proc_aggregate = true;
    };
  };

  home.activation.lazyVim = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -d ~/.config/nvim ]; then
      ${pkgs.git}/bin/git clone https://github.com/LazyVim/starter ~/.config/nvim
      rm -rf ~/.config/nvim/.git
    fi
    mkdir -p ~/.config/nvim/lua
    chmod -R u+w ~/.config/nvim/lua 2>/dev/null || true
    cp -r ${../configs/nvim/lua}/. ~/.config/nvim/lua/
    chmod -R u+w ~/.config/nvim/lua
  '';
}
