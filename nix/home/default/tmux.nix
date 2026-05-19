{
  lib,
  pkgs,
  ...
}:
{
  programs.tmux = {
    enable = true;
    terminal = ",xterm-256color:Tc";
    clock24 = true;
    disableConfirmationPrompt = true;
    keyMode = "vi";
    customPaneNavigationAndResize = true;
    historyLimit = 9999;
    focusEvents = true;
    escapeTime = 20;
    extraConfig = ''
      set-option -g default-terminal "screen-256color"

      # Custom Keybinds
      bind-key -T copy-mode-vi 'a' send-keys -X cancel
      bind-key -T copy-mode-vi 'i' send-keys -X cancel
      bind-key -T copy-mode-vi 'C-h' select-pane -L
      bind-key -T copy-mode-vi 'C-j' select-pane -D
      bind-key -T copy-mode-vi 'C-k' select-pane -U
      bind-key -T copy-mode-vi 'C-l' select-pane -R
      bind-key -T copy-mode-vi 'C-\' select-pane -l

      # Open new panes with same cwd
      bind c new-window -c "#{pane_current_path}"
      bind C new-window -c "$HOME"
      bind '-' split-window -c "#{pane_current_path}"
      bind '|' split-window -h -c "#{pane_current_path}"

      # Statusbar
      set -g status-style bg=default

      set -g status-left ""
      set -g status-left-length 10

      set -g status-right '%Y-%m-%d %H:%M - #[fg=green]#S '
      set -g status-right-length 50

      setw -g window-status-current-style 'fg=black bg=green'
      setw -g window-status-current-format ' #I/#P #W #(echo "#F" | sed -E "s/\*//" | sed -E "s/(.+)/\1 /")'

      setw -g window-status-style 'fg=green bg=default'
      setw -g window-status-format ' #I/#P #[fg=white]#W #[fg=green]#(echo "#F" | sed -E "s/(.+)/\1 /")'
    '';
  };
}
