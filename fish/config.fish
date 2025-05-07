function fish_greeting
    fastfetch
    echo "Hello, $(whoami)!"
end

export "MICRO_TRUECOLOR=1"

if type nvim >/dev/null
    set -Ux EDITOR nvim
    set -Ux VISUAL nvim
else if type helix >/dev/null
    set -Ux EDITOR helix
    set -Ux VISUAL helix
else if type hx >/dev/null
    set -Ux EDITOR hx
    set -Ux VISUAL hx
else
    set -Ux EDITOR nano
    set -Ux VISUAL nano
end

set os_name (awk -F= '$1=="NAME" {gsub(/"/, "", $2); print $2}' /etc/os-release)

if test "$os_name" = "Arch Linux"
    alias pacup="sudo pacman -Syu"
    alias pacin="sudo pacman -S"
    alias pacrm="sudo pacman -Rns"
    alias pacrd="sudo pacman -Rdd"
    alias paccl="sudo pacman -Rns $(pacman -Qdtq)"
    alias yayup="yay -Syu"
    alias yayin="yay -S"
    alias yayrm="yay -Rns"
    alias yayrd="yay -Rdd"
    alias yaycl="yay -Rns $(yay -Qdtq)"
    alias u="yay -Syuu"
end

alias d="rm -rf"
alias b="z .."
alias x="exit"
alias c="clear"
alias l="eza -l"
alias la="eza -la"
alias e="$EDITOR"
alias fishc="e ~/.config/fish/config.fish && source ~/.config/fish/config.fish"

function i
    sudo pacman -S $argv 2>/dev/null
    if test $status -ne 0
        yay -S $argv
    end
end

function r
    sudo pacman -Rns $argv 2>/dev/null
    if test $status -ne 0
        yay -Rns $argv
    end
end

function del-locate
    locate $argv[1] | sudo xargs -d '\n' rm -rf
    sudo updatedb
end

if type cargo >/dev/null
    alias crun="cargo run"
    alias cbld="cargo build"
    alias ctst="cargo test"
    alias chck="cargo check"
end

set PATH $PATH /home/farhnkrnapratma/.local/bin

zoxide init fish | source
