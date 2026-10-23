{ pkgs, ... }:
let
  notifyScript =
    pkgs.writeShellScript "notify-windows"
      # bash
      ''
        # Prefer the message from the hook's JSON payload, fall back to $1
        payload=$(cat)
        message=$(printf '%s' "$payload" | ${pkgs.jq}/bin/jq -r '.message // empty' 2>/dev/null)
        message="''${message:-$1}"
        # PowerShell single-quoted strings escape ' by doubling it
        message=''${message//\'/\'\'}
        (powershell.exe -NoProfile -Command "
        Add-Type -AssemblyName System.Windows.Forms
        Add-Type -AssemblyName System.Drawing
        \$notification = New-Object System.Windows.Forms.NotifyIcon
        \$notification.Icon = [System.Drawing.SystemIcons]::Information
        \$notification.BalloonTipTitle = 'Claude Code'
        \$notification.BalloonTipText = '$message'
        \$notification.Visible = \$true
        \$notification.ShowBalloonTip(5000)
        Start-Sleep -Seconds 6
        \$notification.Dispose()
        " >/dev/null 2>&1 &)
      '';
  apiKeyHelper =
    pkgs.writeShellScript "claude-api-key"
      # bash
      ''
        cat "''${XDG_CONFIG_HOME:-$HOME/.config}/claude/api-key"
      '';
  mkNotifyHook = msg: {
    hooks = [
      {
        type = "command";
        command = ''${notifyScript} "${msg}"'';
      }
    ];
  };
in
{
  home.packages = with pkgs; [
    bubblewrap
    socat
  ];
  programs.claude-code = {
    enable = true;
    settings = {
      inherit apiKeyHelper;
      env = {
        ANTHROPIC_BASE_URL = "https://llm-bedrock-proxy.soptim.net";
        ANTHROPIC_DEFAULT_OPUS_MODEL = "claude-opus-5-5";
        ANTHROPIC_DEFAULT_SONNET_MODEL = "claude-sonnet-5-5";
        ANTHROPIC_DEFAULT_HAIKU_MODEL = "claude-haiku-5-5";
        CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS = "1";
        DISABLE_INSTALL_GITHUB_APP_COMMAND = "1";
        DISABLE_LOGIN_COMMAND = "1";
        CLAUDE_CODE_DISABLE_FEEDBACK_SURVEY = "1";
        CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC = "1";
        DISABLE_AUTOUPDATER = "1";
      };
      permissions.deny = [
        "Edit(/etc/claude-code/managed-settings.json)"
        "Edit(~/.claude/settings.json)"
        "Edit(~/.claude/settings.local.json)"
        "Edit(**/.claude/settings.json)"
        "Edit(**/.claude/settings.local.json)"
        "Edit(~/.claude/claude_desktop_config.json)"
      ];
      model = "opus";
      effortLevel = "high";
      enabledPlugins = {
        "academic-research-skills@academic-research-skills" = true;
        "mcp-perplexity@soptim-ds" = true;
        "gopls-lsp@claude-plugins-official" = true;
        "mattpocock-skills@claude-plugins-official" = true;
      };
      extraKnownMarketplaces = {
        academic-research-skills.source = {
          source = "github";
          repo = "Imbad0202/academic-research-skills";
        };
        soptim-ds.source = {
          source = "git";
          url = "git@git-ac.soptim.net:ai-tech-public/marketplace.git";
        };
      };
      sandbox = {
        enabled = true;
        failIfUnavailable = true;
        allowUnsandboxedCommands = false;
        filesystem = {
          allowWrite = [
            "~/workspace"
            "/tmp/claude"
          ];
          denyWrite = [ "~" ];
          denyRead = [ "~" ];
          allowRead = [
            "~/workspace"
            "/tmp/claude"
            "/usr"
            "/opt"
            "~/go"
          ];
        };
      };
      tui = "fullscreen";
      theme = "auto";
      hooks = {
        Notification = [ (mkNotifyHook "Waiting for input...") ];
        Stop = [ (mkNotifyHook "Task completed") ];
        SubagentStop = [ (mkNotifyHook "Subagent done") ];
      };
    };
  };
}
