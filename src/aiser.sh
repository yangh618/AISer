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

#aiser=be_fuzzy
aiser=be_clear
keywords=""

$aiser $@ $keywords

# add options

