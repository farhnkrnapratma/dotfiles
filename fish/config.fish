function fish_greeting
    fastfetch
end

function loopfetch
    while true
        clear
        sleep 0.5
        fastfetch
        sleep 3
    end
end

function syslogbar
    clear
    # Default interval is 3 seconds if not provided or invalid
    if test (count $argv) -gt 0
        set interval $argv[1]
    else
        set interval 3
    end

    # Ensure interval is a positive number (including decimals)
    if not string match -qr '^(0|[1-9][0-9]*)(\.[0-9]+)?$' -- $interval
        echo "\u26a0\ufe0f Invalid interval: '$interval'. Must be a positive number."
        return 1
    end

    if math "$interval" = 0
        echo "Invalid interval: '$interval'. Must be greater than 0."
        return 1
    end

    # Get active network interface
    set iface (ip route get 8.8.8.8 2>/dev/null | string match -r 'dev\s+(\S+)' | string split ' ')[-1]

    if test -z "$iface"
        echo "\u26a0\ufe0f Unable to determine network interface."
        return 1
    end

    # Initial network counters
    set rx_prev (cat /sys/class/net/$iface/statistics/rx_bytes)
    set tx_prev (cat /sys/class/net/$iface/statistics/tx_bytes)
    set t_prev (date +%s)

    set counter 0

    while true
        set user (whoami)

        if type -q hostname
            set host (hostname)
        else
            set host (cat /etc/hostname)
        end

        set battery_path /sys/class/power_supply/BAT*
        set battery (cat $battery_path/capacity 2>/dev/null)
        set battery_status (cat $battery_path/status 2>/dev/null)

        if test -z "$battery"
            set battery "N/A"
            set charge_display ""
        else if test "$battery_status" = "Charging"
            set charge_display " (Charging)"
        else
            set charge_display ""
        end

        set datetime (date '+%H:%M:%S %d/%m/%Y')

        set rx_now (cat /sys/class/net/$iface/statistics/rx_bytes)
        set tx_now (cat /sys/class/net/$iface/statistics/tx_bytes)
        set t_now (date +%s)
        set delta_t (math "$t_now - $t_prev")

        if test $delta_t -eq 0
            set rx_rate 0
            set tx_rate 0
        else
            set rx_rate (math --scale=1 "($rx_now - $rx_prev) / 1024 / $delta_t")
            set tx_rate (math --scale=1 "($tx_now - $tx_prev) / 1024 / $delta_t")
        end

        echo -n (set_color blue)"$user "(set_color cyan)"$host "
        echo -n (set_color yellow)"$datetime "
        echo -n (set_color green)"$battery%$charge_display "
        echo -n (set_color red)"$(printf "%.1f" $tx_rate) KB/s (Up) "
        echo (set_color red)"$(printf "%.1f" $rx_rate) KB/s (Down)"

        set rx_prev $rx_now
        set tx_prev $tx_now
        set t_prev $t_now

        set counter (math "$counter + 1")
        if test (math "$counter % 28") -eq 0
            clear
        end

        sleep $interval
    end
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

alias sudo="sudo-rs"
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

# SDKMAN! configuration
set -xg SDKMAN_DIR $HOME/.sdkman
set -xg PATH $HOME/.sdkman/bin $PATH

zoxide init fish | source
