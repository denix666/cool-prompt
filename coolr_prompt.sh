#!/bin/bash

#############################
# Author: Denis Salmanovich #
#############################

ds_prompt() {
    FG_LGREEN_HG="\\[\\e[38;5;078m\\]"
    FG_LGREEN_GIT="\\[\\e[38;5;040m\\]"

    FG_RED="\\[\\e[38;5;196m\\]"
    FG_GREEN="\\[\\e[38;5;118m\\]"
    FG_GRAY="\\[\\e[38;5;235m\\]"
    FG_LGRAY="\\[\\e[38;5;250m\\]"
    FG_CYAN="\\[$(tput setaf 6)\\]"
    FG_VIOLET="\\[$(tput setaf 13)\\]"
    FG_YELLOW="\\[$(tput setaf 3)\\]"
    FG_BLUE="\\[\\e[38;5;017m\\]"
    FG_LBLUE="\\[\\e[38;5;031m\\]"
    FG_MAGENTA="\\[$(tput setaf 5)\\]"
    FG_BLACK="\\[$(tput setaf 0)\\]"
    FG_WHITE="\\[\\e[38;5;015m\\]"
    FG_BROWN="\\[\\e[38;5;237m\\]"

    BG_GRAY="\\[\\e[48;5;235m\\]"
    BG_LGRAY="\\[\\e[48;5;250m\\]"
    BG_GREEN="\\[$(tput setab 2)\\]"
    BG_MAGENTA="\\[$(tput setab 5)\\]"
    BG_LGREEN_HG="\\[\\e[48;5;078m\\]"
    BG_LGREEN_GIT="\\[\\e[48;5;040m\\]"
    BG_RED="\\[\\e[48;5;235m\\]"
    BG_BLACK="\\[$(tput setab 0)\\]"
    BG_VIOLET="\\[$(tput setab 13)\\]"
    BG_BLUE="\\[\\e[48;5;017m\\]"
    BG_LBLUE="\\[\\e[48;5;031m\\]"
    BG_BROWN="\\[\\e[48;5;237m\\]"

    RESET="\\[$(tput sgr0)\\]"

    GIT_BRANCH_CHANGED_SYMBOL='+'
    GIT_NEED_PULL_SYMBOL='⇣'
    GIT_NEED_PUSH_SYMBOL='⇡'

    get_branch_name_and_show() {
	if which hg >/dev/null 2>&1;then
	    branch_name="$(hg branch 2> /dev/null | awk '{print $1}')"
	fi

	if [ ! $branch_name = "" ]; then
	    echo "${BG_LGREEN_HG}${FG_GRAY} [hg: ${branch_name}] ${RESET}${FG_LGREEN_HG}"
	else
	    if which git >/dev/null 2>&1;then
    		branch_name="$(git symbolic-ref --short HEAD 2>/dev/null || git describe --tags --always 2>/dev/null)"
	    fi
    
	    if [ ! $branch_name = "" ]; then
    		echo "${BG_LGREEN_GIT}${FG_GRAY} [git: ${branch_name}] ${RESET}${FG_LGREEN_GIT}"
	    fi
	fi
    }
    
    get_branch_name_only() {
	if which hg >/dev/null 2>&1;then
	    branch_name="$(hg branch 2> /dev/null | awk '{print $1}')"
	fi

	if [ ! $branch_name = "" ]; then
	    echo "[hg: ${branch_name}]"
	else
	    if which git >/dev/null 2>&1;then
    		branch_name="$(git symbolic-ref --short HEAD 2>/dev/null || git describe --tags --always 2>/dev/null)"
	    fi
    
	    if [ ! $branch_name = "" ]; then
    		echo "[git: ${branch_name}]"
	    fi
	fi
    }

    set_title() {
	echo -en "\033]0;$(whoami)@$(hostname):$(pwd)\a"
    }

    ps1() {
	if [ "$?" -eq 0 ]; then
	    local EXIT_CODE_SYMBOL=" ✔ "
	    local EXIT_CODE_FG_COLOR="${FG_GREEN}"
        else
	    local EXIT_CODE_SYMBOL=" ✘ "
	    local EXIT_CODE_FG_COLOR="${FG_RED}"
        fi
        
        if [[ ${EUID} == 0 ]] ; then
    	    local USER_FG_COLOR="${FG_RED}"
    	else
    	    local USER_FG_COLOR="${FG_GREEN}"
    	fi


	PS1="${BG_GRAY}${EXIT_CODE_FG_COLOR}${EXIT_CODE_SYMBOL}${BG_BLUE}${FG_GRAY}"
	PS1+="${FG_WHITE} \t ${BG_BROWN}${FG_BLUE}"
	PS1+="${USER_FG_COLOR} \u@\H ${BG_LBLUE}${FG_BROWN}"
	PS1+="${FG_WHITE} \w ${RESET}${FG_LBLUE}"
	PS1+="$(get_branch_name_and_show)"
	PS1+="${RESET}$(set_title)"
    }

    if [ "$TERM_PROGRAM" = "vscode" ]; then
	if [[ ${EUID} == 0 ]] ; then    
	    PS1="[\`if [ \$? = 0 ]; then echo \[\e[32m\]✔\[\e[0m\]; else echo \[\e[31m\]✘\[\e[0m\]; fi\`]\[\033[0;36m\][\t]\[\033[00m\] {\[\033[01;31m\]\u@\H\[\033[00m\]}─> \[\033[01;33m\]\w\[\033[00m\]\[\033[0;37m\] \$(get_branch_name_only)\[\033[0m\] #"
	else
	    PS1="[\`if [ \$? = 0 ]; then echo \[\e[32m\]✔\[\e[0m\]; else echo \[\e[31m\]✘\[\e[0m\]; fi\`]\[\033[0;36m\][\t]\[\033[00m\] {\[\033[01;32m\]\u@\H\[\033[00m\]}─> \[\033[01;33m\]\w\[\033[00m\]\[\033[0;37m\] \$(get_branch_name_only)\[\033[0m\] $"
	fi
    else
        PROMPT_COMMAND=ps1
    fi
}

ds_prompt
unset ds_prompt
