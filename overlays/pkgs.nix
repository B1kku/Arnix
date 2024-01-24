final: prev: {
  # No longer necessary when updated, will need a wrapper to call with lombok instead.
  jdtls = final.callPackage ../packages/jdtls { };

  # Will change from vencorddesktop to vesktop once it updates.
  vesktop = prev.vesktop.overrideAttrs (old:{
    nativeBuildInputs =  old.nativeBuildInputs ++  [ prev.imagemagick ];
    desktopItems = [
      (prev.makeDesktopItem {
        name = "vencorddesktop";
        desktopName = "Discord";
        exec = "vencorddesktop %U";
        icon = "discord";
        startupWMClass = "Discord";
        genericName = "Internet Messenger";
        keywords = [ "discord" "vencord" "electron" "chat" ];
        categories = [ "Network" "InstantMessaging" "Chat" ];
      })
    ];
    #Remove existing icons and add original discord icon as it is pretty hard for me to find the app with the vesktop icon.
    postInstall = let
      logo = prev.fetchurl {
        url =
          "https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-icon-theme/bfb687d78001efc15618eac7dd50e2e5104663ea/Papirus/64x64/apps/discord.svg";
        hash = "sha256-bWqauj67FUnXXbcZUOs/kkme0Cp/tub4YtoygFBCZwU=";
      };
    in ''
      rm -rf $out/share/icons/hicolor
      mkdir -p $out/share/icons/hicolor/512x512/apps
      convert -background none -density 568 -resize 512x512 ${logo} $out/share/icons/hicolor/512x512/apps/discord.png
      for i in 16 24 48 64 96 128 256; do
        mkdir -p $out/share/icons/hicolor/''${i}x''${i}/apps
        convert -background none -resize ''${i}x''${i} $out/share/icons/hicolor/512x512/apps/discord.png $out/share/icons/hicolor/''${i}x''${i}/apps/discord.png
      done 
    '';
  });
  # Also should be removed on update, but didn't see any PR for updating this?
  gnomeExtensions = prev.gnomeExtensions // {
    valent = prev.gnomeExtensions.valent.overrideAttrs (old: {
      src = prev.fetchFromGitHub {
        owner = "andyholmes";
        repo = "gnome-shell-extension-valent";
        rev = "449bb36f1019ac09b06aad6c12deffcc4f317738";
        hash = "sha256-jm+TYqgCalFgjJf0CJ2poFa1W0OS192DVI7DOxjEY+g=";
      };
    });
  };

}
