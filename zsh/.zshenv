export XDG_CONFIG_HOME="$HOME/.config/"
export EDITOR=vim

path+=('/home/ryan/.local/bin' $path)
path+=($path '/usr/local/go/bin')
export PATH
. "$HOME/.cargo/env"
