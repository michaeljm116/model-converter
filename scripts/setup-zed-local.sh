#!/usr/bin/env bash
set -euo pipefail

OS=$(uname -s)
# Repo-local override path (within this repository)
REPO_ROOT=$(cd "$(dirname "$0")/.." && pwd)
LOCAL_SETTINGS="$REPO_ROOT/.zed/settings.json.local"

case "$OS" in
  Darwin*)
    if [ -x "/opt/homebrew/opt/llvm/bin/clangd" ]; then
      CLANGD_PATH="/opt/homebrew/opt/llvm/bin/clangd"
    elif [ -x "/usr/local/opt/llvm/bin/clangd" ]; then
      CLANGD_PATH="/usr/local/opt/llvm/bin/clangd"
    elif command -v clangd >/dev/null 2>&1; then
      CLANGD_PATH="$(command -v clangd)"
    else
      echo "clangd not found. Install with Homebrew: brew install llvm, and ensure it's in PATH." >&2
      exit 1
    fi

    mkdir -p "$(dirname "$LOCAL_SETTINGS")"

    cat > "$LOCAL_SETTINGS" <<EOF
{
  "lsp": {
    "clangd": {
      "binary": { "path": "$CLANGD_PATH" }
    }
  }
}
EOF
    echo "Wrote $LOCAL_SETTINGS (clangd at $CLANGD_PATH)"
    ;;
  MINGW*|MSYS*|CYGWIN*)
    if [ -n "${USERPROFILE:-}" ]; then
      CLANGD_PATH="C:\\Program Files\\LLVM\\bin\\clangd.exe"
      mkdir -p "$(dirname "$LOCAL_SETTINGS")"
      cat > "$LOCAL_SETTINGS" <<EOF
{
  "lsp": {
    "clangd": {
      "binary": { "path": "$CLANGD_PATH" }
    }
  }
}
EOF
      echo "Wrote $LOCAL_SETTINGS (clangd at $CLANGD_PATH)"
    else
      echo "USERPROFILE not set; cannot determine Windows user home." >&2
      exit 1
    fi
    ;;
  Linux*)
    if command -v clangd >/dev/null 2>&1; then
      CLANGD_PATH="$(command -v clangd)"
    else
      CLANGD_PATH="/usr/bin/clangd"
      if [ ! -x "$CLANGD_PATH" ]; then
        echo "clangd not found on PATH; please install clangd." >&2
        exit 1
      fi
    fi
    mkdir -p "$(dirname "$LOCAL_SETTINGS")"
    cat > "$LOCAL_SETTINGS" <<EOF
{
  "lsp": {
    "clangd": {
      "binary": { "path": "$CLANGD_PATH" }
    }
  }
}
EOF
    echo "Wrote $LOCAL_SETTINGS (clangd at $CLANGD_PATH)"
    ;;
  *)
    echo "Unknown OS: $OS" >&2
    exit 1
    ;;
esac
