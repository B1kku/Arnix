{
  config,
  pkgs,
  pkgs-unstable,
  inputs,
  flake-opts,
  ...
}:
let
  sddm-theme = pkgs.silent-sddm.override {
    theme = "ken";
  };
in
{
  imports = [
    # Extra modules
    ../../modules/system/firewall-extra.nix
    ../../modules/powera-controller.nix
    # Modularized configurations
    ./hardware-configuration.nix
    ./nix-flake-paths.nix
    ./quietboot.nix
    ./dns.nix
    # User configurations
    ../../users/bikku/user.nix
  ];
  nix = {
    settings = {
      auto-optimise-store = true;
      # Extra store caches from inputs.
      substituters = flake-opts.extraCaches.substituters;
      trusted-public-keys = flake-opts.extraCaches.trusted-public-keys;
      experimental-features = [
        "nix-command"
        "flakes"
        "pipe-operators"
      ];
    };
    package = pkgs.nix;
  };
  # Use the systemd-boot EFI boot loader.
  boot = {
    # Enable SysRq to recover from freezes.
    kernel.sysctl."kernel.sysrq" = 1;
    kernelPackages = pkgs.linuxPackages_zen;
    loader = {
      grub = {
        enable = true;
        configurationLimit = 10;
        # Also detect windows
        useOSProber = true;
        efiSupport = true;
        device = "nodev";
        gfxmodeEfi = "1920x1080,1024x768";
        theme = "${pkgs.grub-yorha}/yorha-1920x1080";
        splashImage = "${pkgs.grub-yorha}/yorha-1920x1080/background.png";
        extraInstallCommands = ''
          cat << EOF >> /boot/grub/grub.cfg
          menuentry " " {
          }
          menuentry " " {
          }
          menuentry " " {
          }
          menuentry " " {
          }
          menuentry " " {
          }
          menuentry " " {
          }
          menuentry "Firmware Setup" {
            fwsetup
          }
          menuentry "Shutdown" --class shutdown {
            halt
          }
          menuentry "Reboot" --class restart{
            reboot
          }
          EOF
        '';
      };
      timeout = 3;
      efi.canTouchEfiVariables = true;
    };
  };
  #Networking
  networking.hostName = "Arnix";
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
  # XServer, DM & DE
  services = {
    libinput.mouse.accelProfile = "flat";
    displayManager = {
      defaultSession = "niri";
      sddm = {
        package = pkgs.kdePackages.sddm;
        enable = true;
        autoNumlock = true;
        theme = "silent";
        extraPackages = sddm-theme.propagatedBuildInputs;
        settings = {
          # required for styling the virtual keyboard
          General = {
            GreeterEnvironment = "QML2_IMPORT_PATH=${sddm-theme}/share/sddm/themes/${sddm-theme.pname}/components/,QT_IM_MODULE=qtvirtualkeyboard";
            InputMethod = "qtvirtualkeyboard";
          };
        };
      };
    };
    xserver = {
      enable = true;
      xkb.layout = "${config.console.keyMap}";
      excludePackages = [ pkgs.xterm ];
    };
    # gnome.core-apps.enable = false;
  };
  programs.niri.enable = true;

  # Enable sound.
  services.pulseaudio.enable = false;
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
    sddm-theme
  ];
  # Don't change randomly, used for internals.
  system.stateVersion = "23.05";
}
