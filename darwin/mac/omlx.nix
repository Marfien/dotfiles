{ ... }:
{
  homebrew = {
    taps = [
      {
        name = "jundot/omlx";
        clone_target = "https://github.com/jundot/omlx";
        trusted = true;
      }
    ];
    brews = [
      {
        name = "omlx";
        restart_service = true;
        args = [
          "with-custom-kernel"
        ];
        postinstall = "\${HOMEBREW_PREFIX}/opt/omlx/libexec/bin/pip install mcp";
      }
    ];
  };
}
