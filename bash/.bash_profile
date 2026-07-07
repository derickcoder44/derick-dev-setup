eval "$(/opt/homebrew/bin/brew shellenv)"
export PATH=/Users/derickmathews/.local/bin:$PATH
export PATH=$PATH:/opt/local/bin

export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"
eval "$(jenv init -)"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/derickmathews/anaconda3/bin/conda' 'shell.bash' 'hook' 2>/dev/null)"
if [ $? -eq 0 ]; then
	eval "$__conda_setup"
else
	if [ -f "/Users/derickmathews/anaconda3/etc/profile.d/conda.sh" ]; then
		. "/Users/derickmathews/anaconda3/etc/profile.d/conda.sh"
	else
		export PATH="/Users/derickmathews/anaconda3/bin:$PATH"
	fi
fi
unset __conda_setup
# <<< conda initialize <<<

[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion
if [ -f $(brew --prefix)/etc/bash_completion ]; then
	. $(brew --prefix)/etc/bash_completion
fi
[[ -r "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh" ]] && . "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh"
export GOPATH=$HOME/go
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin

# Cyphal/UAVCAN DSDL lookup paths
export CYPHAL_PATH="$HOME/.cyphal/public_regulated_data_types:$HOME/.cyphal/zubax/zubax_dsdl"
