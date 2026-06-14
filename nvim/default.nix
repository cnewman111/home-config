{ pkgs, lib, ... }:

{
  home.packages = [ pkgs.neovim ];

  home.activation.lazyVim = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -d ~/.config/nvim ]; then
      ${pkgs.git}/bin/git clone https://github.com/LazyVim/starter ~/.config/nvim
      rm -rf ~/.config/nvim/.git
    fi
    mkdir -p ~/.config/nvim/lua
    cp -r ${./lua}/. ~/.config/nvim/lua/
  '';
}
