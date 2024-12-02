#!/bin/bash

# Purpose:
# Use ai to improve shell experience

# default AI model:
# ollama zephyr

ai_cmd="ollama run zephyr"

ask_ollama(){
    
    fmessage=$1
    fcontext=$2

    cat $fmessage
    #cat $fcontext
    echo -e "\n--------------------------------------------------------------------------------\n"
    #echo "Please answer in short: $input_message" | ollama run zephyr
    cat $fmessage $fcontext | $ai_cmd
}

fcontext=`mktemp`
fmessage=`mktemp`

for words in $@
do
    if [ -f $words ];
    then
	echo -n "file $words " >> $fmessage
	echo "File $words:" >> $fcontext
	cat $words >> $fcontext
	echo "" >> $fcontext
    else
	echo -n "$words " >> $fmessage
    fi
done

ask_ollama $fmessage $fcontext

rm $fcontext
rm $fmessage

#alias aa="ask_in_line $fcontext"
