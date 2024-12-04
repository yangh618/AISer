#!/bin/bash

# Purpose: Use ai to improve shell experience
# Default AI model: Ollama Zephyr

source aiser_fuzzy.sh 
source aiser_clear.sh 

# Purpose: Use ai to improve shell experience
# Default AI model: Ollama Zephyr

ai_cmd="ollama run zephyr"

function ask_ollama() {
  fmessage=$1
  fcontext=$2
  
  cat $fmessage
  #cat $fcontext
  echo -e "\n--------------------------------------------------------------------------------\n"
  #echo "Please answer in short: $input_message" | ollama run zephyr
  cat $fmessage $fcontext | $ai_cmd
}

################################################################################
# add options
aiser=be_fuzzy			# use a fuzzy completion mode
#aiser=be_clear			# use a clear completion mode
keywords="be concise"			# addtional keywords, e.g. "be concise", "be short", "be technical", ...

$aiser $@ $keywords


