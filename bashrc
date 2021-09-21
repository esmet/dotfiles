source /etc/profile
export BASH_SILENCE_DEPRECATION_WARNING=1
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
curl_time() {
    curl -so /dev/null -w "\
   namelookup:  %{time_namelookup}s\n\
      connect:  %{time_connect}s\n\
   appconnect:  %{time_appconnect}s\n\
  pretransfer:  %{time_pretransfer}s\n\
     redirect:  %{time_redirect}s\n\
starttransfer:  %{time_starttransfer}s\n\
-------------------------\n\
        total:  %{time_total}s\n" "$@"
}

#NORMAL="\[\033[00m\]"
#BLUE="\[\033[01;34m\]"
#YELLOW="\[\e[1;33m\]"
#GREEN="\[\e[1;32m\]"
#export PS1='[\[\e[0;33m\]\[\e\[m\]\[\e[0;32m]\w\[\e[m\]] \[\e[0;33m][$(gcb)] \[\e[0;34m][$(kcc)]\[\e[m\] $ '
#export PS1='[\[\e\[0;33m\]\[\e\[m\]\[\e\[0;32m\]\w\[\e[m\]] \[\e\[0;33m\]\[$(gcb)\]\[\e[m\] \[\e\[0;33m\]\[$(kcc)\]\[\e[m\]$ '
if [ -z "$ZSH_VERSION" ] ; then
	export PS1='[\[\e[0;33m\]\[\e[m\]\[\e[0;32m\]\w\[\e[m\]] \[\e[0;33m\][$(gcb)] [$(kcc)]\[\e[m\]\n$ '
fi

# disable the most irritating terminal emulation feature ever known
stty -ixon

# vi bindings are great everywhere except the command line
#set -o emacs

# this bundle of joy is for portable LS colors.
# I like yellow dictories because bold blue is
# impossible to see on an osx terminal
unamestr=$(uname | tr '[:upper:]' '[:lower:]')
if [ "$unamestr" = 'linux' ] ; then
    alias ls="ls --color=auto"
    export LS_COLORS='di=33'
elif [ "$unamestr" = 'darwin' ] ; then
    alias ls="ls -G"
    export CLICOLOR=1
    export LSCOLORS="DxGxcxdxCxegedabagacad"
else
    alias ls="ls"
    echo "Problem setting ls colors, uname = $unamestr"
fi

# ag rage
alias ag="2>/dev/null ag -if"

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
pathmunge "/usr/local/opt/make/libexec/gnubin"
pathmunge "$HOME/local/bin" 
pathmunge "$HOME/scripts"
pathmunge "$HOME/go/bin"
pathmunge "$HOME/.cargo/bin"
pathmunge "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/bin"

export HISTIGNORE="ls:cd ~:cd ..:exit:h:history"
export HISTCONTROL="erasedups"

export C_INCLUDE_PATH=

function h {
    pattern=$1
    history | grep $pattern
}

# ugh
if [[ -S "$SSH_AUTH_SOCK" && ! -h "$SSH_AUTH_SOCK" ]]; then
    ln -sf "$SSH_AUTH_SOCK" ~/.ssh/ssh_auth_sock;
fi
export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock;

[[ -s "$HOME/.gvm/scripts/gvm" ]] && source "$HOME/.gvm/scripts/gvm"
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
export HISTCONTROL=ignorespace   # leading space hides commands from history
export HISTFILESIZE=10000        # increase history file size (default is 500)
export HISTSIZE=${HISTFILESIZE}  # increase history size (default is 500)

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
[[ -s "/home/esmet/.gvm/scripts/gvm" ]] && source "/home/esmet/.gvm/scripts/gvm"

alias k="kubectl"
if [ -f /usr/local/opt/llvm@11/bin/clang-format ] ; then
	export CLANG_FORMAT=/usr/local/opt/llvm@11/bin/clang-format
fi
