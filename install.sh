#!/usr/bin/env bash
set -e

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ── colors ────────────────────────────────────────────────────────────────────
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; NC='\033[0m'
info()    { echo -e "${GREEN}[install]${NC} $*"; }
warn()    { echo -e "${YELLOW}[warn]${NC} $*"; }
success() { echo -e "${GREEN}[✓]${NC} $*"; }

# ── helpers ───────────────────────────────────────────────────────────────────
link() {
  local src="$1" dst="$2"
  if [ -L "$dst" ]; then
    info "already linked: $dst"
    return
  fi
  if [ -e "$dst" ]; then
    warn "backing up existing $dst → $dst.bak"
    mv "$dst" "$dst.bak"
  fi
  mkdir -p "$(dirname "$dst")"
  ln -s "$src" "$dst"
  success "linked $dst → $src"
}

command_exists() { command -v "$1" &>/dev/null; }

# ── 1. Homebrew ───────────────────────────────────────────────────────────────
if ! command_exists brew; then
  info "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  info "Homebrew already installed"
fi

# ── 2. Brew packages ──────────────────────────────────────────────────────────
info "Installing brew packages..."
BREW_PACKAGES=(
  neovim
  git
  go
  starship
  ripgrep
  fd
  fzf
  jq
  tree
  wget
  curl
  tmux
)
for pkg in "${BREW_PACKAGES[@]}"; do
  if brew list "$pkg" &>/dev/null; then
    info "$pkg already installed"
  else
    brew install "$pkg"
    success "installed $pkg"
  fi
done

# ── 3. rbenv (Ruby) ───────────────────────────────────────────────────────────
if ! command_exists rbenv; then
  info "Installing rbenv..."
  brew install rbenv ruby-build
else
  info "rbenv already installed"
fi

# ── 4. nvm (Node) ─────────────────────────────────────────────────────────────
if [ ! -d "$HOME/.nvm" ]; then
  info "Installing nvm..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
else
  info "nvm already installed"
fi

# ── 5. jenv (Java) ────────────────────────────────────────────────────────────
if ! command_exists jenv; then
  info "Installing jenv..."
  brew install jenv
else
  info "jenv already installed"
fi

# ── 6. GHCup (Haskell) ────────────────────────────────────────────────────────
if ! command_exists ghcup; then
  info "Installing GHCup..."
  curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
else
  info "GHCup already installed"
fi

# ── 7. Fonts ──────────────────────────────────────────────────────────────────
info "Installing fonts..."
FONT_DIR="$HOME/Library/Fonts"
FONTS_INSTALLED=0
for font in "$REPO/fonts"/*.ttf; do
  fname="$(basename "$font")"
  if [ ! -f "$FONT_DIR/$fname" ]; then
    cp "$font" "$FONT_DIR/$fname"
    FONTS_INSTALLED=$((FONTS_INSTALLED + 1))
  fi
done
if [ $FONTS_INSTALLED -gt 0 ]; then
  success "Installed $FONTS_INSTALLED font(s) to $FONT_DIR"
else
  info "All fonts already installed"
fi

# ── 8. Dotfile symlinks ───────────────────────────────────────────────────────
info "Creating dotfile symlinks..."

link "$REPO/bash/.bash_profile" "$HOME/.bash_profile"
link "$REPO/bash/.bashrc"       "$HOME/.bashrc"
link "$REPO/bash/.bash_aliases" "$HOME/.bash_aliases"
link "$REPO/bash/.zshrc"        "$HOME/.zshrc"
link "$REPO/bash/.profile"      "$HOME/.profile"
link "$REPO/nvim"               "$HOME/.config/nvim"

# ── 9. iTerm2 prefs ───────────────────────────────────────────────────────────
if [ -d "/Applications/iTerm.app" ]; then
  info "Configuring iTerm2 to load prefs from repo..."
  defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$REPO/iterm2"
  defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true
  success "iTerm2 prefs folder set to $REPO/iterm2"
fi

echo ""
success "Setup complete! Restart your shell or run: source ~/.bash_profile"
