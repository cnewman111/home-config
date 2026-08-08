# Shared shell aliases, imported by modules/zsh.nix. Kept as a separate plain
# attrset (not a module) so aliases stay independent of shell config — both
# platforms run zsh, but a second shell would consume this same list.
{
  ga  = "git add";
  gcm = "git commit -m";
  gc  = "git checkout";
  gs  = "git status";
  gp  = "git push";
  gpl = "git pull";
  gdt = "git difftool";
  nd  = "nix develop --builders ''";
  ndc = "nix develop --builders '' --command";
}
