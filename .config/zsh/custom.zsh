latex_w() {
  local file="$1"
  local checksum=''

  if ! [ -r "$file" ]; then
    echo "File '$file' not found or not readable."
    return 1
  fi

  while [[ true ]]; do
    chsum2="$(md5 "$file")"
    if [[ $chsum1 != $chsum2 ]]; then
      echo "File '$file' changed. Recompiling..."
      pdflatex "$file"
      chsum1=$chsum2
    fi
    sleep 2
  done
}
