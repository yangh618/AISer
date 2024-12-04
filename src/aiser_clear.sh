#!/bin/bash

###################################################################################################################
# A clear completion for an AI query.										  #
# 														  #
# Its mechanism is to loop over all words in your query and react based on the keywords you provide.
#
# List of keywords (case sensitive):
# file: followed by a single file
# files: followed by a list of files. The end of files will be determined through checking existance of each word
# directory (or dir): followed a single directory
# directories (or dirs): follow by a list of directories
###################################################################################################################


function be_clear(){

    # make temporay files
    fcontext=$(mktemp)
    fmessage=$(mktemp)


    while [[ $# -gt 0 ]];
    do
	case $1 in
	    # single file
	    "file" | "File" | "FILE" | "fiel" | "feil" | "flie" | "flie" | "feli")
		fname=$2
		echo -n "file " >> $fmessage
		# if this word is a readable file in current directory
		if [ -f $fname ]; then
		    echo -n "$fname " >> $fmessage
		    echo "File $fname:" >> $fcontext
		    cat $fname >> $fcontext
		    echo "File $fname ends here." >> $fcontext
		    echo "" >> $fcontext
		fi
		shift
		shift
		;;

	    # multiple files
	    "files" | "Files" | "FILES" | "FILEs" | "fiels" | "flies" | "feils")
		shift
		fname=$1
		echo -n "files " >> $fmessage
		while [ -f $fname ];
		do
		    echo -n "$fname " >> $fmessage
		    echo "File $fname:" >> $fcontext
		    cat $fname >> $fcontext
		    echo "File $fname ends here." >> $fcontext
		    echo "" >> $fcontext

		    shift
		    if [ $# -eq 0 ]; then
			break
		    fi
		    fname=$1
		done
		;;

	    # single directory
	    "directory" | "Directory" | "DIRECTORY" | "dir" | "Dir" | "DIR")
		word=$2
		echo -n "directory " >> $fmessage
		if [ -d $word ]; then
		    echo -n "$word " >> $fmessage
		    echo "Contents in directory $word:" >> $fcontext

		    # list all files in directory $word.
		    # Recursively? This could take quite long time for a large directory. 
		    # ls -alR $word >> $fcontext
		    # Let's be easy with the fuzzy
		    ls -al --full-time $word >> $fcontext

		    echo "Directory $word ends here." >> $fcontext
		    echo "" >> $fcontext
		fi
		shift
		shift
		;;

	    # multiple directories
	    "directories" | "Directories" | "DIRECTORIES" | "DIRS" | "dirs" | "Dirs")
		shift
		word=$1
		echo -n "directory " >> $fmessage
		while [ -d $word ];
		do 
		    echo -n "$word " >> $fmessage
		    echo "Contents in directory $word:" >> $fcontext

		    # list all files in directory $word.
		    # Recursively? This could take quite long time for a large directory. 
		    # ls -alR $word >> $fcontext
		    # Let's be easy with the fuzzy
		    ls -al --full-time $word >> $fcontext

		    echo "Directory $word ends here." >> $fcontext
		    echo "" >> $fcontext
		    shift
		    if [ $# -eq 0 ];  then
			break
		    fi
		    word=$1
		done
		;;

	    # Unknown keywords
	    *)
		echo -n "$1 " >> $fmessage
		shift
		;;

	esac

    done
    
    # add two empty line to separate messgae and context
    echo "" >> $fmessage
    
    ask_ollama $fmessage $fcontext
    rm $fcontext
    rm $fmessage
}
