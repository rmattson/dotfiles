# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# some linux-only options here
if [ "$(uname)" == "Linux" ]; then
	# set variable identifying the chroot you work in (used in the prompt below)
	if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
	    debian_chroot=$(cat /etc/debian_chroot)
	fi

	# set a fancy prompt (non-color, unless we know we "want" color)
	case "$TERM" in
	    xterm-color) color_prompt=yes;;
	esac
fi

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Check for running osx and add brew-specific to path
if [ "$(uname)" == "Darwin" ]; then 
	export PATH=$(brew --prefix coreutils)/libexec/gnubin:$PATH
fi

export PATH=~/bin:/usr/local/bin:$PATH

export PS1="\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[34;1m\]\w\[\033[m\]\$ "
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls -GFh --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# mkdir: create dir and entire hierarchy; verbose
alias mkdir='mkdir -p -v'

# mv: timeout after 8 seconds;
# confirm 3 or more files;
# don't store in history;
# list ops in progress
alias mv=' timeout 8 mv -iv'

# rm: timeout after 3 seconds;
# confirm 3 or more files;
# list ops in progress;
# don't involve more than one filesystem;
# don't store self in shell history;
alias rm=' timeout 3 rm -Iv --one-file-system'

# shred: timeout after 3 seconds;
# list ops in progress;
# don't store self in shell history
alias shred=' timeout 3 shred -v'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

if [ "$(uname)" == "Linux" ]; then
	VIRTUALENVWRAPPER_PYTHON='/usr/bin/python3'
	source /usr/local/bin/virtualenvwrapper.sh
fi

if [ "$(uname)" == "Darwin" ]; then
	VIRTUALENVWRAPPER_PYTHON='/usr/local/bin/python3'
	source /usr/local/bin/virtualenvwrapper.sh
fi