# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

#export DEBUG=true

source ~/.bash/functions.d/log
source ~/.bash/functions.d/git-prompt
source ~/.bash/functions.d/path

log "loading $HOME/.bashrc"

TTYTYPE=`tty`
# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# don't overwrite GNU Midnight Commander's setting of `ignorespace'.
export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
# ... or force ignoredups and ignorespace
export HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"


# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
  log "loading /etc/bash_completion"
  . /etc/bash_completion
fi

# load files in order, this is important
for file_base in variables functions aliases completion rc
do 
  export _file="$HOME/.bash/$file_base"
  if [ -f "$_file" ]; then
    log "loading $_file"
    . $_file
  fi
done

# turn annoying bell off, KEEP THIS AT ANY COST!!!
if [ -n "$DISPLAY" ]; then
  xset b off
fi

