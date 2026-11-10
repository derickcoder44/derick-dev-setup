#!/usr/bin/env bash
# Runs this OS's setup script: macos.sh, or <ID>-<VERSION_ID>.sh from /etc/os-release (e.g. amzn-2023.sh).
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ "$(uname)" = Darwin ]; then
  os=macos
else
  . /etc/os-release
  os="$ID-$VERSION_ID"
fi

script="$REPO/$os.sh"
if [ ! -f "$script" ]; then
  echo "No $os.sh yet. Write one for this OS, using macos.sh as the list of what to set up." >&2
  exit 1
fi
exec bash "$script"
