export EDITOR=vim

neofetch

os()
{
    echo -e "\033[1;34m  $(grep -E "^PRETTY_NAME=" /etc/os-release | awk -F= '{print $2}' | tr -d '"') \033[0m"
}
git_branch()
{
    if git rev-parse --is-inside-work-tree &>/dev/null; then
        echo -e "\033[1;36m $(git branch --show-current)\033[0m"
    fi
}
git_status() {
    local status ahead behind
    [[ -n $(git status --porcelain 2>/dev/null) ]] && status="✦"

    ahead=$(git rev-list --count @{upstream}..HEAD 2>/dev/null)
    behind=$(git rev-list --count HEAD..@{upstream} 2>/dev/null)

    [[ $ahead -gt 0 ]] && status+="+$ahead"
    [[ $behind -gt 0 ]] && status+="-$behind"

    [[ -n "$status" ]] && echo -e "\033[1;36m$status\033[0m"
}
prompt()
{
    echo -e "\033[1;36m󰶻  \033[0m"
}

PS1='\033[1;31m  \u\033[0m $(os)\033[1;32m  \w\033[0m $(git_branch) $(git_status) \n\n$(prompt)'

alias ls="ls --color=auto"
alias grep="grep --color=auto"
alias clear="clear && neofetch"

alias bashrc="$EDITOR ~/.bashrc && source ~/.bashrc && clear"
alias neofetch="neofetch --ascii_distro $(grep -E '^NAME=' /etc/os-release | awk -F= '{print $2}' | tr -d '"')_small"
alias cava="TERM=st-256color cava"

alias gtct="git add . && git commit -m"
alias gtps="git push"
alias gtpl="git pull"
alias gtst="git status"
alias gtbc="git branch"

alias nxdr="cd /etc/nixos/"
alias nxsw="sudo nixos-rebuild switch"
alias nxbt="sudo nixos-rebuild boot"
alias nxts="sudo nixos-rebuild test"
alias nxbd="sudo nixos-rebuild build"
alias nxup="sudo nix-channel --update"
alias nxdg="sudo nix-collect-garbage -d"
