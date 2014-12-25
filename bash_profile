#
# ~/.bash_profile
#

export HISTCONTROL=ignoredups:ignorespace

if [ -f ~/.bashrc ]; then
   source ~/.bashrc
fi

export PS1="\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[34;1m\]\w\[\033[m\]\$ "
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

alias ls='ls -GFh --color=always'

# further enhance colored ls output
eval $(dircolors -b)

alias grep='grep --color=auto'

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