# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true'
export XDG_DATA_DIRS="$HOME/.local/share/:$HOME/.nix-profile/share:/usr/share$XDG_DATA_DIRS"
export PATH="$HOME/.nix-profile/bin/:$PATH"
export EDITOR='/usr/bin/nvim'

# CUDA
export PATH="/usr/local/cuda/bin:$PATH"
export LD_LIBRARY_PATH="/usr/local/cuda/lib64:$LD_LIBRARY_PATH"

# go binaries
export PATH="$HOME/go/bin/:$PATH"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="cypher" # lambda


# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
#
# BRO JUST READ THAT: https://github.com/ohmyzsh/ohmyzsh/issues/7688 (thats how you install all the ZSH plugins)
plugins=(git zsh-syntax-highlighting zsh-autosuggestions zsh-z) 

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.

alias md-notes="cd ~/Documents/md-notes/ && nvim ."
alias randwall="feh --bg-scale  --randomize ~/pictures/wallpapers/*"
alias zapiski="~/Documents/faks_git/FRI-ZAPISKI"
alias ctf="cd ~/Documents/ctf/2022"
alias faks="cd ~/Nextcloud/faks/3-letnik/2sem"
alias faks-git="cd ~/Documents/faks_git"
alias rm="rm -i"
alias night="brightnessctl s 1%"
alias nightlock="swaylock -c 000000"
alias hsrv="ssh hsrv"
alias rs="export QT_QPA_PLATFORM=xcb; rstudio-bin --no-sandbox &"
alias rot13="tr 'A-Za-z' 'N-ZA-Mn-za-m'"
alias nix-update="nix-channel --update && nix-env -u"

# Vi mode, medic lifesaver
bindkey -v
bindkey "^F" vi-cmd-mode

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion=

[ -f /opt/miniconda3/etc/profile.d/conda.sh ] && source /opt/miniconda3/etc/profile.d/conda.sh
. "$HOME/.cargo/env"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/gasperspagnolo/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/gasperspagnolo/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/gasperspagnolo/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/gasperspagnolo/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
