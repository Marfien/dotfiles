{ username, ... }:
{
  home-manager = {
    users.${username} = ../../home/mac;
  };

}
