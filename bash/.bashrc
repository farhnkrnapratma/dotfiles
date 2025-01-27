export EDITOR=vim
export VISUAL=vim

# PS1

git_branch() {
    if git rev-parse --is-inside-work-tree &>/dev/null; then
        echo -e "\033[1;36m  (\033[0m\033[1;35m$(git branch --show-current)\033[0m\033[36m)"
    fi
}

PS1='\[\033[1;36m\]╭ (\033[1;35m\w\033[0m\[\033[1;36m\])$(git_branch)\n│\n╰ (\033[1;35m\u\033[1;36m@\033[0m\033[1;35m\h\033[0m\033[1;36m) \[\033[0m\]'


# Override clear command
clear() {
    command clear
    echo ''
    neofetch
}
# Run
echo ''
neofetch

# System
alias ls="ls --color=auto"
alias grep="grep --color=auto"
# Bash
alias bashrc="$EDITOR ~/.bashrc && source ~/.bashrc && clear"
# Cava
alias cava="TERM=st-256color cava"
# Git
alias gcommit="git add . && git commit -m"
alias gpush="git push"
alias gstatus="git status"
alias gbranch="git branch"
# NixOS
alias nconfig="sudo $EDITOR /etc/nixos/configuration.nix"
alias nswitch="sudo nixos-rebuild switch"
alias nboot="sudo nixos-rebuild boot"
alias ntest="sudo nixos-rebuild test"
alias nbuild="sudo nixos-rebuild build"
# Nix
alias nupdate="sudo nix-channel --update"
alias ngarbage="sudo nix-collect-garbage -d"