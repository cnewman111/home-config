{ pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    neovim
    tmux
    ripgrep
    bat
    fzf
    fd
    btop
    curl
    lazygit
    tree-sitter
    _1password-cli
  ];

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
