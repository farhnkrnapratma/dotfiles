os_name=$(awk -F= '$1=="NAME" {gsub(/"/, "", $2); print $2}' /etc/os-release)

if [ "$os_name" = "NixOS" ]; then
    alias nxdr="cd /etc/nixos/"
    alias nxsw="sudo nixos-rebuild switch"
    alias nxbt="sudo nixos-rebuild boot"
    alias nxts="sudo nixos-rebuild test"
    alias nxbd="sudo nixos-rebuild build"
    alias nxup="sudo nix-channel --update"
    alias nxdg="sudo nix-collect-garbage -d"
fi

if command -v git >/dev/null 2>&1; then
    alias gtct="git add . && git commit -m"
    alias gtps="git push"
    alias gtpl="git pull"
    alias gtst="git status"
    alias gtbc="git branch"
fi

if command -v neofetch >/dev/null 2>&1; then
    alias neofetch="neofetch --ascii_distro ${os_name}_small"
    alias cl="clear && neofetch"
    [ -n "$PS1" ] && neofetch
fi

if command -v cava >/dev/null 2>&1; then
    alias cava="TERM=st-256color cava"
fi

if command -v vim >/dev/null 2>&1; then
    export EDITOR=vim
elif command -v hx >/dev/null 2>&1; then
    export EDITOR=hx
else
    export EDITOR=nano
fi

alias ls="ls --color=auto"
alias grep="grep --color=auto"
alias bashrc="$EDITOR ~/.bashrc && source ~/.bashrc"

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
    git_status() {
        local status ahead behind
        [[ -n $(git status --porcelain 2>/dev/null) ]] && status="✦"

        ahead=$(git rev-list --count @{upstream}..HEAD 2>/dev/null)
        behind=$(git rev-list --count HEAD..@{upstream} 2>/dev/null)

        [[ $ahead -gt 0 ]] && status+="+$ahead"
        [[ $behind -gt 0 ]] && status+="-$behind"

        [[ -n "$status" ]] && echo -e "${cy} $status${rs}"
    }
    
    if git rev-parse --is-inside-work-tree &>/dev/null; then
        echo -e "${pu}─(${rs}${cy} $(git branch --show-current)$(git_status)${rs}${pu})${rs}"
    fi
}

PS1="\n${pu}╭─(${rs}${rd} \u${rs}${pu})─(${rs}$(os)${pu})─(${rs}${gr} \w${rs}${pu})${rs}$(git_branch)\n${pu}│${rs}\n${pu}╰──${rs}🚀 "
