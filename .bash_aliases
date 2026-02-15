#!/bin/bash

alias activate="source ./.venv/bin/activate"
alias gdb="gdb -q"
alias clc='clear'
alias c='clear'
alias mv='mv -i -v'
alias cp='cp -v'
alias rm='rm -i -v'

alias ln='ln -i'
alias lr='ls -t | head -n 5'
alias lu='du -sh * | sort -h' 
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

alias v='vim'
alias chx='chmod +x'

alias ip4='ip -o -4 addr show | awk "{print NR\": \"\$2\": \"\$4}"'
alias ipa='ip -o -4 addr show | awk "{print NR\": \"\$2\": \"\$4}"'

alias more='less'

bind "set completion-ignore-case on"
shopt -s cdspell

mkcd() {
    mkdir -p "$*"
    cd "$*"
}

export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking
export LESS_TERMCAP_md=$'\E[01;38;5;74m'  # begin bold
export LESS_TERMCAP_me=$'\E[0m'           # end mode
export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
export LESS_TERMCAP_so=$'\E[38;5;246m'    # begin standout-mode - info box
export LESS_TERMCAP_ue=$'\E[0m'           # end underline
export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline