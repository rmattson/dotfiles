eval "$(starship init zsh)"

local scripts_to_source=(
	~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
	~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
)

autoload -Uz compinit
compinit

for script_file in "${scripts_to_source[@]}"; do
	if [ -r "$script_file" ]; then
		source "$script_file"
	else
		print -P "%F{yellow}Warning:%f Script not found: $script_file"
	fi
done

unset scripts_to_source script_file

# Fedora's openssh-clients ships an enabled ssh-agent.socket; only fall back to
# it so we don't clobber a keyring agent or a forwarded SSH_AUTH_SOCK.
if [[ -z "$SSH_AUTH_SOCK" && -n "$XDG_RUNTIME_DIR" && -S "$XDG_RUNTIME_DIR/ssh-agent.socket" ]]; then
	export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
fi

if [[ -o interactive && -f ~/.ssh/id_ed25519 ]] && ! ssh-add -l >/dev/null 2>&1; then
	ssh-add ~/.ssh/id_ed25519
fi

autoload -Uz select-word-style
select-word-style normal
zstyle ':zle:*' word-style unspecified

# autocompletion using arrow keys (based on history)
bindkey '\e[A' history-beginning-search-backward
bindkey '\e[B' history-beginning-search-forward

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' # lower case matches both cases
zstyle ':completion:*' menu select # improve completion menu style
zstyle ':completion:*' completer _complete _approximate # error tolerance in completion

alias ls='ls --color=auto'
alias ll='ls -alF'

command -v flatpak >/dev/null && alias emacs='flatpak run org.gnu.emacs'

# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
setopt autocd extendedglob
bindkey -v

typeset -U path
# /usr/local/cuda is the alternatives symlink, so this survives CUDA upgrades.
path=("$HOME/.local/bin" "$HOME/go/bin" "$HOME/.pixi/bin" /usr/local/cuda/bin "$HOME/.opencode/bin" $path)

function y() {
		local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}


# >>> mamba initialize >>>
# !! Contents within this block are managed by 'mamba shell init' !!
export MAMBA_EXE="$HOME/miniforge3/bin/mamba";
export MAMBA_ROOT_PREFIX="$HOME/miniforge3";
__mamba_setup="$("$MAMBA_EXE" shell hook --shell zsh --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__mamba_setup"
else
    alias mamba="$MAMBA_EXE"  # Fallback on help from mamba activate
fi
unset __mamba_setup
# <<< mamba initialize <<<

# Set up miniforge inference shell (activates base, then cudabuild).
# GPU-box only: defined only where miniforge is actually installed.
if [[ -d "$HOME/miniforge3" ]]; then
  miniforge-setup() {
    source "$HOME/miniforge3/bin/activate"
    mamba activate cudabuild
  }
fi

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
