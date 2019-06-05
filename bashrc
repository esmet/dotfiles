source /etc/profile
function gcb() {
        current_branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
        if [ $? -eq 0 ]
        then
                echo git:$current_branch
        else
                echo ""
        fi
}
function kcc() {
	current_kubectx=$(grep current-context: ~/.kube/config 2>/dev/null | awk '{print $2}' 2>/dev/null)
        if [ $? -eq 0 ]
        then
                echo kube:$current_kubectx
        else
                echo ""
        fi
}
function acc() {
	current_ankhctx=$(grep current-context: ~/.ankh/config 2>/dev/null | awk '{print $2}' 2>/dev/null)
        if [ $? -eq 0 ]
        then
                echo ankh:$current_ankhctx
        else
                echo ""
        fi
}

#NORMAL="\[\033[00m\]"
#BLUE="\[\033[01;34m\]"
#YELLOW="\[\e[1;33m\]"
#GREEN="\[\e[1;32m\]"
#export PS1='[\[\e[0;33m\]\[\e\[m\]\[\e[0;32m]\w\[\e[m\]] \[\e[0;33m][$(gcb)] \[\e[0;34m][$(kcc)]\[\e[m\] $ '
#export PS1='[\[\e\[0;33m\]\[\e\[m\]\[\e\[0;32m\]\w\[\e[m\]] \[\e\[0;33m\]\[$(gcb)\]\[\e[m\] \[\e\[0;33m\]\[$(kcc)\]\[\e[m\]$ '
export PS1='[\[\e[0;33m\]\[\e[m\]\[\e[0;32m\]\w\[\e[m\]] \[\e[0;33m\][$(gcb)] [$(kcc)] [$(acc)]\[\e[m\]\n$ '

# this better fix the wraparound issues
shopt -s checkwinsize

# disable the most irritating terminal emulation feature ever known
stty -ixon

# vi bindings are great everywhere except the command line
set -o emacs

# this bundle of joy is for portable LS colors.
# I like yellow dictories because bold blue is
# impossible to see on an osx terminal
unamestr=$(uname | tr '[:upper:]' '[:lower:]')
if [ $unamestr == 'linux' ] ; then
    alias ls="ls --color=auto"
    export LS_COLORS='di=33'
elif [ $unamestr == 'darwin' ] ; then
    alias ls="ls -G"
    export CLICOLOR=1
    export LSCOLORS="DxGxcxdxCxegedabagacad"
else
    alias ls="ls"
    echo "Problem setting ls colors, uname = $unamestr"
fi

# ag rage
alias ag="ag -if"

alias grep="grep --color=auto"

# use vimdiff for git diffs so they don't suck
alias gitdiff='git difftool --tool=vimdiff'

alias io="iostat -xk 1"
alias vi="vim"
alias emacs="emacs -nw"
alias jmux="tmux -S /tmp/john.tmux"
export EDITOR=vim

# interactive for safety
alias rm="rm -i"
alias mv="mv -i"
alias ln="ln -i"
alias cp="cp -i"

# i'm used to this now
unalias reset &>/dev/null
alias realreset="$(which reset)"
alias reset="source $HOME/.bashrc && clear"

# stolen from /etc/profile
function pathmunge {
    if ! echo $PATH | egrep -q "(^|:)$1($|:)" ; then
        if [ "$2" = "after" ] ; then
            PATH=$PATH:$1
        else
            PATH=$1:$PATH
        fi
    fi
}

export PATH="/bin:/usr/bin"
pathmunge "/sbin"
pathmunge "/usr/sbin"
pathmunge "/usr/local/bin" 
pathmunge "/usr/local/sbin" 
pathmunge "$HOME/local/bin" 
pathmunge "$HOME/scripts"
pathmunge "$HOME/go/bin"

export LD_LIBRARY_PATH="/usr/lib:/usr/local/lib64:/usr/lib64:/usr/local/adnxs/lib:$HOME/local/lib:/usr/local/lib:$LD_LIRARY_PATH"
export C_INCLUDE_PATH="/usr/local/adnxs/include:$HOME/local/include:/usr/local/include:$C_INCLUDE_PATH"

shopt -s histappend
export HISTIGNORE="ls:cd ~:cd ..:exit:h:history"
export HISTCONTROL="erasedups"
export PROMPT_COMMAND="history -a" # so history flushes after each command

function h {
    pattern=$1
    history | grep $pattern
}

# ugh
if [[ -S "$SSH_AUTH_SOCK" && ! -h "$SSH_AUTH_SOCK" ]]; then
    ln -sf "$SSH_AUTH_SOCK" ~/.ssh/ssh_auth_sock;
fi
export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock;

[[ -s "/home/jesmet/.gvm/scripts/gvm" ]] && source "/home/jesmet/.gvm/scripts/gvm"
export GOPATH=$HOME/go

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

targrep () {
    for i in $(tar -tzf "$1"); do
        results=$(tar -Oxzf "$1" "$i" | grep --label="$i" -H "$2")
        echo "$results"
    done
}

# add this configuration to ~/.bashrc
export HH_CONFIG=hicolor         # get more colors
shopt -s histappend              # append new history items to .bash_history
export HISTCONTROL=ignorespace   # leading space hides commands from history
export HISTFILESIZE=10000        # increase history file size (default is 500)
export HISTSIZE=${HISTFILESIZE}  # increase history size (default is 500)
export PROMPT_COMMAND="history -a; history -n; ${PROMPT_COMMAND}"   # mem/file sync
# if this is interactive shell, then bind hh to Ctrl-r (for Vi mode check doc)
if [[ $- =~ .*i.* ]]; then bind '"\C-r": "\C-a hh -- \C-j"'; fi


[ -f ~/.fzf.bash ] && source ~/.fzf.bash
