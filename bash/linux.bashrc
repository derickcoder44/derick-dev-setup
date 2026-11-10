# Sourced from ~/.bashrc on Linux machines; leaves the machine's own ~/.bashrc in place.
export GOPATH="$HOME/go"
export PATH="$HOME/.local/bin:$HOME/.local/opt/go/bin:$GOPATH/bin:$PATH"

if [ -d "$HOME/.rbenv" ]; then
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init - bash)"
fi
if [ -d "$HOME/.jenv" ]; then
  export PATH="$HOME/.jenv/bin:$PATH"
  eval "$(jenv init -)"
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"

if [[ $- == *i* ]] && command -v starship >/dev/null; then
  eval "$(starship init bash)"
fi
