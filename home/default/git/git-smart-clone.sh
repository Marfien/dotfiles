#!/bin/bash

# Default base directory
BASE_DIR="$HOME/workspace"

# Extract the last argument if it's not an option (to support optional target dir)
if [[ $# -eq 0 ]]; then
  echo "Usage: $0 [options] <origin>"
  echo "For options refere to the git clone man page"
  exit 1
elif [[ "${!#}" != -* && $# -gt 1 ]]; then
  DEST_DIR="${!#}"
  ARGS=("${@:1:$(($# - 1))}")
else
  DEST_DIR=""
  ARGS=("$@")
fi

# Get the origin URL
ORIGIN_URL="${ARGS[${#ARGS[@]} - 1]}"

if [[ "$ORIGIN_URL" =~ ^git@([^:]+):(.+)$ ]]; then
  DOMAIN="${BASH_REMATCH[1]}"
  PATH_PART="${BASH_REMATCH[2]}"
elif [[ "$ORIGIN_URL" =~ ^https?://([^/]+)/(.+)$ ]]; then
  DOMAIN="${BASH_REMATCH[1]}"
  PATH_PART="${BASH_REMATCH[2]}"
else
  echo "Unsupported URL format: $ORIGIN_URL"
  exit 1
fi

# Remove trailing .git if present
PATH_PART="${PATH_PART%.git}"

# Determine namespace
IFS='.' read -ra DOMAIN_PARTS <<<"$DOMAIN"
# Get the domain name
# Domain: sub.domain.tld
# Index:   0    1     2
# Rev:    -3   -2    -1
NAMESPACE="${DOMAIN_PARTS[${#DOMAIN_PARTS[@]} - 2]}"

# If there is a subdomain which is not 'git', include it in the namespace
if [[ "${DOMAIN_PARTS[0]}" != "git" && ${#DOMAIN_PARTS[@]} -ne 2 ]]; then
  NAMESPACE="$NAMESPACE/${DOMAIN_PARTS[0]}"
fi

# Determine full target directory
if [[ -z "$DEST_DIR" ]]; then
  TARGET_DIR="$BASE_DIR/$NAMESPACE/$PATH_PART"
else
  TARGET_DIR="$DEST_DIR"
fi

# Run the actual git clone
git clone "${ARGS[@]:0:${#ARGS[@]}-1}" "$ORIGIN_URL" "$TARGET_DIR"
