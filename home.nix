{
  config,
  pkgs,
  inputs,
  ...
}: { 
  imports = [
    ./shell/zsh/zsh.home.nix
    ./programs/vscode.nix
    ./programs/tmux/tmux.nix
    ./ssh.nix
    ./programs/direnv.nix
    ./programs/nvim/neovim/neovim.nix
    ./programs/spotify.nix
    ./programs/kitty/kitty.nix
    ./programs/yazi.nix
    "./programs/fzf.nix"
    ./programs/lazygit.nix
  ];

  home = {
    username = "fady";
    homeDirectory = "/home/fady";
  };
  xresources.properties = {
    "Xcourser.size" = 16;
    "Xft.dpi" = 172;
  };

  home.packages = with pkgs; [
    fastfetch
    nnn
    zip
    unzip
    p7zip

    ripgrep # recursively searches directories for a regex pattern
    jq # A lightweight and flexible command-line JSON processor
    yq-go # yaml processor https://github.com/mikefarah/yq
    eza # A modern replacement for ‘ls’
    fzf # A command-line fuzzy finder
    bat
    fd

    # networking tools
    mtr # A network diagnostic tool
    iperf3
    dnsutils # `dig` + `nslookup`
    ldns # replacement of `dig`, it provide the command `drill`
    aria2 # A lightweight multi-protocol & multi-source command-line download utility
    socat # replacement of openbsd-netcat
    nmap # A utility for network discovery and security auditing
    ipcalc # it is a calculator for the IPv4/v6 addresses

    # misc
    cowsay
    file
    which
    tree
    gnused
    gnutar
    gawk
    zstd
    gnupg

    # nix related
    #
    # it provides the command `nom` works just like `nix`
    # with more details log output
    nix-output-monitor

    # productivity
    hugo # static site generator
    glow # markdown previewer in terminal

    btop # replacement of htop/nmon
    iotop # io monitoring
    iftop # network monitoring

    # system call monitoring
    strace # system call monitoring
    ltrace # library call monitoring
    lsof # list open files

    # system tools
    sysstat
    lm_sensors # for `sensors` command
    ethtool
    pciutils # lspci
    usbutils # lsusb

    signal-desktop
    gimp
    libreoffice
    nextcloud-client
    calibre
    google-chrome

    whatsapp-for-linux
    distrobox
    thefuck

    read-it-later
    podman-compose
    devenv
    devbox

    mkvtoolnix
    makemkv

    alejandra
    xclip
    #   inputs.xremap-flake.packages.${system}.default
    gnomeExtensions.xremap
    wmctrl
    bitwarden
  ];

  programs = {
    git = {
      enable = true;
      userName = "Fady Kuzman";
      userEmail = "fady.kuzman@pm.me";
    };

    # starship - an customizable prompt for any shell
    starship = {
      enable = true;
      # custom settings
      settings = {
        add_newline = false;
        aws.disabled = true;
        gcloud.disabled = true;
        line_break.disabled = true;
      };
    };
  };
    #programs.bash = {
  #  enable = true;
  #  enableCompletion = true;
  #  # TODO add your custom bashrc here
  #  bashrcExtra = ''
  #    export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"
  #  '';

  #  # set some aliases, feel free to add more or remove some
  #  shellAliases = {
  #    k = "kubectl";
  #    urldecode = "python3 -c 'import sys, urllib.parse as ul; print(ul.unquote_plus(sys.stdin.read()))'";
  #    urlencode = "python3 -c 'import sys, urllib.parse as ul; print(ul.quote_plus(sys.stdin.read()))'";
  #  };
  #};

  #programs.direnv = {
  #  enable = true;
  #  enableZshIntegration = true;
  #  nix-direnv.enable = true;
  #};

  programs.spotify-player.enable = true;

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.05";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}
