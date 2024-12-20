#!/bin/bash

###################################################################################################################
# A fuzzy completion for an AI query.										  #
# 														  #
# Its mechanism is to loop over all words in your query and check if it is a directory or file.			  #
# For a file, a keyword "file" will be attached and its content will be appended at the your query.		  #
# For a directory, a keyword "directory" will be attached and its content will be listed at the end of your query #
###################################################################################################################


function be_fuzzy(){

    # make temporay files
    fcontext=$(mktemp)
    fmessage=$(mktemp)

    # loop over all words in your query
    for word in "$@"; do
	
	# if this word is a readable file in current directory
	if [ -f $word ]; then
	    echo -n "file $word " >> $fmessage
	    echo "File $word:" >> $fcontext
	    cat $word >> $fcontext
	    echo "File $word ends here." >> $fcontext
	    echo "" >> $fcontext
	    continue
	fi

	# if this word is a directory
	if [ -d $word ]; then
	    echo -n "directory $word " >> $fmessage
	    echo "Files in directory $word:" >> $fcontext
	    
	    # list all files in directory $word.
	    # Recursively? This could take quite long time for a large directory. 
	    # ls -alR $word >> $fcontext
	    # Let's be easy with the fuzzy
	    ls -al --full-time $word >> $fcontext
	    
	    echo "Directory $word ends here." >> $fcontext
	    echo "" >> $fcontext
	    continue
	fi

	echo -n "$word " >> $fmessage
    done

    # add two empty line to separate messgae and context
    echo "" >> $fmessage
    
    ask_ollama $fmessage $fcontext
    rm $fcontext
    rm $fmessage
}


#be_fuzzy $@
