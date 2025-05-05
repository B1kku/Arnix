{
  config,
  pkgs,
  pkgs-unstable,
  home-manager,
  inputs,
  flake-opts,
  lib,
  ...
}:
{
  imports = [
    # Extra modules
    ../../modules/system/firewall-extra.nix
    ../../modules/powera-controller.nix
    # Modularized configurations
    ./hardware-configuration.nix
    ./nix-flake-paths.nix
    home-manager.nixosModules.home-manager
    # User configurations
    ../../users/bikku/configuration.nix
  ];
  nix = {
    settings = {
      auto-optimise-store = true;
      # Extra store caches from inputs.
      substituters = flake-opts.extraCaches.substituters;
      trusted-public-keys = flake-opts.extraCaches.trusted-public-keys;
    };
    package = pkgs.nix;
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
  };
  # Disable everything but the keyboard from waking up the computer.
  # This is due to mouse sending wake up signals randomly.
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
  # Don't change randomly, used for internals.
  system.stateVersion = "23.05";
}
