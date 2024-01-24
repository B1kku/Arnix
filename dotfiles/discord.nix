{ inputs, pkgs, ... }:

{
  home.packages = [
    pkgs.vesktop
  ];
  # Perhaps it'd be better to just add a desktopitems module instead?
  xdg.desktopEntries.vesktop = {
      name = "Discord";
      desktopName = "Discord";
      exec = "vesktop %U";
      icon = "discord";
      startupWMClass = "Discord";
      genericName = "Internet Messenger";
      keywords = [ "discord" "vencord" "electron" "chat" ];
      categories = [ "Network" "InstantMessaging" "Chat" ];
  }
}
