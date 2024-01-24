{ inputs, pkgs, ... }:

{
  home.packages = [
    pkgs.vesktop
  ];
  # Perhaps it'd be better to just add a desktopitems module instead?
  xdg.desktopEntries.vesktop = {
      name = "Discord";
      exec = "vesktop %U";
      icon = "discord";
      genericName = "Internet Messenger";
      categories = [ "Network" "InstantMessaging" "Chat" ];
  };
}
