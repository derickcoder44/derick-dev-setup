export CPPFLAGS="-I/opt/homebrew/opt/qt@5/include"
export PKG_CONFIG_PATH="/opt/homebrew/opt/qt@5/lib/pkgconfig"
export LDFLAGS="/opt/homebrew/opt/qt@5/lib"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/derickmathews/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
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


# Cyphal/UAVCAN DSDL lookup paths
export CYPHAL_PATH="$HOME/.cyphal/public_regulated_data_types:$HOME/.cyphal/zubax/zubax_dsdl"
