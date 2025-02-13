export EDITOR=vim

neofetch

rd='\e[1;31m'  # Red
gr='\e[1;32m'  # Green
bl='\e[1;34m'  # Blue
cy='\e[1;36m'  # Cyan
pu='\e[1;35m'  # Purple
rs='\e[0m'     # Reset

os()
{
    echo -e "${bl} $(grep -E "^PRETTY_NAME=" /etc/os-release | awk -F= '{print $2}' | tr -d '"')${rs}"
}

git_branch()
{
    if git rev-parse --is-inside-work-tree &>/dev/null; then
        echo -e "${pu}─(${rs}${cy} $(git branch --show-current)${rs}"
    fi
}

git_status() {
    local status ahead behind
    [[ -n $(git status --porcelain 2>/dev/null) ]] && status="✦"

    ahead=$(git rev-list --count @{upstream}..HEAD 2>/dev/null)
    behind=$(git rev-list --count HEAD..@{upstream} 2>/dev/null)

    [[ $ahead -gt 0 ]] && status+="+$ahead"
    [[ $behind -gt 0 ]] && status+="-$behind"

    [[ -n "$status" ]] && echo -e "${cy}$status${rs}${pu})${rs}"
}

prompt()
{
    echo -e "🚀"
}

# Gunakan tanda kutip ganda agar variabel warna dievaluasi
PS1="\n${pu}╭─(${rs}${rd} \u${rs}${pu})─(${rs}$(os)${pu})─(${rs}${gr} \w${rs}${pu})${rs}$(git_branch) $(git_status)\n${pu}│${rs}\n${pu}╰──${rs}$(prompt) "

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
