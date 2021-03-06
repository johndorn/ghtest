# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

PS1='\[\e[31;40m\]\w\e[0m\n\[\e[32;40m\]\u@\h:\!:\$\[\e[0m\] '

# make caps lock control
setxkbmap -option ctrl:nocaps

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

color_prompt=yes

if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

alias tmux='TERM=xterm-256color tmux'
alias gimme='sudo apt-get install'
alias ls='ls --color=auto'
alias ll='ls -hl'
alias l='ls -lA'
alias lr='ls -lArt'
alias lt='ls -Alt'
alias cls='clear'
alias rm='rm -i'
alias chmox='chmod +x'
alias shparent='ps -o command -p $PPID'
alias vi='vim -p'
alias ..='cd ..'
alias slog='svn log --stop-on-copy'
alias svn-revlog='svn log --stop-on-copy'
alias svn-changelog='svn diff -r`svn log --stop-on-copy | grep -P "^r\d+" | sort | head -n 1 | cut -d "|" -f 1 | sed "s/\s//g"`:HEAD . --summarize'
alias svn-changes='svn diff -r`svn log --stop-on-copy | grep -P "^r\d+" | sort | head -n 1 | cut -d "|" -f 1 | sed "s/\s//g"`:HEAD .'
alias open-tunnel='ssh -XR 45856:localhost:22 dorn@nate-linode "TERM=xterm watch cat keep_alive_msg"'
alias srcrr='node /home/dorn/devel/manta/srcrr-client/srcrr'
#alias solrlog='ssh tomcat@ecnext38.ecnext.com 'tail -f `ls -r1 /rpt/src/tomcat/instances/dev/us/mb-shards-single-tomcat/logs/catalina* | head -n 1`''
alias nm='nodemon -e conf,json,js,html,css'
alias gs='git status'
alias dc='docker-compose'
alias frup='cd ~/devel/manta/manta-frontend; tmux'
alias gdiff='git diff --no-prefix'
alias vdiff='git diff --no-prefix | vim -'
alias gpo='git push origin'

function vichanges() {
  vim -p `git status | grep modified | cut -d ' ' -f 4 | tr '\n' ' '`;
}

function mgrep() { 
  grep -Pirn --exclude-dir=node_modules --exclude-dir=bower_components $1 * | grep -Pv 'generated|instrumented|report' | grep -Pi $1; 
}

function vgrep() {
  vim +/\\c$1 -p `mgrep $1 2>/dev/null | cut -d ':' -f 1`
}

function json() {
  cat $1 | python -m json.tool
}

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
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

PATH=$PATH:/home/dorn/bin

function svncd {
	cd $1;
	if svn info
	then
		URL=`svn info | grep 'URL' | sed 's/URL: //'`;
		svn switch $URL;
	else
		echo "Not a valid svn directory";
		cd -;
	fi
}

SSH_ENV="$HOME/.ssh/environment"
  
# start the ssh-agent
function start_agent {
    echo "Initializing new SSH agent..."
    # spawn ssh-agent
    ssh-agent | sed 's/^echo/#echo/' > "$SSH_ENV"
    echo succeeded
    chmod 600 "$SSH_ENV"
    . "$SSH_ENV" > /dev/null
    ssh-add
}
  
# test for identities
function test_identities {
    # test whether standard identities have been added to the agent already
    ssh-add -l | grep "The agent has no identities" > /dev/null
    if [ $? -eq 0 ]; then
        ssh-add
        # $SSH_AUTH_SOCK broken so we start a new proper agent
        if [ $? -eq 2 ];then
            start_agent
        fi
    fi
}
  
# check for running ssh-agent with proper $SSH_AGENT_PID
if [ -n "$SSH_AGENT_PID" ]; then
    ps -ef | grep "$SSH_AGENT_PID" | grep ssh-agent > /dev/null
    if [ $? -eq 0 ]; then
    test_identities
    fi
# if $SSH_AGENT_PID is not properly set, we might be able to load one from
# $SSH_ENV
else
    if [ -f "$SSH_ENV" ]; then
    . "$SSH_ENV" > /dev/null
    fi
    ps -ef | grep "$SSH_AGENT_PID" | grep -v grep | grep ssh-agent > /dev/null
    if [ $? -eq 0 ]; then
        test_identities
    else
        start_agent
    fi
fi

EDITOR=vim
export EDITOR

alias v='vi'
nless='less -N'

export ORACLE_HOME=/usr/lib/oracle/xe/app/oracle/product/10.2.0/client
PATH=$PATH:$ORACLE_HOME/bin
export PATH

export LESSOPEN="| /usr/share/source-highlight/src-hilite-lesspipe.sh %s"
export LESS=' -R '


export NVM_DIR="/home/dorn/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm


# Maven repo for manta services
export NEXUS_USERNAME=manta_ro
export NEXUS_PASSWORD=px9tlR2IkNP60Y7D7vb2EpP6pRzdoSE7

# AWS for calls-service, etc, dynamo
export AWS_ACCESS_KEY_ID=AKIAJJ3F4GS2KMNUD7JA
export AWS_SECRET_ACCESS_KEY=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

export PLAY_ENV=dev

for i in `ls -1 ~/.ssh/*.rsa`; do ssh-add $i > /dev/null 2>&1; done

alias gitup='git pull origin master'
alias run='grunt run'
alias rundi='grunt rundi'
