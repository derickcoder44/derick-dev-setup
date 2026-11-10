#!/usr/bin/env bash
# Amazon Linux 2 (headless). glibc 2.26 rules out most prebuilt glibc binaries, so tools come from musl/static builds.
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN="$HOME/.local/bin"
OPT="$HOME/.local/opt"
mkdir -p "$BIN" "$OPT"

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
info()    { echo -e "${GREEN}[install]${NC} $*"; }
warn()    { echo -e "${YELLOW}[warn]${NC} $*"; }
success() { echo -e "${GREEN}[✓]${NC} $*"; }

# Resolves via the redirect rather than the API, which rate-limits shared IPs.
latest_tag() { curl -fsSI "https://github.com/$1/releases/latest" | tr -d '\r' | sed -n 's#^[Ll]ocation: .*/tag/##p'; }

install_tarball() {
  local name="$1" url="$2" binpath="$3"
  if [ -x "$BIN/$name" ]; then info "$name already installed"; return; fi
  local tmp; tmp=$(mktemp -d)
  curl -fsSL "$url" | tar xz -C "$tmp"
  install -m 755 "$tmp/$binpath" "$BIN/$name"
  rm -rf "$tmp"
  success "installed $name"
}

link() {
  local src="$1" dst="$2"
  if [ -L "$dst" ]; then info "already linked: $dst"; return; fi
  if [ -e "$dst" ]; then warn "backing up existing $dst → $dst.bak"; mv "$dst" "$dst.bak"; fi
  mkdir -p "$(dirname "$dst")"
  ln -s "$src" "$dst"
  success "linked $dst → $src"
}

if ! rpm -q tree >/dev/null 2>&1; then sudo yum install -y -q tree && success "installed tree"; else info "tree already installed"; fi

if [ -x "$BIN/nvim" ]; then
  info "nvim already installed"
else
  rm -rf "$OPT/nvim"
  curl -fsSL https://github.com/neovim/neovim-releases/releases/latest/download/nvim-linux-x86_64.tar.gz | tar xz -C "$OPT"
  mv "$OPT/nvim-linux-x86_64" "$OPT/nvim"
  ln -sf "$OPT/nvim/bin/nvim" "$BIN/nvim"
  success "installed nvim"
fi

rg_tag=$(latest_tag BurntSushi/ripgrep)
install_tarball rg "https://github.com/BurntSushi/ripgrep/releases/download/$rg_tag/ripgrep-$rg_tag-x86_64-unknown-linux-musl.tar.gz" "ripgrep-$rg_tag-x86_64-unknown-linux-musl/rg"

fd_tag=$(latest_tag sharkdp/fd)
install_tarball fd "https://github.com/sharkdp/fd/releases/download/$fd_tag/fd-$fd_tag-x86_64-unknown-linux-musl.tar.gz" "fd-$fd_tag-x86_64-unknown-linux-musl/fd"

fzf_tag=$(latest_tag junegunn/fzf)
install_tarball fzf "https://github.com/junegunn/fzf/releases/download/$fzf_tag/fzf-${fzf_tag#v}-linux_amd64.tar.gz" fzf

install_tarball starship https://github.com/starship/starship/releases/latest/download/starship-x86_64-unknown-linux-musl.tar.gz starship

if [ -x "$OPT/go/bin/go" ]; then
  info "go already installed"
else
  go_version=$(curl -fsSL "https://go.dev/VERSION?m=text" | head -1)
  curl -fsSL "https://go.dev/dl/$go_version.linux-amd64.tar.gz" | tar xz -C "$OPT"
  success "installed $go_version"
fi

[ -d "$HOME/.rbenv" ] && info "rbenv already installed" || { git clone -q https://github.com/rbenv/rbenv.git "$HOME/.rbenv" && git clone -q https://github.com/rbenv/ruby-build.git "$HOME/.rbenv/plugins/ruby-build" && success "installed rbenv"; }
[ -d "$HOME/.jenv" ] && info "jenv already installed" || { git clone -q https://github.com/jenv/jenv.git "$HOME/.jenv" && success "installed jenv"; }
if [ -d "$HOME/.nvm" ]; then
  info "nvm already installed"
else
  # PROFILE=/dev/null stops the installer editing ~/.bashrc; linux.bashrc loads nvm instead.
  curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | PROFILE=/dev/null bash >/dev/null
  success "installed nvm"
fi

link "$REPO/nvim" "$HOME/.config/nvim"

source_line="[ -f \"$REPO/bash/linux.bashrc\" ] && . \"$REPO/bash/linux.bashrc\""
if grep -qxF "$source_line" "$HOME/.bashrc" 2>/dev/null; then
  info "~/.bashrc already sources linux.bashrc"
else
  printf '\n%s\n' "$source_line" >> "$HOME/.bashrc"
  success "~/.bashrc now sources $REPO/bash/linux.bashrc"
fi

echo ""
success "Setup complete! Restart your shell or run: source ~/.bashrc"
