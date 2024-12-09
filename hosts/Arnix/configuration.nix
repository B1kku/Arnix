# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).
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
  # Auto update db.
  nix = {
    settings.auto-optimise-store = true;
    package = pkgs.nixVersions.latest;
    extraOptions = "experimental-features = nix-command flakes pipe-operators";
  };
  # Use the systemd-boot EFI boot loader.
  boot = {
    # Enable SysRq to recover from freezes.
    kernel.sysctl."kernel.sysrq" = 1;
    kernelPackages = pkgs.linuxPackages_latest;
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
      timeout = 2;
      efi.canTouchEfiVariables = true;
      #      grub = {
      #        enable = true;
      #        efiSupport = true;
      #        configurationLimit = 5;
      #        useOSProber = true;
      #        memtest86.enable = true;
      #        device = "nodev";
      #      };
    };
  };
  #Networking
  networking.hostName = "Arnix";
  networking = {
    nameservers = [ "1.1.1.1" ];
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
  services.libinput.mouse.accelProfile = "flat";
  services.displayManager.defaultSession = "gnome";
  services.xserver = {
    enable = true;
    xkb.layout = "${config.console.keyMap}";
    excludePackages = [ pkgs.xterm ];
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };
  services.gnome.core-utilities.enable = false;

  # Enable sound.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  powerManagement.cpuFreqGovernor = "ondemand";
  environment.systemPackages = with pkgs; [
    git
    tealdeer
  ];

  users.users.bikku = {
    shell = pkgs.zsh;
    isNormalUser = true;
    initialPassword = "potato";
  };
  programs.steam = {
    enable = true;
    extraCompatPackages = [ pkgs.proton-ge-bin ];
    extraPackages = with pkgs; [
      gamescope
      mangohud
    ];
  };

  programs.gamemode.enable = true;
  programs.zsh.enable = true;

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
