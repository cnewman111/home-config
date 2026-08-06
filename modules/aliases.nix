# Shared shell aliases, consumed by both bash.nix and zsh.nix so the two
# shells can never drift apart. This is a plain attrset, not a module.
{
  ga  = "git add";
  gcm = "git commit -m";
  gc  = "git checkout";
  gs  = "git status";
  gp  = "git push";
  gpl = "git pull";
  gdt = "git difftool";
  nd  = "nix develop";
  ndc = "nix develop --command";
}
