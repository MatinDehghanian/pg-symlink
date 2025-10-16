#!/usr/bin/env bash
#
# setup_pg_shortcut.sh
#
# A simple and safe script to create a "pg" shortcut for the `pasarguard` command.
# Works with either:
#   1. User-level alias (no root required)
#   2. System-wide symlink (requires sudo)

set -euo pipefail

GREEN="\e[32m"
YELLOW="\e[33m"
RED="\e[31m"
RESET="\e[0m"

# --- Functions -------------------------------------------------------------

function info()    { echo -e "${YELLOW}$1${RESET}"; }
function success() { echo -e "${GREEN}$1${RESET}"; }
function error()   { echo -e "${RED}$1${RESET}"; }

# --- Check for pasarguard --------------------------------------------------

info "🔍 Checking for pasarguard command..."

if ! PASARGUARD_PATH=$(command -v pasarguard 2>/dev/null); then
  error "❌ pasarguard command not found in PATH."
  echo "Install pasarguard or add it to PATH before running this script."
  exit 1
fi

success "✅ Found pasarguard at: $PASARGUARD_PATH"
echo

# --- Choose installation type ---------------------------------------------

info "Choose installation type:"
echo "  1) Alias (only for current user)"
echo "  2) System-wide symlink (requires sudo)"
read -rp "Enter choice [1 or 2]: " CHOICE
echo

# --- Alias installation ----------------------------------------------------

if [[ "$CHOICE" == "1" ]]; then
  # Detect shell config file robustly
  if [[ -n "$SHELL" ]]; then
    SHELL_NAME=$(basename "$SHELL")
  else
    SHELL_NAME="bash" # fallback
  fi
  case "$SHELL_NAME" in
    bash) RC_FILE="$HOME/.bashrc" ;;
    zsh)  RC_FILE="$HOME/.zshrc" ;;
    fish) RC_FILE="$HOME/.config/fish/config.fish" ;;
    *)    RC_FILE="$HOME/.profile" ;;
  esac

  info "⚙️  Adding alias to $RC_FILE..."

  # Remove any previous pg alias
  sed -i '/alias pg=/d' "$RC_FILE" 2>/dev/null || true

  # Add alias
  echo "alias pg='pasarguard'" >> "$RC_FILE"
  success "✅ Alias added to $RC_FILE"

  # Reload shell config only if interactive and not fish
  if [[ -t 0 && "$SHELL_NAME" != "fish" ]]; then
    info "🔄 Reloading shell configuration..."
    # shellcheck disable=SC1090
    source "$RC_FILE"
  fi

  success "🎉 Now you can run: pg restart"

# --- Symlink installation --------------------------------------------------

elif [[ "$CHOICE" == "2" ]]; then
  TARGET="/usr/local/bin/pg"
  info "⚙️  Creating symlink at $TARGET..."

  if [[ -e "$TARGET" ]]; then
    # Check if it's already the correct symlink
    if [[ -L "$TARGET" && "$(readlink "$TARGET")" == "$PASARGUARD_PATH" ]]; then
      success "✅ Symlink already exists and points to pasarguard."
      success "🎉 Try running: pg restart"
      exit 0
    fi
    error "❌ File already exists at $TARGET"
    read -rp "Overwrite it? [y/N]: " CONFIRM
    if [[ "$CONFIRM" =~ ^[Yy]$ ]]; then
      sudo rm -f "$TARGET"
    else
      echo "Aborted."
      exit 1
    fi
  fi

  sudo ln -s "$PASARGUARD_PATH" "$TARGET"
  success "✅ Symlink created at $TARGET"
  success "🎉 Try running: pg restart"

# --- Invalid choice --------------------------------------------------------


else
  error "❌ Invalid choice. Exiting."
  exit 1
fi

# --- Summary --------------------------------------------------------------
echo
success "✅ Setup complete!"
info "Run 'pg <command>' to use pasarguard via shortcut."
