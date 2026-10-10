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

alias emacs='flatpak run org.gnu.emacs'

# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
setopt autocd extendedglob
bindkey -v

export PATH=~/.local/bin:/home/ryan/go/bin:/home/ryan/.pixi/bin:$PATH:/usr/local/cuda-13.3/bin
# opencode
export PATH=/home/ryan/.opencode/bin:$PATH

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
export MAMBA_EXE='/home/ryan/miniforge3/bin/mamba';
export MAMBA_ROOT_PREFIX='/home/ryan/miniforge3';
__mamba_setup="$("$MAMBA_EXE" shell hook --shell zsh --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__mamba_setup"
else
    alias mamba="$MAMBA_EXE"  # Fallback on help from mamba activate
fi
unset __mamba_setup
# <<< mamba initialize <<<
