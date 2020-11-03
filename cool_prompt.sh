#!/bin/bash

#############
# DS prompt #
#############

# Define symbols
SYMBOL_OK='✔'
SYMBOL_ERROR='✘'
SYMBOL_INCOMING_CHANGES='⤵'
SYMBOL_OUTGOING_CHANGES='⤴'
SYMBOL_SEPARATOR=''

# Define colors
BG_GRAY='\[\e[48;5;235m\]'
BG_BLUE='\[\e[48;5;017m\]'
BG_BROWN='\[\e[48;5;237m\]'
BG_CYAN='\[\e[48;5;031m\]'
BG_SALAD='\[\e[48;5;078m\]'

FG_RED='\[\e[38;5;196m\]'
FG_GREEN='\[\e[38;5;118m\]'
FG_YELLOW='\[\e[33m\]'
FG_CYAN='\[\e[38;5;031m\]'
FG_BLUE='\[\e[38;5;017m\]'
FG_WHITE='\[\e[38;5;015m\]'
FG_BLACK='\[\e[30m\]'
FG_PURPLE='\[\e[35m\]'
FG_GRAY='\[\e[38;5;235m\]'
FG_BROWN='\[\e[38;5;237m\]'
FG_SALAD='\[\e[38;5;078m\]'

FG_BOLD_RED='\[\e[1;31m\]'
FG_BOLD_GREEN='\[\e[1;32m\]'
FG_BOLD_YELLOW='\[\e[1;33m\]'
FG_BOLD_CYAN='\[\e[1;36m\]'
FG_BOLD_BLUE='\[\e[1;34m\]'
FG_BOLD_WHITE='\[\e[1;37m\]'
FG_BOLD_BLACK='\[\e[1;30m\]'
FG_BOLD_PURPLE='\[\e[1;35m\]'

COLOR_OFF='\[\e[0m\]'


branch_name() {
	if hg branch >/dev/null 2>&1;then
	    branch_name="$(hg branch 2> /dev/null | awk '{print $1}')"
	fi

	if [ ! $branch_name = "" ]; then
	    echo "[hg: ${branch_name}]"
	else
	    if git status >/dev/null 2>&1;then
    		branch_name="$(git symbolic-ref --short HEAD 2>/dev/null || git describe --tags --always 2>/dev/null)"
	    fi
    
	    if [ ! $branch_name = "" ]; then
    		echo "[git: ${branch_name}]"
	    fi
	fi
}

ds_prompt1() {
    if [ $? -eq 0 ]; then
        EXIT_STATUS="${FG_BOLD_GREEN}${SYMBOL_OK}${COLOR_OFF}"
    else
        EXIT_STATUS="${FG_BOLD_RED}${SYMBOL_ERROR}${COLOR_OFF}"
    fi

    PS1='\[\e]0;\u@\H:\w\a\]' # Set terminal title

    PS1+="[${EXIT_STATUS}]"

    PS1+="${FG_CYAN}[\t]${COLOR_OFF}" # Show time

    if [[ ${EUID} == 0 ]] ; then
        PS1+="{${FG_BOLD_RED}\u@\H${COLOR_OFF}}${FG_WHITE}`branch_name`${COLOR_OFF}─> ${FG_YELLOW}\w${COLOR_OFF} #"
    else
        PS1+="[${FG_BOLD_GREEN}\u@\H${COLOR_OFF}]${FG_WHITE}`branch_name`${COLOR_OFF}─> ${FG_YELLOW}\w${COLOR_OFF} $"
    fi

    history -a
    history -r
}

ds_prompt2() {
    if [ "$?" -eq 0 ]; then
	    local EXIT_CODE_SYMBOL=" ${SYMBOL_OK}"
	    local EXIT_CODE_FG_COLOR="${FG_BOLD_GREEN}"
    else
	    local EXIT_CODE_SYMBOL=" ${SYMBOL_ERROR}"
	    local EXIT_CODE_FG_COLOR="${FG_BOLD_RED}"
    fi

    PS1='\[\e]0;\u@\H:\w\a\]' # Set terminal title
    PS1+="${BG_GRAY}${EXIT_CODE_FG_COLOR}${EXIT_CODE_SYMBOL}${COLOR_OFF}${FG_GRAY}${BG_BLUE}${SYMBOL_SEPARATOR}" # Show exit status
    PS1+="${FG_WHITE} \t ${FG_BLUE}${BG_BROWN}${SYMBOL_SEPARATOR}" # Show time

    if [[ ${EUID} == 0 ]] ; then
        local USER_FG_COLOR="${FG_RED}"
    else
        local USER_FG_COLOR="${FG_GREEN}"
    fi

    PS1+="${USER_FG_COLOR} \u@\H ${BG_CYAN}${FG_BROWN}${SYMBOL_SEPARATOR}" # Show user

    local current_branchname=$(branch_name)

    if ! [ "${current_branchname}" = "" ]; then
        PS1+="${FG_WHITE} \w ${BG_SALAD}${FG_GRAY}${current_branchname}${COLOR_OFF}${FG_SALAD}${SYMBOL_SEPARATOR}${COLOR_OFF}" # Show pwd with branch
    else
        PS1+="${FG_WHITE} \w ${COLOR_OFF}${FG_CYAN}${SYMBOL_SEPARATOR}${COLOR_OFF}" # Show pwd without branch
    fi

    history -a
    history -r
}

if ! [ "${MC_SID}" = "" ]; then
    TERM_PROGRAM="midnight_commander"
fi

if [ "$TERM_PROGRAM" = "vscode" ] || [ "$TERM_PROGRAM" = "midnight_commander" ]; then
	export PROMPT_COMMAND=ds_prompt1
else
    export PROMPT_COMMAND=ds_prompt2
fi

export HISTCONTROL=ignoreboth
export HISTSIZE=5000
export EDITOR=mcedit

# Aliases
alias ll='ls -la --color=auto'
alias lh='ls -lah --color=auto'
alias grep='grep --color=auto'
alias pn='ping -c4 8.8.8.8'
alias tf='tail -f'
alias df='df -h'
alias di='docker images'
alias ds='docker ps -a'
alias dr='docker rm --force `docker ps -qa`'
alias dclean="docker ps -a | grep Exited | awk '{print $1}' | xargs -r docker rm >/dev/null 2>&1 && docker images --no-trunc | grep none | awk '{print $3}' | xargs -r docker rmi >/dev/null 2>&1"
alias ju='journalctl -u'
alias ss='systemctl status'
alias sre='systemctl restart'
alias sdr='systemctl daemon-reload'
alias sf='systemctl --failed'
alias pj='ps -ef | grep java'
alias g='googler --count 5'
alias ls='ls --color=auto'
alias dl='docker logs'
alias dstop='docker stop'
alias drm='docker rm'
alias dr='docker rm --force `docker ps -qa`'
alias dclean="docker ps -a | grep Exited | awk '{print $1}' | xargs -r docker rm >/dev/null 2>&1 && docker images --no-trunc | grep none | awk '{print $3}' | xargs -r docker rmi >/dev/null 2>&1"
alias ssh='ssh -o "StrictHostKeyChecking no" -o "UserKnownHostsFile /dev/null"'
alias scp='scp -o "StrictHostKeyChecking no" -o "UserKnownHostsFile /dev/null"'


# If non interactive shell then end script
[[ $- != *i* ]] && return

bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
