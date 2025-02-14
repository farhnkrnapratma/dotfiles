# Define Colors -------------------------------------------------------[

rd='\e[1;31m'  # Red
gr='\e[1;32m'  # Green
bl='\e[1;34m'  # Blue
cy='\e[1;36m'  # Cyan
pu='\e[1;35m'  # Purple
rs='\e[0m'     # Reset

# ---------------------------------------------------------------------]

# Define The Greeter Function -----------------------------------------[

greeter()
{
    local hour name
    hour=$(date +%H)
    name="Farhan Kurnia Pratama"        # Change yourself!

    if [ "$hour" -ge 6 ] && [ "$hour" -lt 12 ]; then
        echo -e "Good morning, ${rd}$name${rs}!\n"
    elif [ "$hour" -ge 12 ] && [ "$hour" -lt 18 ]; then
        echo -e "Good afternoon, ${cy}$name${rs}!\n"
    elif [ "$hour" -ge 18 ] && [ "$hour" -lt 22 ]; then
        echo -e "Good evening, ${bl}$name${rs}!\n"
    else
        echo -e "Good night, ${pu}$name${rs}!\n"
    fi
}

# ----------------------------------------------------------------------]

# PS1 Customization Options --------------------------------------------[

# Show Icon
# Description   : Display the icon to the left of the information.
# Options       : "yes", "no"
# Default       : "yes"
show_icon="no"

# Default Icons
# Clock
icon_clock=""
# User
icon_user=""
# OS
icon_os=""
# Current Working Directory
icon_cwd=""
# Git Branch and Status
icon_git=""
# Prompt
icon_prompt="🚀"

# Show Clock: HH:MM
show_time() {
    local clock_text=$(date +%H:%M)
    [[ $show_icon == "yes" ]] && echo -e "${cy}${icon_clock} $clock_text${rs}" || echo -e "${cy}$clock_text${rs}"
}

# Show Current Username
show_user() {
    [[ $show_icon == "yes" ]] && echo -e "${rd}${icon_user} \u${rs}" || echo -e "${rd}\u${rs}"
}

# Show Current Working Directory
show_cwd() {
    [[ $show_icon == "yes" ]] && echo -e "${gr}${icon_cwd} \w${rs}" || echo -e "${gr}\w${rs}"
}

# Show Pretty OS Name
show_os() {
    local pretty_name
    pretty_name=$(awk -F= '$1=="NAME" {gsub(/"/, "", $2); print $2}' /etc/os-release)
    [[ $show_icon == "yes" ]] && echo -e "${bl}${icon_os} $pretty_name${rs}" || echo -e "${bl}$pretty_name${rs}"
}

# Show Git Branch and Status (uncommitted, ahead, or behind)
show_git_branch() {
    local current_branch status ahead behind

    git rev-parse --is-inside-work-tree &>/dev/null || return

    current_branch=$(git branch --show-current)

    [[ -n $(git status --porcelain 2>/dev/null) ]] && status=" ✦"

    ahead=$(git rev-list --count @{upstream}..HEAD 2>/dev/null || echo 0)
    behind=$(git rev-list --count HEAD..@{upstream} 2>/dev/null || echo 0)

    ((ahead > 0)) && status+=" +$ahead"
    ((behind > 0)) && status+=" -$behind"

    [[ $show_icon == "yes" ]] && echo -e "${pu}─(${rs}${cy}${icon_git} $current_branch${status:+$cy$status}${rs}${pu})${rs}" || echo -e "${pu}─(${rs}${cy}$current_branch${status:+$cy$status}${rs}${pu})${rs}"
}

# PS1 Prompt 
PS1="\n${pu}╭─(${rs}$(show_time)${pu})─(${rs}$(show_user)${pu})─(${rs}$(show_os)${pu})─(${rs}$(show_cwd)${pu})${rs}$(show_git_branch)\n${pu}│${rs}\n${pu}╰──${rs}${icon_prompt} "

# ----------------------------------------------------------------------]

# Aliases --------------------------------------------------------------[

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
    alias clear="clear && greeter && neofetch"
    [ -n "$PS1" ] && greeter && neofetch
else
    alias clear="clear && greeter"
    [ -n "$PS1" ] && greeter
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

# ----------------------------------------------------------------------]