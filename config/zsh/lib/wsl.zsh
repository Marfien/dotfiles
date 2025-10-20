if [ -n "$WSL_DISTRO_NAME" ]; then
  export PATH="$PATH:/mnt/c/WINDOWS:/mnt/c/WINDOWS/system32:/mnt/c/WINDOWS/System32/WindowsPowerShell/v1.0/"
  alias powershell="powershell.exe"
fi
