# The username on main is intentionally a placeholder. Each machine gets its
# own long-lived branch so the username (and any other machine-specific tweaks)
# never collide on main.
#
# Setting up a new machine:
#   1. git checkout -b machine/$(hostname -s)
#   2. Replace the throw below with: username = "your-username";
#   3. Commit, then run the switch command from the README.
#   4. Stay on this branch for all future switches. Pull main in when you want
#      shared updates; never merge the username change back to main.
#
# Home directory is derived: /Users/${username} on Mac, /home/${username} on Linux.
{
  username = throw ''

    user.nix on main has a placeholder username — set yours on a per-machine branch first:

      git checkout -b machine/$(hostname -s)
      $EDITOR user.nix          # set: username = "your-username";
      git commit -am 'set username for this machine'

    Then re-run the switch command. Don't merge this change back to main.
  '';
}
