#!/bin/bash

# Depends upon wikipedia2text

# Tracker
TRACKER=0

# Colours used by this script

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
RESET='\e[0m' # No Color
ITALIC='\e[3m'
BOLD='\e[1m'
ITALIC='\e[3m'
DIM='\e[2m'
BLINK='\e[5m'

# If no parameters > show help

if [ $# -eq 0 ]; then
    echo -e "$BLUE""Wikipedia Downloader v1.0                               Benjamin Leeves 2022$RESET"
    echo "Downloads wikipedia page(s) and saves to text file"
    printf "\n"
    echo "Usage: ${0##*/}"
    echo "          <Word 1> | <Word 1> <Word 2> | <Word 1> <Word 2> <Word 3>..."
    printf "\n"
    echo "(Double-worded articles can only be downloaded individually)"
    echo "Remember - input is case-sensitive!"
    exit
fi

# Welcome message

    printf "$BLUE$DIM""Welcome to the Wikipedia Downloader$RESET\n"

# Make Wiki directory if it does not exist

dir=~/Wikidl

if [[ ! -e $dir ]]; then
    mkdir $dir
    echo "Directory $dir created" 1>&2
elif [[ ! -d $dir ]]; then
    echo "$dir already exists but is not a directory" 1>&2
fi

# Download text based on arguments
if [ $# -eq 2 ]; then
    wikipedia2text "$1 $2" > $dir/$1_$2.txt
    printf "    $GREEN$DIM$1_$2.txt$RESET saved to $PURPLE$dir\n$RESET"
    TRACKER=$(($TRACKER + 1))
else
for arg
do
    wikipedia2text "$arg" > $dir/$arg.txt
    printf "    $GREEN$DIM$arg.txt$RESET saved to $PURPLE$dir\n$RESET"
    TRACKER=$(($TRACKER + 1))
done
fi

# Print summary and return to command prompt

summary(){
printf "$BLUE$DIM""\nSuccessfully downloaded $RED$TRACKER$BLUE$DIM files$RESET\n"
cd $dir
printf "\n>$LIGHTPURPLE$(pwd)$RESET\n"
ls --color=auto
printf "\n"
exit
}

# Download function

download(){

if [ $# -eq 2 ]; then
    wikipedia2text "$1 $2" > $dir/$1_$2.txt
    printf "    $GREEN$DIM$1_$2.txt$RESET saved to $PURPLE$dir\n$RESET"
    TRACKER=$(($TRACKER + 1))
else
for arg
do
    wikipedia2text "$arg" > $dir/$arg.txt
    printf "    $GREEN$DIM$arg.txt$RESET saved to $PURPLE$dir\n$RESET"
    TRACKER=$(($TRACKER + 1))
done
fi
}

download

# Ask for input

userprompt(){
printf "$BLUE$DIM""Next article or q: $RESET"
read ANSWER
if [ "$ANSWER" = "q" ]; then
    summary
else
download $ANSWER
userprompt
fi
}

userprompt
