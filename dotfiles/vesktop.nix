{ pkgs, pkgs-unstable, ... }:
let
  logo = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-icon-theme/bfb687d78001efc15618eac7dd50e2e5104663ea/Papirus/64x64/apps/discord.svg";
    hash = "sha256-bWqauj67FUnXXbcZUOs/kkme0Cp/tub4YtoygFBCZwU=";
  };
in
{
  home.file.".icons/discord.svg".source = logo;
  xdg.desktopEntries.vesktop = {
    name = "Discord";
    exec = "vesktop %U";
    icon = "discord";
    genericName = "Internet Messenger";
    categories = [
      "Network"
      "InstantMessaging"
      "Chat"
    ];
    settings = {
      X-desktopName = "Discord";
      X-keywords = "discord;vencord;electron;chat";
      X-startupWMClass = "Discord";
    };
  };
  home.packages = [ pkgs-unstable.vesktop ];
}
