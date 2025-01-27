{ config, pkgs, ... }:

{
    imports = [
        ./hardware-configuration.nix
    ];

    # System Configuration
    system.stateVersion = "24.11";

    # Sudo Configuration
    security.sudo = {
        enable = true;
        extraConfig = ''
            %wheel ALL=(ALL) NOPASSWD: ALL
        '';
    };

    # Bootloader Configuration
    boot.loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
    };
    boot.kernelPackages = pkgs.linuxPackages_latest;

    # Time and Locale Configuration
    time.timeZone = "Asia/Jakarta";
    i18n = {
        defaultLocale = "en_US.UTF-8";
        extraLocaleSettings = {
            LC_ADDRESS = "id_ID.UTF-8";
            LC_IDENTIFICATION = "id_ID.UTF-8";
            LC_MEASUREMENT = "id_ID.UTF-8";
            LC_MONETARY = "id_ID.UTF-8";
            LC_NAME = "id_ID.UTF-8";
            LC_NUMERIC = "id_ID.UTF-8";
            LC_PAPER = "id_ID.UTF-8";
            LC_TELEPHONE = "id_ID.UTF-8";
            LC_TIME = "id_ID.UTF-8";
        };
    };

    # Networking Configuration
    networking = {
        hostName = "NixOS";
        networkmanager.enable = true;
        nameservers = [
            "1.1.1.1"
            "1.0.0.1"
        ];
        # wireless.enable = true;
        # proxy = {
        #     default = "http://user:password@proxy:port/";
        #     noProxy = "127.0.0.1,localhost,internal.domain";
        # };
    };

    # Desktop Environment Configuration
    services.desktopManager.plasma6.enable = true;
    services.displayManager = {
        sddm = {
            enable = true;
            theme = "catppuccin-mocha";
        };
    };

    # Audio Configuration
    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true;
    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
        enable = true;
        alsa = {
            enable = true;
            support32Bit = true;
        };
        pulse.enable = true;
        jack.enable = true;
    };

    # User Management
    users.users.farhnkrnapratma = {
        isNormalUser = true;
        description = "Farhan Kurnia Pratama";
        extraGroups = [ "networkmanager" "wheel" ];
    };

    # Allow Unfree Packages
    nixpkgs.config.allowUnfree = true;

    # Exclude Some KDE Default Packages
    environment.plasma6.excludePackages = with pkgs.kdePackages; [
        plasma-browser-integration
        konsole
        oxygen
        oxygen-icons
        kate
        elisa
        khelpcenter
        kcrash
        kcharselect
        ark
        drkonqi
        xwaylandvideobridge
        ktexteditor
        kuserfeedback
    ];

    # System Packages
    environment.systemPackages = with pkgs; [
        # KDE Packages
        kdePackages.kdeconnect-kde
        kdePackages.sddm-kcm
        kdePackages.kcalc
        kdePackages.kcolorchooser

        # Development Tools
        vim
        vscode
        gh
        git
        ctags

        # System Utilities
        tmux
        btop
        neofetch
        unzip
        wget

        # Terminals
        kitty

        # Applications
        spotify
        cava
        libreoffice-fresh
        google-chrome
        brave
        tor-browser
        steam
        thunderbird
        wine
        heroic

        # SDDM Catppuccin
        (catppuccin-sddm.override {
            flavor = "mocha";
            font  = "UbuntuSansMono NF Medium";
            fontSize = "12";
            background = "${./nixos.jpg}";
            loginBackground = true;
        })
        catppuccin-kde
        papirus-icon-theme
        bibata-cursors
    ];

    # Fonts
    fonts.packages = with pkgs; [
        nerdfonts
    ];

    # Programs
    programs.steam.enable = true;
    programs.kdeconnect.enable = true;
    programs.firefox.enable = true;
    programs.gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
    };

    # Services
    services.printing.enable = true;
    services.openssh.enable = true;

    # Optional Services
    # services.xserver.libinput.enable = true;
    # programs.mtr.enable = true;
    # networking.firewall = {
    #     allowedTCPPorts = [ ... ];
    #     allowedUDPPorts = [ ... ];
    #     enable = true;
    # };
}