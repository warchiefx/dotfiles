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
        pyenv activate
    elif [ -f $MARKPATH/$1/.python-env ]; then
        workon `cat $MARKPATH/$1/.python-env`
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
    if [ $# -eq 0 ]
    then
        echo "No arguments supplied, expected a server url"
        return -1
    fi
    sftp $1 <<EOF
put $HOME/.tmux.conf
EOF

    ssh $1 git clone https://github.com/tmux-plugins/tpm .tmux/plugins/tpm
}

[[ -s "$HOME/.local/share/marker/marker.sh" ]] && source "$HOME/.local/share/marker/marker.sh"

command -v kubectl >/dev/null 2>&1 && source <(kubectl completion zsh)
command -v pyenv >/dev/null 2>&1 && eval "$(pyenv init -)"
command -v pyenv >/dev/null 2>&1 && eval "$(pyenv virtualenv-init -)"

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

autoload -U add-zsh-hook
load-nvmrc() {
  local node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc

eval $(keychain -q -Q --eval --agents ssh --inherit any)
