# warchiefx's .zshrc

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Customize to your needs...
alias e=emacsclient
alias vi=vim
alias tail=colortail
alias murder='sudo kill -9'
alias t=task
# If bat (https://github.com/sharkdp/bat) is available, use instead of cat
command -v bat >/dev/null 2>&1 && alias cat=bat

function customtail {
    tail $* | bat --paging=never -l log
}
command -v bat >/dev/null 2>&1 && alias tail=customtail

export EDITOR=emacsclient

# Setup virtualenvwrapper
if [ -f /bin/virtualenvwrapper_lazy.sh ]; then
    # Usually available here in Arch
    source /bin/virtualenvwrapper_lazy.sh
else
    # ubuntu puts it here
    source /usr/share/virtualenvwrapper/virtualenvwrapper_lazy.sh
fi

export TERM=xterm-256color

# From: http://jeroenjanssens.com/2013/08/16/quickly-navigate-your-filesystem-from-the-command-line.html
export MARKPATH=$HOME/.marks
function jump {
    cd -P $MARKPATH/$1 2>/dev/null || echo "No such mark: $1"

    if [[ -f $MARKPATH/$1/Pipfile && -n `command -v pipenv` ]]; then
        pipenv shell
    elif [ -f $MARKPATH/$1/.python-version ]; then
        workon `cat $MARKPATH/$1/.python-version`
    elif [ -d ~/.virtualenvs/$1 ]; then
        workon $1;
    fi

}
function mark {
    mkdir -p $MARKPATH; ln -s $(pwd) $MARKPATH/$1
}
function unmark {
    rm -i $MARKPATH/$1
}
function marks {
    ls -l $MARKPATH | sed 's/  / /g' | cut -d' ' -f9- | sed 's/ -/\t-/g' && echo
}

alias j=jump
alias m=mark

autoload -Uz prompinit
promptinit
prompt kylewest

function copy_tmux_conf {
    sftp $1 <<EOF
put $HOME/.tmux.conf
EOF

    ssh $1 git clone https://github.com/tmux-plugins/tpm .tmux/plugins/tpm
}

[[ -s "$HOME/.local/share/marker/marker.sh" ]] && source "$HOME/.local/share/marker/marker.sh"
