{ username, ... }:
{
  system.primaryUser = username;
  users.users.${username} = {
    home = "/Users/${username}";
  };

  nix-homebrew = {
    enable = true;
    enableRosetta = true;
    user = username;
    autoMigrate = true;
  };
}
