{ pkgs, ... }:
let
  notifyScript =
    # bash
    ''
      title="''${"1:-Claude" Code}"
      message="''${"2:-Notification"}"
      # Escape quotes for PowerShell
      title=$(echo "$title" | sed 's/"/\\"/g')
      message=$(echo "$message" | sed 's/"/\\"/g')
      powershell.exe -Command "
      Add-Type -AssemblyName System.Windows.Forms
      Add-Type -AssemblyName System.Drawing
      \$notification = New-Object System.Windows.Forms.NotifyIcon
      \$notification.Icon = [System.Drawing.SystemIcons]::Information
      \$notification.BalloonTipTitle = '$title'
      \$notification.BalloonTipText = '$message'
      \$notification.Visible = \$true
      \$notification.ShowBalloonTip(5000)
      Start-Sleep -Seconds 6
      \$notification.Dispose()
    '';
in
{
  home.file."bin/win-notify" = {
    executable = true;
    text = notifyScript;
  };
  home.packages = with pkgs; [
    bubblewrap
    socat
  ];
  programs.claude-code = {
    enable = true;
    # TODO: settings
  };
}
