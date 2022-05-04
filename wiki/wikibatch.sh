#!/bin/bash

# Depends upon wikipedia2text

if [ $# -eq 0 ]; then
    echo -e "Wikipedia Batch Downloader"
    echo "Downloads wikipedia page(s) and saves text files"
    echo "Use parmeters <Article Title> <Next Article Title> etc..."
    exit
fi

dir=~/Wikidl
t=0

for arg
do
    wikipedia2text "$arg" > $dir/$arg.txt
    printf "$arg.txt saved to $dir\n"
    t=$(($t + 1))
done


printf "Successfully downloaded $t files\n"
cd $dir
printf "\n>$(pwd)\n"
ls --color=auto
printf "\n"
exit

if [ $arg == '"*' ]; then
    p1=$arg
    shift
    p2=$arg
    p3="$p1\_$p2"
    wikipedia2text "$p3" > $dir/$p1_$p2.txt
    printf "$p3.txt saved to $dir\n"
    t=$(($t + 1))

    else
