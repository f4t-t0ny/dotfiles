# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples
#cd

#export DEBUG=true

#load logger function
source ~/.bash/functions.d/log
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

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
  debian_chroot=$( cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
  xterm-color) color_prompt=yes;;
esac


#source ~/.git-prompt.sh
ROOT_PROMPT_COLOR='38;5;197m' # red
USER_PROMPT_COLOR='38;5;141m' # dark green
DIRECTORY_COLOR='38;5;81m'
GIT_BRANCH_COLOR='38;5;197m'
DOLLAR_COLOR='38;5;148m'

if [[ $TERM == 'xterm' ]]; then 
  if [[ $EUID == 0 ]] ; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[${ROOT_PROMPT_COLOR}\]\u@\h\[\033[${DIRECTORY_COLOR}\] \W \[\033[${DOLLAR_COLOR}\]\$\[\033[00m\] '
  else
    PS1='${debian_chroot:+($debian_chroot)}\[\033[${USER_PROMPT_COLOR}\]\u@\h\[\033[${DIRECTORY_COLOR}\] \W\[\033[${GIT_BRANCH_COLOR}\]$(__git_ps1) \[\033[${DOLLAR_COLOR}\]\$\[\033[00m\] '
  fi
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
  log "loading /etc/bash_completion"
  . /etc/bash_completion
fi


for file in ~/.bash/*;
  do if [ -f "$file" ]; then
    log "loading $file"
    . $file
  fi
done

# turn annoying bell off, KEEP THIS AT ANY COST!!!
if [ -n "$DISPLAY" ]; then
xset b off
fi

