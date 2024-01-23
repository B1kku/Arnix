# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, home-manager, inputs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    home-manager.nixosModules.home-manager
  ];
  nix = {
    settings.auto-optimise-store = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7Dd";
    };
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  #Networking
  networking.hostName = "Arnix"; # Define your hostname.
  networking = {
    # Valent
    firewall = {
      allowedTCPPortRanges = [{
        from = 1716;
        to = 1716;
      }];
      allowedUDPPortRanges = [{
        from = 1716;
        to = 1716;
      }];
    };
  };
  # Select internationalisation properties.
  time.timeZone = "Europe/Madrid";
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
    displayManager = {
      lightdm = {
        enable = true;
        greeters.enso.enable = true;
      };
      defaultSession = "gnome";
    };
    desktopManager.gnome.enable = true;
  };
  environment.gnome.excludePackages = (with pkgs; [ gnome-photos gnome-tour ])
    ++ (with pkgs.gnome; [
      cheese
      #gnome-music
      gedit
      epiphany
      geary
      gnome-characters
      tali
      iagno
      hitori
      atomix
      yelp
      gnome-contacts
      gnome-initial-setup
      gnome-terminal
    ]);
  programs.dconf.enable = true;
  # services.xserver.xkbOptions = "eurosign:e,caps:escape";

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

  #nixpkgs.overlays = [ (import ./overlays/nvim.nix) ];
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.bikku = {
    isNormalUser = true;
    initialPassword = "potato";
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  };
  home-manager = {
    # useGlobalPkgs = true;
    # useUserPackages = true;
    extraSpecialArgs = { inherit pkgs inputs; };
    users.bikku = import ../../users/bikku/home.nix;
  };

  environment.systemPackages = with pkgs; [
    gnome.gnome-tweaks
    wget
    git
    tealdeer
  ];

  # Don't change randomly, used for internals.
  system.stateVersion = "23.05";

}

