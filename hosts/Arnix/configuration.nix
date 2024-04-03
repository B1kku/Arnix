# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, lib, pkgs, pkgs-unstable, home-manager, inputs, ... }: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules/powera-controller.nix
    home-manager.nixosModules.home-manager
  ];
  # make `nix run nixpkgs#nixpkgs` use the same nixpkgs as the one used by this flake.
  nix.registry.nixpkgs.flake = inputs.nixpkgs;
  nix.channel.enable = false;
  environment.etc."nix/inputs/nixpkgs".source = "${inputs.nixpkgs}";

  system.replaceRuntimeDependencies = [
    {
      original = pkgs.xz;
      replacement = inputs.nixpkgs-staging-next.legacyPackages.${pkgs.system}.xz;
    }
  ];

  nix = {
    settings = {
      auto-optimise-store = true;
      nix-path = lib.mkForce "nixpkgs=/etc/nix/inputs/nixpkgs";
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
  };
  # Use the systemd-boot EFI boot loader.
  boot = {
    # Enable SysRq to recover from freezes.
    # All enabled for now, while I figure out why or if it's fixed.
    kernel.sysctl."kernel.sysrq" = 1;
    kernelParams = [
      "logo.nologo"
      "fbcon=nodefer"
      "bgrt_disable"
      "vt.global_cursor_default=0"
      "quiet"
      "systemd.show_status=false"
      "rd.udev.log_level=3"
      "splash"
    ];
    # plymouth = { enable = true; };
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 5;
      };
      efi.canTouchEfiVariables = true;
    };
  };
  
  #Networking
  networking.hostName = "Arnix"; # Define your hostname.
  networking = {
    # Valent
    # Only local 
    firewall = {
      extraCommands = ''
        iptables -A nixos-fw -p tcp --source 192.168.1.0/24 --dport 1714:1764 -j nixos-fw-accept
        iptables -A nixos-fw -p udp --source 192.168.1.0/24 --dport 1714:1764 -j nixos-fw-accept
      '';
      extraStopCommands = ''
        iptables -D nixos-fw -p tcp --source 192.168.1.0/24 --dport 1714:1764 -j nixos-fw-accept || true
        iptables -D nixos-fw -p udp --source 192.168.1.0/24 --dport 1714:1764 -j nixos-fw-accept || true
      '';
    };
  };
  # Select internationalisation properties.
  time.timeZone = "Europe/Brussels";
  # locale
  i18n.defaultLocale = "en_GB.UTF-8";
  i18n.extraLocaleSettings = {
    LC_MONETARY = "es_ES.UTF-8";
    LC_MEASUREMENT = "es_ES.UTF-8";
  };
  console = {
    font = "Lat2-Terminus16";
    keyMap = "es";
    #  useXkbConfig = true; # use xkbOptions in tty.
  };
  # Disable everything but the keyboard from waking up the computer.
  # This is due to mouse sending wake up signals randomly sometimes.
  # TODO: Move to a module.
  services.udev.extraRules = ''
    ACTION=="add", ATTRS{removable}=="removable", ATTRS{idVendor}!="413c", ATTRS{idProduct}!="2003", ATTR{power/wakeup}="disabled"
    #ACTION=="add", ATTRS{idProduct}!="2003", ATTR{power/wakeup}="disabled"
    #ACTION=="add", ATTR{power/wakeup}="disabled"
  '';

  # XServer, DM & DE
  services.xserver = {
    enable = true;
    libinput.mouse.accelProfile = "flat";
    layout = "${config.console.keyMap}";
    excludePackages = [ pkgs.xterm ];
    # TODO: Switch to SDDM
    displayManager = {
      lightdm = {
        enable = true;
        greeters.enso.enable = true;
      };
      defaultSession = "gnome";
    };
    desktopManager.gnome.enable = true;
  };
  environment.gnome.excludePackages = (with pkgs; [
    gnome-photos
    gnome-tour
    gnome-text-editor
    gnome-connections
    gnome-console
  ]) ++ (with pkgs.gnome; [
    cheese
    #gnome-music
    gedit
    epiphany
    geary
    tali
    iagno
    hitori
    atomix
    yelp
    simple-scan
    gnome-characters
    gnome-contacts
    gnome-initial-setup
    gnome-terminal
  ]);
  programs.dconf.enable = true;

  # Enable sound.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };
  # sound.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.bikku = {
    shell = pkgs.zsh;
    isNormalUser = true;
    initialPassword = "potato";
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  };
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit pkgs-unstable inputs; };
    users.bikku = import ../../users/bikku/home.nix;
  };

  # virtualisation.waydroid.enable = true;
  programs.steam = {
    enable = true;
    # package = pkgs-unstable.steam;
  };
  hardware.steam-hardware.enable = pkgs.lib.mkForce false;
  programs.gamemode.enable = true;
  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
    gnome.gnome-tweaks
    wget
    git
    tealdeer
  ];
  # Don't change randomly, used for internals.
  system.stateVersion = "23.05";

}

