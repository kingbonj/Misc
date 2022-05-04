# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

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

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi
# Colours

BLACK='\e[0;30m'
BLUE='\e[0;34m'
GREEN='\e[0;32m'
CYAN='\e[0;36m'
RED='\e[0;31m'
PURPLE='\e[0;35m'
BROWN='\e[0;33m'
LIGHTGREY='\e[0;37m'
DARKGREY='\e[1;30m'
LIGHTBLUE='\e[1;34m'
LIGHTGREEN='\e[1;32m'
LIGHTCYAN='\e[1;36m'
LIGHTRED='\e[1;31m'
LIGHTPURPLE='\e[1;35m'
YELLOW='\e[0;33m'
LIGHTYELLOW='\e[1;33m'
WHITE='\e[1;37m'
NC='\e[0m' # No Color
ITALIC='\e[3m'
BOLD='\e[1m'
ITALIC='\e[3m'
DIM='\e[2m'
BLINK='\e[5m'

if [ "$color_prompt" = yes ]; then
    PS1='[\[\033[0;31m\]\D{%H:%M}\e[0m]${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u\[\033[01;32m\]@\[\033[01;32m\]\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;31m\]\u@\h:\w\$ '
fi

# unset color_prompt force_color_prompt
# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'

fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

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

clear 

# Custom Alias 

alias uuaa='sudo apt update && sudo apt upgrade && sudo apt dist-upgrade && sudo apt autoremove && sudo apt clean'
alias sources='sudo pluma /etc/apt/sources.list'
alias bashrc='pluma ~/.bashrc'
alias h="history | grep "
alias dos='mplayer -quiet -msgcolor http://liquiddoom.net:8000/dos'
alias midi='timidity /home/ben/Music/MIDI\ Favourites/'
alias e='exit'
alias q='exit'
alias wp='wikipedia2text'

printf "\n$NC"
printf "Date: ${YELLOW}$(date)$NC"
printf "       Uptime: $BLUE$(uptime -p)$NC"
printf "\n\n$GREY$ITALIC$DIM"
fortune romero
printf "\n$NC"
printf ">$LIGHTPURPLE$(pwd)$NC\n"
ls
printf "\n"

# Setting the backlight from terminal 

kb(){
sudo pkexec bash -c 'echo -n '$1' > /sys/class/leds/chromeos::kbd_backlight/brightness'
}

# Wikipedia2text functions

# Print full

wiki(){
if [ $# -eq 0 ]; then  
    printf "wiki [wikipedia article query]\nUsage:  wiki <searchterm>\n"
elif [ $# -eq 1 ]; then  
    wikipedia2text -i $1 $1
elif [ $# -eq 2 ]; then
    wikipedia2text -i "$1 $2" "$1 $2"
elif [ $# -eq 3 ]; then
    wikipedia2text -i "$1 $2 $3" "$1 $2 $3"
elif [ $# -eq 4 ]; then
    wikipedia2text -i "$1 $2 $3 $4" "$1 $2 $3 $4"
fi
}

#print summary
wikisum(){
if [ $# -eq 0 ]; then  
    printf "wikisum [outputs article summary]\nUsage:  wikisum <searchterm>\n"
elif [ $# -eq 1 ]; then
    wikipedia2text -si "$1" "$1"
elif [ $# -eq 2 ]; then
    wikipedia2text -si "$1 $2 $3" "$1 $2 $3"
elif [ $# -eq 3 ]; then
    wikipedia2text -si "$1 $2 $3" "$1 $2 $3"
elif [ $# -eq 4 ]; then
    wikipedia2text -si "$1 $2 $3 $4" "$1 $2 $3 $4"
fi
}

#print list of sections
wikisec(){

if [ $# -eq 0 ]; then  
    printf "wikisec [gets list of sections]\nUsage:  wikisec <searchterm>\n"
elif [ $# -eq 1 ]; then
    wikipedia2text -t "$1"
elif [ $# -eq 2 ]; then
    wikipedia2text -t "$1 $2"
elif [ $# -eq 3 ]; then
    wikipedia2text -t "$1 $2 $3" 
elif [ $# -eq 4 ]; then
    wikipedia2text -t "$1 $2 $3 $4" 
fi
}

#print section
wikips(){
if [ $# -eq 0 ]; then  
printf "wikips [prints a section]\nUsage:  wikips <article> <section_name>\n"
else
wikipedia2text -i "$2" -T "$2" "$1"
fi
}

wikisearch(){
search=$1
search=`sed 's/ /%20/g' <<< $search`
inp=`curl -s -H "Accept:application/json" "https://en.wikipedia.org/w/api.php?action=opensearch&format=json&redirects=return&search=$search"`
length=10
echo -e "\nTop relevant searches:\n"
for i in `seq 0 $((length-1))`
do
    output=`jq --argjson i "$i" '.[1][$i]' <<< $inp`
    echo -e "\033[0;35m $output"
    output=`jq --argjson i "$i" '.[3][$i]' <<< $inp` 
    echo -e "${output}\n"
    printf ${output}" ">> ~/Search.txt
done
echo -e "\033[0m"
}


# Coloured man-pages
if $_isxrunning; then
  export PAGER=less
  export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking
  export LESS_TERMCAP_md=$'\E[01;38;5;74m'  # begin bold
  export LESS_TERMCAP_me=$'\E[0m'           # end mode
  export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
  export LESS_TERMCAP_so=$'\E[38;5;246m'    # begin standout-mode - info box
  export LESS_TERMCAP_ue=$'\E[0m'           # end underline
  export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline
fi

# Show contents of the directory after changing to it
function cd () {
    builtin cd "$1"
    ls
}
