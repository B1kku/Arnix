{
  config,
  pkgs,
  pkgs-unstable,
  home-manager,
  inputs,
  ...
}:
{
  imports = [
    ../../modules/system/usb-wakeup.nix
    ../../modules/system/firewall-extra.nix
    ../../modules/powera-controller.nix
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    home-manager.nixosModules.home-manager
  ];
  nix = {
    settings = {
      auto-optimise-store = true;
      # Nix-Gaming Cachix
      substituters = [ "https://nix-gaming.cachix.org" ];
      trusted-public-keys = [ "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4=" ];
    };
    package = pkgs.nixVersions.latest;
    # Enable pipes [1 2 3] |> map (e: e * 2)
    extraOptions = "experimental-features = nix-command flakes pipe-operators";
  };
  # Use the systemd-boot EFI boot loader.
  boot = {
    # Enable SysRq to recover from freezes.
    kernel.sysctl."kernel.sysrq" = 1;
    kernelPackages = pkgs.linuxPackages_6_12;
    kernelParams = [
      "quiet"
    ];
    # plymouth = { enable = true; };
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 5;
      };
      timeout = 2;
      efi.canTouchEfiVariables = true;
    };
  };
  #Networking
  networking = {
    nameservers = [ "1.1.1.1" ];
    hostName = "Arnix";
  };
  # Select internationalisation properties.
  time.timeZone = "Europe/Brussels";
  i18n = {
    defaultLocale = "en_GB.UTF-8";
    extraLocaleSettings = {
      LC_MONETARY = "es_ES.UTF-8";
      LC_MEASUREMENT = "es_ES.UTF-8";
    };
  };
  console = {
    font = "Lat2-Terminus16";
    keyMap = "es";
    #  useXkbConfig = true; # use xkbOptions in tty.
  };
  # Disable everything but the keyboard from waking up the computer.
  # This is due to mouse sending wake up signals randomly.
  hardware.usb.wakeup = {
    enable = true;
    mode = "whitelist";
    devices.keyboard = {
      vendor = "413c";
      product = "2003";
    };
  };
  # XServer, DM & DE
  services = {
    libinput.mouse.accelProfile = "flat";
    displayManager.defaultSession = "gnome";
    xserver = {
      enable = true;
      xkb.layout = "${config.console.keyMap}";
      excludePackages = [ pkgs.xterm ];
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };
    gnome.core-utilities.enable = false;
  };

  # Enable sound.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
  };
  powerManagement.cpuFreqGovernor = "ondemand";
  environment.systemPackages = with pkgs; [
    git
    tealdeer
    nh
  ];
  # This should take care of most game-related settings too.
  programs.steam = {
    enable = true;
    extraCompatPackages = [ pkgs.proton-gamemode ];
    extraPackages = with pkgs; [
      gamescope
      mangohud
    ];
  };
  programs.gamemode.enable = true;

  programs.zsh.enable = true;

  users.users.bikku = {
    shell = pkgs.zsh;
    isNormalUser = true;
    initialPassword = "potato";
  };
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit pkgs-unstable inputs;
    };
    users.bikku = import ../../users/bikku/home.nix;
  };
  # Don't change randomly, used for internals.
  system.stateVersion = "23.05";
}
