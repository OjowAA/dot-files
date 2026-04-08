#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Set the default editor
EDITOR=vim
VISUAL=vim

if [ -f /usr/share/bash-completion/bash_completion ]; then
	. /usr/share/bash-completion/bash_completion
elif [ -f /etc/bash_completion ]; then
	. /etc/bash_completion
fi

# Source user-defined aliases if file exists
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Optional: add color support for 'ls' and 'grep'
if [ -x /usr/bin/dircolors ]; then
    eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
fi

# Optional: enable auto-cd (type directory name to cd)
shopt -s autocd

# Optional: nicer tab completion
bind 'set show-all-if-ambiguous on'
bind 'set colored-stats on'
bind 'TAB:menu-complete'
bind "set completion-ignore-case on"
shopt -s cdspell
shopt -s checkwinsize
shopt -s histappend

export PS1='\n\[\e[1;92m\]\u@\h\[\e[0m\]:\[\e[38;5;39m\]\w\[\e[0m\]\$ '

# History settings (optional but useful)
HISTSIZE=2000
HISTFILESIZE=6000
HISTCONTROL=ignoredups:erasedups
shopt -s histappend
#PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

if (command -v starship > /dev/null); then
	eval "$(starship init bash)"
fi
