#!/bin/bash
# Change directory aliases
alias home='cd ~'
alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

alias activate="source ./.venv/bin/activate"
alias gdb="gdb -q"
alias clc='clear'
alias c='clear'
alias mv='mv -i -v'
alias cp='cp -v'
alias rm='rm -i -v'
alias ln='ln -i'

alias lr='ls -t | head -n 5'
alias la='ls -Alh' # show hidden files
alias ls='ls -aFh --color=always' # add colors and file type extensions
alias lu='du -sh * | sort -h' 
alias ll='ls -Fls' # long listing format

alias watch='watch -n1'
alias diff='diff --color'
alias ports='nmap localhost'
alias untar='tar -zxvf'

alias mkvenv='python3 -m venv .venv; source ./.venv/bin/activate'
alias mkserver='python3 -m http.server 8000'

alias copy='xclip -i'
alias paste='xclip -o'
alias copywd='pwd | xclip -i'
alias pastewd='cd $(xclip -o)'

alias v='nvim'
alias vi='nvim'
alias vim='nvim'
alias more='less'
alias chx='chmod +x'

alias ip4='ip -o -4 addr show | awk "{print NR\": \"\$2\": \"\$4}"'
alias ipa='ip -o -4 addr show | awk "{print NR\": \"\$2\": \"\$4}"'
alias ips='ip -o -4 addr show | awk "{print NR\": \"\$2\": \"\$4}"'

# To have colors for ls and all grep commands such as grep, egrep and zgrep
export CLICOLOR=1
export LS_COLORS='no=00:fi=00:di=00;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:*.xml=00;31:'
#export GREP_OPTIONS='--color=auto' #deprecated
alias grep="/usr/bin/grep $GREP_OPTIONS"
unset GREP_OPTIONS

# Color for manpages in less makes manpages a little easier to read
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'
